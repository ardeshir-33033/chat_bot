import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesabo_chat_ai/di.dart';
import 'package:hesabo_chat_ai/features/chat_bot/data/models/chat_bot_message.dart';
import 'package:hesabo_chat_ai/features/chat_bot/data/questions_api_data.dart';
import 'package:hesabo_chat_ai/features/chat_bot/presentation/widgets/chat_bot_top_header.dart';
import 'package:hesabo_chat_ai/features/chat_bot/presentation/widgets/chat_box.dart';
import 'package:hesabo_chat_ai/features/chat_bot/presentation/widgets/multi_select_question_widget.dart';
import 'package:hesabo_chat_ai/features/chat_bot/presentation/widgets/select_type_question_widget.dart';
import 'package:hesabo_chat_ai/features/chat_bot/presentation/widgets/single_select_question_widget.dart';
import 'package:hesabo_chat_ai/features/chat_bot/presentation/widgets/yes_no_question_widget.dart';
import 'package:hesabo_chat_ai/features/core/components/app_header_bar.dart';
import 'package:hesabo_chat_ai/features/core/components/icon_widget.dart';
import 'package:hesabo_chat_ai/features/core/theme/constants.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../data/models/chat_bot_question_options.dart';
import '../controller/chat_bot_controller.dart';
import '../widgets/text_question_widget.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  ChatBotController controller = locator<ChatBotController>();

  @override
  void initState() {
    controller.init();
    super.initState();
  }

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
                      itemScrollController: _itemScrollController,
                      itemPositionsListener: _itemPositionsListener,
                      itemBuilder: (_, index) {
                        return getChatBoxWidget(
                            controller.chatBotMessages[index]);
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

  getChatBoxWidget(ChatBotMessage message) {
    if (!message.isQuestion()) {
      return ChatBox(content: message);
    } else {
      final result = message.questionType!;
      switch (result) {
        case QuestionType.text:
          return TextQuestionWidget(
            question: message.systemQuestion!,
            hintText: '',
            onSubmit: (value) {
              controller.sendResponse(
                QuestionType.text,
                questionId: message.id,
                textResponse: value,
              );
            },
          );
        case QuestionType.multiSelect:
          return MultiSelectQuestionWidget(
              question: message.systemQuestion!,
              options: message.options!,
              onSubmit: (val) {
                controller.sendResponse(QuestionType.multiSelect,
                    questionId: message.id,
                    responses: val.map((element) => element.id).toList());
              });
        case QuestionType.selectAndType:
          return SelectAndTypeQuestionWidget(
              question: 'question',
              options: message.options!,
              onSubmit: (val) {
                controller.sendResponse(
                  QuestionType.selectAndType,
                  questionId: message.id,
                  // textResponse: value,
                );
              });
        case QuestionType.singleSelect:
          return SingleSelectQuestionWidget(
            question: 'question',
            options: message.options!,
            onSelected: (value) {
              controller.sendResponse(QuestionType.singleSelect,
                  questionId: message.id, response: int.parse(value)
                  // textResponse: value,
                  );
            },
          );
        case QuestionType.yesNo:
          return YesNoQuestionWidget(
            question: 'question',
            onAnswered: (value) {
              controller.sendResponse(
                QuestionType.singleSelect,
                questionId: message.id,
                response: value ? 1 : 0,
                // textResponse: value,
              );
            },
          );
      }
    }
  }
}
