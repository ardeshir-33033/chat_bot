import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:hesabo_chat_ai/di.dart';
import 'package:hesabo_chat_ai/features/chat_bot/data/models/chat_bot_answer_options.dart';
import 'package:hesabo_chat_ai/features/chat_bot/data/models/chat_bot_question_options.dart';
import 'package:hesabo_chat_ai/features/chat_bot/presentation/controller/chat_bot_controller.dart';
import 'package:hesabo_chat_ai/features/chat_bot/presentation/widgets/question_title_widget.dart';
import 'package:hesabo_chat_ai/core/components/chat_bot_button.dart';

class SelectAndTypeQuestionWidget extends StatefulWidget {
  final String question;
  final String? description;
  final List<ChatBotQuestionOptions> options;
  final int messageIndex;
  final void Function() onSubmit;

  const SelectAndTypeQuestionWidget({
    Key? key,
    required this.question,
    this.description,
    required this.messageIndex,
    required this.options,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<SelectAndTypeQuestionWidget> createState() =>
      _SelectAndTypeQuestionWidgetState();
}

class _SelectAndTypeQuestionWidgetState
    extends State<SelectAndTypeQuestionWidget> {
  final Map<int, bool> selected = {};
  final Map<int, TextEditingController> controllers = {};

  @override
  void dispose() {
    controllers.values.forEach((c) => c.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color(0xFF23244A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QuestionTitleWidget(
              question: widget.question,
              description: widget.description,
            ),

            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF000E22),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: List.generate(widget.options.length, (i) {
                  final option = widget.options[i];
                  final isChecked = selected[i] ?? false;
                  controllers[i] ??= TextEditingController();
                  return Column(
                    children: [
                      CheckboxListTile(
                        value: isChecked,
                        onChanged: (val) {
                          setState(() {
                            selected[i] = val ?? false;
                          });
                        },
                        title: Row(
                          children: [
                            Text(
                              option.optionText,
                              style: context.textTheme.titleSmall!.copyWith(
                                color: Colors.white,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Spacer(),
                            SizedBox(
                              width: 100,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: TextField(
                                  controller: controllers[i],
                                  style: context.textTheme.bodyMedium!.copyWith(
                                    color: Color(0xFF228ACA),
                                  ),
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText: 'مبلغ به ریال',
                                    hintStyle: context.textTheme.bodyMedium!
                                        .copyWith(color: Color(0xFF228ACA)),
                                    filled: true,
                                    fillColor: Color(0xFF181A2A),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.purpleAccent,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.purpleAccent,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 0,
                                      horizontal: 8,
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  textDirection: TextDirection.rtl,
                                ),
                              ),
                            ),
                          ],
                        ),
                        activeColor: Colors.blueAccent,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                      SizedBox(height: 4),
                    ],
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ChatBotButton(
                    variant: ButtonVariant.elevated,
                    color: Color(0xFF23244A),
                    borderSide: BorderSide(color: Colors.purpleAccent),
                    title: 'ادامه',
                    onPressed: selected.values.any((v) => v)
                        ? () async {
                            ChatBotController chatBotController =
                                locator<ChatBotController>();
                            chatBotController
                                    .chatBotMessages[widget.messageIndex]
                                    .chatBotAnswerOptions =
                                [];
                            selected.forEach((i, isChecked) {
                              if (isChecked) {
                                final option = widget.options[i];

                                chatBotController
                                    .chatBotMessages[widget.messageIndex]
                                    .chatBotAnswerOptions!
                                    .add(
                                      ChatBotAnswerOptions(
                                        id: option.id,
                                        optionValue: controllers[i]!.text,
                                        optionText: option.optionText,
                                      ),
                                    );
                              }
                            });
                            widget.onSubmit();
                          }
                        : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
