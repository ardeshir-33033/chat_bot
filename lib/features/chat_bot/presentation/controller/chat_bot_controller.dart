import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:get/get.dart';
import 'package:hesabo_chat_ai/features/chat_bot/data/models/chat_bot_message.dart'
    show ChatBotMessage;
import 'package:hesabo_chat_ai/features/chat_bot/data/questions_api_data.dart';
import 'package:hesabo_chat_ai/features/chat_bot/domain/usecase/get_welcome_question_usecase.dart';
import 'package:hesabo_chat_ai/features/core/data/data_state.dart';
import 'package:hesabo_chat_ai/features/core/utils/utils.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../data/models/chatbot_answer_models/welcome_question_answer_model.dart';
import '../../data/models/user_answer_model.dart';
import '../../domain/usecase/post_person_expectation_usecase.dart';
import '../../domain/usecase/post_user_response_usecase.dart';

class ChatBotController extends GetxController {
  ChatBotController(
    this._getWelcomeQuestionUseCase,
    this._postUserResponseUseCase,
    this._postPersonExpectationUseCase,
  );

  final GetWelcomeQuestionUseCase _getWelcomeQuestionUseCase;
  final PostUserResponseUseCase _postUserResponseUseCase;
  final PostPersonExpectationUseCase _postPersonExpectationUseCase;

  late ItemScrollController itemScrollController;
  late ItemPositionsListener itemPositionsListener;

  List<ChatBotMessage> chatBotMessages = [];
  late final Map<String, AnswerProcessor> answerProcessors;

  int userId = 1;
  int systemId = 0;

  int currentOrder = 1;
  int currentStep = 1;

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

  addMessages(String message, {bool fromUser = true}) {
    ChatBotMessage chatBotMessage = ChatBotMessage(
      id: getRandomNumber(),
      text: fromUser ? message : null,
      systemQuestion: fromUser ? null : message,
      systemName: message,
      userId: fromUser ? userId.toString() : systemId.toString(),
      createdAt: DateTime.now(),
    );
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

  // Future<bool> getAllSms() async {
  //   SmsQuery query = SmsQuery();
  //
  //   List<SmsMessage> messages = await query.querySms(
  //     kinds: [SmsQueryKind.inbox],
  //   );
  //
  // }

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
    currentOrder = 1;
    currentStep = 1;
    itemScrollController = ItemScrollController();
  }
}
