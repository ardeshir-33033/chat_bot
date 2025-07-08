import 'dart:convert';

import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesabo_chat_ai/di.dart';
import 'package:hesabo_chat_ai/features/chat_bot/data/models/chat_bot_message.dart';
import 'package:hesabo_chat_ai/features/chat_bot/data/models/chatbot_answer_models/person_expectation_model.dart';
import 'package:hesabo_chat_ai/features/chat_bot/data/models/income_expense_model.dart';
import 'package:hesabo_chat_ai/features/chat_bot/data/questions_api_data.dart';
import 'package:hesabo_chat_ai/features/chat_bot/presentation/widgets/answer_box.dart';
import 'package:hesabo_chat_ai/features/chat_bot/presentation/widgets/chat_bot_meta_data_widgets.dart';
import 'package:hesabo_chat_ai/features/chat_bot/presentation/widgets/chat_bot_top_header.dart';
import 'package:hesabo_chat_ai/features/chat_bot/presentation/widgets/chat_box.dart';
import 'package:hesabo_chat_ai/features/chat_bot/presentation/widgets/multi_select_question_widget.dart';
import 'package:hesabo_chat_ai/features/chat_bot/presentation/widgets/select_type_question_widget.dart';
import 'package:hesabo_chat_ai/features/chat_bot/presentation/widgets/single_select_question_widget.dart';
import 'package:hesabo_chat_ai/features/chat_bot/presentation/widgets/yes_no_question_widget.dart';
import 'package:hesabo_chat_ai/features/core/components/app_header_bar.dart';
import 'package:hesabo_chat_ai/features/core/components/icon_widget.dart';
import 'package:hesabo_chat_ai/features/core/data/ayandeh_parser.dart';
import 'package:hesabo_chat_ai/features/core/data/blu_parser.dart';
import 'package:hesabo_chat_ai/features/core/data/maskan_parser.dart';
import 'package:hesabo_chat_ai/features/core/data/melli_parser.dart';
import 'package:hesabo_chat_ai/features/core/data/pasargad_parser.dart';
import 'package:hesabo_chat_ai/features/core/data/resalat_parser.dart';
import 'package:hesabo_chat_ai/features/core/data/saderat_parser.dart';
import 'package:hesabo_chat_ai/features/core/extensions/extensions.dart';
import 'package:hesabo_chat_ai/features/core/theme/constants.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
// import 'package:serious_python/serious_python.dart';

import '../../../core/components/loading_overlay_manager.dart';
import '../../data/models/chat_bot_question_options.dart';
import '../../data/models/chatbot_answer_models/welcome_question_answer_model.dart';
import '../controller/chat_bot_controller.dart';
import '../widgets/bank_sms_multi_select_widget.dart';
import '../widgets/text_question_widget.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  ChatBotController controller = locator<ChatBotController>();
  final TextEditingController textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    controller.itemScrollController = ItemScrollController();
    controller.itemPositionsListener = ItemPositionsListener.create();
    controller.init();
    // test();
    super.initState();
  }

  test() async {
    await controller.processLastBankSms();
    await controller.getBankAccountOptions();
    // final ss = AyandehSmsParser.parseAyandehSms(exampleSms1);
    // print(ss);

    // final ss = ResalatSmsParser.parseResalatSms(exampleSms1);
    // print(ss);
    // final ss2 = ResalatSmsParser.parseResalatSms(exampleSms2);
    // print(ss2);
  }

  final String exampleSms1 = """
بانک آينده
انتقال به كارت
+3,000,000
مانده:33,755,006
کارت5812
040206-13:29 
""";

  final String exampleSms2 = """
 بلو
پرداخت قبض
مجتبی عزیز، 1,450,000 ریال بابت پرداخت قبض تلفن همراه از حساب شما پرید.
موجودی: 3,240,886 ریال
۱۲:۲۲
۱۴۰۴.۰۲.۰۹ 
""";

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: GetBuilder<ChatBotController>(
        builder: (logic) {
          return Scaffold(
            backgroundColor: Color(0xFF181A2A),
            body: SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 200, child: ChatBotTopHeader()),
                  ChatBotMetaDataWidgets(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 5,
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: ScrollablePositionedList.builder(
                              itemCount: controller.chatBotMessages.length,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              itemScrollController:
                                  controller.itemScrollController,
                              itemPositionsListener:
                                  controller.itemPositionsListener,
                              itemBuilder: (_, index) {
                                return getChatBoxWidget(
                                  controller.chatBotMessages[index],
                                  index,
                                );
                              },
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Transform.rotate(
                                  angle: 180,
                                  child: InkWell(
                                    onTap: () {
                                      if (textEditingController
                                          .text
                                          .isNotEmpty) {
                                        focusNode.unfocus();
                                        controller.sendAgentInteraction(
                                          textEditingController.text,
                                        );
                                        textEditingController.clear();
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFF181A2A),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: EdgeInsets.all(8),
                                      child: IconWidget(
                                        icon: Icons.send,
                                        iconColor: Colors.blueAccent,
                                        size: 32,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: TextField(
                                    controller: textEditingController,
                                    focusNode: focusNode,
                                    // You'll need to create and manage this controller
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                    textInputAction: TextInputAction.send,
                                    onSubmitted: (value) {
                                      controller.sendAgentInteraction(value);
                                      textEditingController.clear();
                                      focusNode.unfocus();
                                    },
                                    textDirection: TextDirection.rtl,
                                    decoration: InputDecoration(
                                      hintText:
                                          'متن مورد نظر خود را تایپ کنید...',
                                      hintStyle: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 16,
                                      ),
                                      hintTextDirection: TextDirection.rtl,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      filled: true,
                                      fillColor: Color(0xFF23244A),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                          color: Colors.purpleAccent,
                                          width: 2,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                          color: Colors.purpleAccent,
                                          width: 2,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                          color: Colors.purpleAccent,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  getChatBoxWidget(ChatBotMessage message, int index) {
    if (!message.isQuestion()) {
      if (message.isAnswer()) {
        return AnswerBox(content: message);
      }
      return ChatBox(content: message);
    } else {
      final result = message.questionType!;
      switch (result) {
        case QuestionType.text:
          return TextQuestionWidget(
            question: message.systemQuestion!,
            hintText: '',
            onSubmit: (value) async {
              if (value.isEmpty) return;
              dynamic model = await prepareAnswerData(message, value);
              bool val = await controller.handleAnswer(
                message,
                model,
                // QuestionType.text,
                // questionId: message.id,
                // textResponse: value,
              );
              if (val) {
                controller.transformQuestionToMessage(index, [value]);
              }
            },
          );
        case QuestionType.multiSelect:
          return MultiSelectQuestionWidget(
            question: message.systemQuestion!,
            options: message.options!,
            onSubmit: (value) async {
              if (value.isEmpty) return;

              dynamic model = await prepareAnswerData(
                message,
                value.map((element) => element.id).toList(),
              );

              bool val = await controller.handleAnswer(
                message,
                model,
                // QuestionType.multiSelect,
                // questionId: message.id,
                // selectedOptionIds: value.map((element) => element.id).toList(),
              );
              if (val) {
                controller.transformQuestionToMessage(
                  index,
                  value.map((element) => element.optionText).toList(),
                );
              }
            },
          );
        case QuestionType.selectAndType:
          return SelectAndTypeQuestionWidget(
            messageIndex: index,
            question: message.systemQuestion!,
            options: message.options!,
            onSubmit: () async {
              await prepareAnswerData(message, null);
              // controller.sendResponse(
              //   QuestionType.selectAndType,
              //   questionId: message.id,
              //   // textResponse: value,
              // );
            },
          );
        case QuestionType.singleSelect:
          return SingleSelectQuestionWidget(
            question: message.systemQuestion!,
            options: message.options!,
            onSelected: (value) async {
              // if (value.isEmpty) return;
              await prepareAnswerData(message, value);

              // final val = await controller.sendResponse(
              //   QuestionType.singleSelect,
              //   questionId: message.id,
              //   selectedOptionIds: [int.parse(value)],
              //   // textResponse: value,
              // );
              // if (val) {
              //   controller.transformQuestionToMessage(index, [value]);
              // }
            },
          );
        case QuestionType.yesNo:
          return YesNoQuestionWidget(
            question: message.systemQuestion!,
            onAnswered: (value) async {
              dynamic model = await prepareAnswerData(message, value);

              if (message.systemName != "sms_bank_permission") {
                bool val = await controller.handleAnswer(message, model);
                if (val) {
                  controller.transformQuestionToMessage(
                    index,
                    value ? ["بله"] : ["خیر"],
                  );
                }
              }
            },
          );
        case QuestionType.bankAccounts:
          return BankAccountMultiSelectWidget(
            question: message.systemQuestion!,
            description: message.description,
            options: message.bankAccountOptions ?? [],
            onSubmit: (value) async {
              await controller.sendBanksAndSmsData(
                context,
                bankAccounts: value,
              );
            },
          );
      }
    }
  }

  dynamic prepareAnswerData(ChatBotMessage message, dynamic rawAnswer) async {
    switch (message.systemName) {
      case "has_fix_income":
        return WelcomeQuestionAnswerModel(
          questionId: message.id,
          selectedOptionIds: rawAnswer
              ? [message.options!.first.id]
              : [message.options![1].id],
        );
      case "user_goal":
        return WelcomeQuestionAnswerModel(
          questionId: message.id,
          selectedOptionIds: rawAnswer,
        );
      case "fix_income_type":
        return WelcomeQuestionAnswerModel(
          questionId: message.id,
          selectedOptionIds: rawAnswer,
        );

      // case "has_expense_categories":
      //   return List<int>.from(rawAnswer);
      //
      case "debt":
        final model = WelcomeQuestionAnswerModel(
          questionId: message.id,
          selectedOptionIds: [(rawAnswer as ChatBotQuestionOptions).id],
        );
        controller.transformQuestionToMessage(
          controller.chatBotMessages.length - 1,
          [(rawAnswer).optionText],
        );
        await controller.handleAnswer(message, model);

      case "income_amount":
        return PersonExpectationModel(
          avgIncome: (rawAnswer as String).farsiToInt(),
          personId: controller.userId,
        );

      case "sms_bank_permission":
        controller.transformQuestionToMessage(
          controller.chatBotMessages.length - 1,
          rawAnswer ? ["بله"] : ["خیر"],
        );
        LoadingOverlayManager.show(context, message: 'در حال ارسال...');
        await controller.processSmsPermission(rawAnswer);
        LoadingOverlayManager.hide();
        return rawAnswer;

      case "fix_income_list":
        List<IncomeExpenseModel> expenses = [];
        for (var element in message.chatBotAnswerOptions!) {
          final index = message.options!.indexWhere(
            (option) => element.id == option.id,
          );
          expenses.add(
            IncomeExpenseModel(
              title: message.options![index].optionText,
              amount: double.parse(element.optionValue),
              personId: controller.userId,
            ),
          );
        }

        await controller.sendFixExpensesIncomeData(expenses);
      // return FixIncomeListModel(items: List<IncomeItem>.from(rawAnswer));

      default:
        return rawAnswer;
    }
  }
}
