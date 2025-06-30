import 'dart:convert';

import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesabo_chat_ai/di.dart';
import 'package:hesabo_chat_ai/features/chat_bot/data/models/chat_bot_message.dart';
import 'package:hesabo_chat_ai/features/chat_bot/data/models/chatbot_answer_models/person_expectation_model.dart';
import 'package:hesabo_chat_ai/features/chat_bot/data/questions_api_data.dart';
import 'package:hesabo_chat_ai/features/chat_bot/presentation/widgets/answer_box.dart';
import 'package:hesabo_chat_ai/features/chat_bot/presentation/widgets/chat_bot_top_header.dart';
import 'package:hesabo_chat_ai/features/chat_bot/presentation/widgets/chat_box.dart';
import 'package:hesabo_chat_ai/features/chat_bot/presentation/widgets/multi_select_question_widget.dart';
import 'package:hesabo_chat_ai/features/chat_bot/presentation/widgets/select_type_question_widget.dart';
import 'package:hesabo_chat_ai/features/chat_bot/presentation/widgets/single_select_question_widget.dart';
import 'package:hesabo_chat_ai/features/chat_bot/presentation/widgets/yes_no_question_widget.dart';
import 'package:hesabo_chat_ai/features/core/components/app_header_bar.dart';
import 'package:hesabo_chat_ai/features/core/components/icon_widget.dart';
import 'package:hesabo_chat_ai/features/core/data/resalat_test.dart';
import 'package:hesabo_chat_ai/features/core/theme/constants.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:serious_python/serious_python.dart';

import '../../data/models/chat_bot_question_options.dart';
import '../../data/models/chatbot_answer_models/welcome_question_answer_model.dart';
import '../controller/chat_bot_controller.dart';
import '../widgets/text_question_widget.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  ChatBotController controller = locator<ChatBotController>();

  @override
  void initState() {
    controller.itemScrollController = ItemScrollController();
    controller.itemPositionsListener = ItemPositionsListener.create();
    controller.init();
    test();
    super.initState();
  }

  test() async {
    final ss = ResalatSmsParser.parseResalatSms(exampleSms1);
    print(ss);
    final ss2 = ResalatSmsParser.parseResalatSms(exampleSms2);
    print(ss2);
  }

  final String exampleSms1 = """
خرید
از: فروشگاه مواد غذایی
کارت: 1234
-15,000
مانده: 1,000,000
1404/06/25-10:30:15
12345.678.901
""";

  final String exampleSms2 = """
10.11668816.1
-40,000,000 
01/07_18:24
مانده: 217,000,104 
""";

  // Future<void> _parseSms() async {
  //   // setState(() {
  //   //   _pythonResult = "Parsing...";
  //   // });
  //
  //   try {
  //     final String smsTextToSend = exampleSms1;
  //
  //     // Call SeriousPython.run with the correct asset path and arguments
  //     final String? resultString = await SeriousPython.run(
  //       "app/python_code.zip",
  //       pythonArgs: [smsTextToSend], // Use 'pythonArgs' instead of 'arguments'
  //
  //       sync:
  //           true,
  //
  //     );
  //
  //     if (resultString != null && resultString.isNotEmpty) {
  //       // Decode the JSON string received from Python
  //       final Map<String, dynamic> pythonOutput = json.decode(resultString);
  //       final _pythonResult = const JsonEncoder.withIndent(
  //         '  ',
  //       ).convert(pythonOutput);
  //       print(_pythonResult);
  //     } else {
  //       // setState(() {
  //       //   _pythonResult =
  //       //       "Python script returned no output or an empty string.";
  //       // });
  //     }
  //   } catch (e) {
  //     // setState(() {
  //     //   _pythonResult = "Error running Python: $e";
  //     // });
  //     print("Python error details: $e"); // Print error to console for debugging
  //   }
  // }

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
                  Expanded(
                    child: ScrollablePositionedList.builder(
                      itemCount: controller.chatBotMessages.length,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemScrollController: controller.itemScrollController,
                      itemPositionsListener: controller.itemPositionsListener,
                      itemBuilder: (_, index) {
                        return getChatBoxWidget(
                          controller.chatBotMessages[index],
                          index,
                        );
                      },
                    ),
                  ),
                  // Chat Bubble
                  // Positioned(
                  //   top: 220,
                  //   right: 20,
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.end,
                  //     children: [
                  //       Container(
                  //         padding: EdgeInsets.all(16),
                  //         decoration: BoxDecoration(
                  //           color: Color(0xFF25405B),
                  //           borderRadius: BorderRadius.only(
                  //             topLeft: Radius.circular(20),
                  //             topRight: Radius.circular(20),
                  //             bottomLeft: Radius.circular(20),
                  //           ),
                  //         ),
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.end,
                  //           children: [
                  //             Row(
                  //               mainAxisSize: MainAxisSize.min,
                  //               children: [
                  //                 Text(
                  //                   'شما',
                  //                   style: TextStyle(
                  //                     color: Colors.white,
                  //                     fontWeight: FontWeight.bold,
                  //                   ),
                  //                 ),
                  //                 SizedBox(width: 8),
                  //                 Icon(Icons.person, color: Colors.white, size: 20),
                  //               ],
                  //             ),
                  //             SizedBox(height: 8),
                  //             Text(
                  //               'سلام، من آماده ام که شروع کنم',
                  //               style: TextStyle(color: Colors.white, fontSize: 16),
                  //             ),
                  //             SizedBox(height: 8),
                  //             Text(
                  //               '۱۲:۵۳',
                  //               style: TextStyle(
                  //                 color: Colors.white70,
                  //                 fontSize: 12,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // Input Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Transform.rotate(
                          angle: 180,
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
                        SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFF23244A),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.purpleAccent,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              'متن مورد نظر خود را تایپ کنید...',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
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
              dynamic model = prepareAnswerData(message, value);
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

              dynamic model = prepareAnswerData(
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
            question: message.systemQuestion!,
            options: message.options!,
            onSubmit: (value) {
              if (value.isEmpty) return;

              // dynamic model = prepareAnswerData(
              //   message,
              //   value.map((element) => element.id).toList(),
              // );
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
              if (value.isEmpty) return;

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
              dynamic model = prepareAnswerData(message, value);

              bool val = await controller.handleAnswer(message, model);
              if (val) {
                controller.transformQuestionToMessage(
                  index,
                  value ? ["بله"] : ["خیر"],
                );
              }
            },
          );
      }
    }
  }

  dynamic prepareAnswerData(ChatBotMessage message, dynamic rawAnswer) {
    switch (message.systemName) {
      case "has_fix_income":
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
        if ((rawAnswer as List<int>) != [10]) {
          controller.postPersonExpectation(
            PersonExpectationModel(personId: controller.userId, hasDebt: true),
          );
        }
        return WelcomeQuestionAnswerModel(
          questionId: message.id,
          selectedOptionIds: rawAnswer,
        );

      case "income_amount":
        return PersonExpectationModel(
          avgIncome: int.parse(rawAnswer),
          personId: controller.userId,
        );

      case "sms_bank_permission":
        return rawAnswer;

      // case "fix_income_list":
      //   return FixIncomeListModel(items: List<IncomeItem>.from(rawAnswer));

      default:
        return rawAnswer;
    }
  }
}
