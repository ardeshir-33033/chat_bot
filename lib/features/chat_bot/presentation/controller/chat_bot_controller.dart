import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:get/get.dart';
import 'package:hesabo_chat_ai/features/chat_bot/data/models/bank_account_model.dart';
import 'package:hesabo_chat_ai/features/chat_bot/data/models/chat_bot_message.dart'
    show ChatBotMessage;
import 'package:hesabo_chat_ai/features/chat_bot/data/questions_api_data.dart';
import 'package:hesabo_chat_ai/features/chat_bot/domain/usecase/get_welcome_question_usecase.dart';
import 'package:hesabo_chat_ai/features/core/data/data_state.dart';
import 'package:hesabo_chat_ai/features/core/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../core/data/bank_numbers.dart';
import '../../../core/data/bank_parsers.dart';
import '../../../core/data/bank_sms_model.dart';
import '../../data/models/chat_agent_models/chat_agent_request.dart';
import '../../data/models/chatbot_answer_models/welcome_question_answer_model.dart';
import '../../data/models/user_answer_model.dart';
import '../../domain/usecase/post_agent_interaction_usecase.dart';
import '../../domain/usecase/post_bank_account_usecase.dart';
import '../../domain/usecase/post_person_expectation_usecase.dart';
import '../../domain/usecase/post_user_response_usecase.dart';
import '../widgets/bank_sms_multi_select_widget.dart';

class ChatBotController extends GetxController {
  ChatBotController(
    this._getWelcomeQuestionUseCase,
    this._postUserResponseUseCase,
    this._postPersonExpectationUseCase,
    this._postAgentInteractionUseCase,
    this._postBankAccountUseCase,
  );

  final GetWelcomeQuestionUseCase _getWelcomeQuestionUseCase;
  final PostUserResponseUseCase _postUserResponseUseCase;
  final PostPersonExpectationUseCase _postPersonExpectationUseCase;
  final PostAgentInteractionUseCase _postAgentInteractionUseCase;
  final PostBankAccountUseCase _postBankAccountUseCase;

  late ItemScrollController itemScrollController;
  late ItemPositionsListener itemPositionsListener;

  List<ChatBotMessage> chatBotMessages = [];
  late final Map<String, AnswerProcessor> answerProcessors;
  List<BankSmsModel> foundBanks = [];

  int userId = 1;
  int systemId = 0;

  int currentOrder = 1;
  int currentStep = 1;

  int threadId = 184100;
  String currentUser = "4";

  @override
  void onInit() {
    super.onInit();

    answerProcessors = {
      "fix_income_type": welcomingQuestionsAnswer,
      // "has_expense_categories": processExpenseCategoriesAnswer,
      // "debt": processDebtAnswer,
      "user_goal": welcomingQuestionsAnswer,
      "income_amount": postPersonExpectation,
      // "sms_bank_permission": smsPermission,
      "has_fix_income": welcomingQuestionsAnswer,

      // "fix_income_list": fixIncomeExpense,
    };
  }

  init() async {
    addMessages('سلام، من آماده ام که شروع کنم');
    Future.delayed(Duration(milliseconds: 500), () {
      addMessages('سلام، فواد خوش حالم که اینجا می‌بینمت', fromUser: false);
    });
    Future.delayed(Duration(milliseconds: 1500), () {
      addMessages('آره بزن بریم', fromUser: true);
    });
    Future.delayed(Duration(milliseconds: 2500), () {
      addMessages('عالیه، بریم سراغ ۵ تا سوال', fromUser: false);
      getWelcomeQuestion();
    });
  }

  Future getWelcomeQuestion() async {
    final res = await _getWelcomeQuestionUseCase.call(
      params: GetWelcomeQuestionsParams(step: currentStep, order: currentOrder),
    );
    if (res is DataSuccess<ChatBotMessage>) {
      res.data.userId = userId.toString();
      chatBotMessages.add(res.data);

      update();
      scrollToLastMessage();
    } else {
      print(res);
    }
    print(res);
  }

  addMessages(
    String message, {
    bool fromUser = true,
    bool fromAgent = false,
    ChatBotMessage? chatMessage,
  }) {
    late ChatBotMessage chatBotMessage;
    if (chatMessage == null) {
      chatBotMessage = ChatBotMessage(
        id: getRandomNumber(),
        text: fromUser ? message : null,
        systemQuestion: fromUser ? null : message,
        systemName: message,
        userId: fromUser ? userId.toString() : systemId.toString(),
        fromAgent: fromAgent,
        createdAt: DateTime.now(),
      );
    } else {
      chatBotMessage = chatMessage;
    }

    chatBotMessages.add(chatBotMessage);
    scrollToLastMessage();
    update();
  }

  Future<bool> welcomingQuestionsAnswer(
    dynamic welcomeQuestionAnswerModel,
  ) async {
    final bool response = await sendAnswerToApi(
      UserAnswerModel(
        personId: userId,
        questionId: welcomeQuestionAnswerModel.questionId,
        selectedOptionIds: welcomeQuestionAnswerModel.selectedOptionIds,
        answerText: welcomeQuestionAnswerModel.textResponse,
      ),
    );
    if (response) {
      return true;
    } else {
      return false;
    }
  }

  Future sendAgentInteraction(String text) async {
    addMessages(text, fromUser: true);
    final res = await _postAgentInteractionUseCase(
      params: ChatAgentRequest(
        messages: [ChatAgentMessage(content: text, role: 'user')],
        threadId: threadId,
        stream: false,
        currentUser: currentUser,
      ),
    );

    if (res is DataSuccess<ChatBotMessage>) {
      addMessages(res.data.text!, fromUser: false, fromAgent: true);
    }
  }

  Future<bool> handleAnswer(ChatBotMessage message, dynamic answer) async {
    final processor = answerProcessors[message.systemName];

    if (processor != null) {
      bool res = await processor(answer);
      if (res) {
        increaseOrder();
        getWelcomeQuestion();
        return true;
      } else {
        return false;
      }
    } else {
      throw Exception("No processor for ${message.systemName}");
    }
  }

  Future<void> getAllSms() async {
    var status = await Permission.sms.status;
    if (!status.isGranted) {
      // Request permission if not granted
      status = await Permission.sms.request();
      if (!status.isGranted) {
        throw Exception('SMS permission denied');
      } else {
        SmsQuery query = SmsQuery();

        List<SmsMessage> messages = await query.querySms(
          kinds: [SmsQueryKind.inbox],
        );
        print(messages);
      }
    }
  }

  Future<void> processLastBankSms() async {
    var status = await Permission.sms.status;
    if (!status.isGranted) {
      status = await Permission.sms.request();
      if (!status.isGranted) {
        throw Exception('SMS permission denied');
      }
    }

    SmsQuery query = SmsQuery();
    List<SmsMessage> messages = await query.querySms(
      kinds: [SmsQueryKind.inbox],
      // Optional: Sort newest to oldest (some plugins already return sorted)
      sort: true,
    );
    List<BankSmsModel> lastSms = [];
    // Keep track of banks already processed
    final Set<String> processedBanks = {};

    for (var sms in messages) {
      if (processedBanks.length == BankNumberData.bankSmsNumbers.length) {
        break; // All known banks processed
      }

      final sender = sms.address?.replaceAll('+98', '0') ?? '';

      String? bankName;
      BankNumberData.bankSmsNumbers.forEach((number, name) {
        if (bankName != null) return; // already found

        if (number.startsWith('+98')) {
          if (sms.address == number) {
            bankName = name;
          }
        } else {
          if (sender.endsWith(number) || sms.address == number) {
            bankName = name;
          }
        }
      });

      if (bankName != null && !processedBanks.contains(bankName)) {
        final parsed = BankSmsParserDispatcher.parseBankSms(
          bankName!,
          sms.body ?? '',
        );
        if (parsed.error == null) {
          lastSms.add(parsed);
        }
        print('Latest SMS from $bankName: ${parsed.toString()}');
        processedBanks.add(bankName!);
      }
    }
    foundBanks = lastSms;
    print(lastSms);
  }

  getBankAccountOptions() {
    List<BankAccountOption> options = [];

    for (var element in foundBanks) {
      final option = createBankAccountOptionFromSms(
        element,
        QuestionsApiData().banks,
      );
      if (option != null) options.add(option);
    }
    print(options);
    addMessages(
      "",
      chatMessage: ChatBotMessage(
        id: getRandomNumber(),
        text: null,
        description:
            'از روی پیامک های بانکیت، بانک ها با موحودی هاشون پیدا و ثبت شدن. میتونی انتخاب کنی که کدوم بانک ها توی اپ نمایش داده بشن و یا اگر موجودی هاشون مشکل داره ویرایش کنی!',
        systemQuestion: "همه چی خوب پیش رفت",
        systemName: QuestionType.bankAccounts.toString(),
        userId: systemId.toString(),
        fromAgent: false,
        createdAt: DateTime.now(),
        bankAccountOptions: options,
        questionType: QuestionType.bankAccounts,
      ),
    );
  }

  BankAccountOption? createBankAccountOptionFromSms(
    BankSmsModel smsModel,
    List<Map<String, dynamic>> banksData,
  ) {
    if (smsModel.bankName == null) {
      return null; // Cannot match if bankName is null
    }

    // Normalize the SMS bank name for better matching
    final normalizedSmsBankName = smsModel.bankName!
        .trim()
        .toLowerCase()
        .replaceAll('بانک', '')
        .trim();

    // Find a matching bank
    Map<String, dynamic>? matchedBank;

    // First, try exact match or close match after normalization
    for (var bank in banksData) {
      final normalizedBankName = bank['bank_name']
          .trim()
          .toLowerCase()
          .replaceAll('ایران', '')
          .replaceAll('بانک', '')
          .trim();

      if (normalizedSmsBankName == normalizedBankName) {
        matchedBank = bank;
        break;
      }
      // More flexible matching: check if SMS bank name contains part of the bank name
      if (normalizedSmsBankName.contains(normalizedBankName) ||
          normalizedBankName.contains(normalizedSmsBankName)) {
        matchedBank = bank;
        break;
      }
    }

    // If no good match yet, try a broader search using keywords
    if (matchedBank == null) {
      for (var bank in banksData) {
        final bankName = bank['bank_name'].trim().toLowerCase();
        if (bankName.contains(normalizedSmsBankName) ||
            normalizedSmsBankName.contains(bankName)) {
          matchedBank = bank;
          break;
        }
      }
    }

    if (matchedBank != null) {
      return BankAccountOption(
        label: matchedBank['bank_name'] as String,
        svgAsset: matchedBank['logo'] as String,
        initialValue: smsModel.balance.toString(),
        bankId: matchedBank['id'] as int,
        accountNumber: smsModel.accountNumber,
        cardNumber: smsModel.cardNumber,
      );
    } else {
      // If no match is found, you might want to return null or a default/unknown option
      print("No matching bank found for SMS bank name: ${smsModel.bankName}");
      return null;
    }
  }

  postBankAccount(List<BankAccountOption> bankAccounts) async {
    for (var element in bankAccounts) {
      BankAccount(personId: userId, bankId: element.bankId, balance: double.parse(element.initialValue), accountNumber: element.);
      final res = await _postBankAccountUseCase(params: element);
    }
  }

  increaseStep() {
    if (QuestionsApiData.totalSteps == currentOrder) {
      //TODO: Navigate to next screen
    } else {
      currentStep++;
    }
  }

  increaseOrder() {
    if (QuestionsApiData.stepsTotalOrders[currentOrder - 1] == currentOrder) {
      currentOrder = 1;
      increaseStep();
    } else {
      currentOrder++;
    }
  }

  scrollToLastMessage() {
    if (chatBotMessages.length > 2) {
      itemScrollController.scrollTo(
        index: chatBotMessages.length,
        duration: Duration(milliseconds: 500),
      );
    }
  }

  transformQuestionToMessage(int index, List<String> answers) {
    chatBotMessages[index].options = null;
    chatBotMessages[index].text = answers.join('\n');
    update();
  }

  Future<bool> postPersonExpectation(dynamic personExpectation) async {
    final res = await _postPersonExpectationUseCase(params: personExpectation);
    if (res is DataSuccess) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> sendAnswerToApi(UserAnswerModel userAnswerModel) async {
    final res = await _postUserResponseUseCase.call(
      params: PostUserResponseUseCaseParams(userAnswerModel: userAnswerModel),
    );
    if (res is DataSuccess<void>) {
      return true;
    } else {
      return false;
    }
  }

  resetData() {
    chatBotMessages = [];
    foundBanks = [];
    currentOrder = 1;
    currentStep = 1;
    itemScrollController = ItemScrollController();
  }
}
