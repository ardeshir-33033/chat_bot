import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesabo_chat_ai/features/chat_bot/data/models/chat_bot_question_options.dart';

import '../../../core/components/chat_bot_button.dart';

class MultiSelectQuestionWidget extends StatefulWidget {
  final String question;
  final String? description;
  final List<ChatBotQuestionOptions> options;
  final void Function(List<ChatBotQuestionOptions>) onSubmit;

  const MultiSelectQuestionWidget({
    Key? key,
    required this.question,
    this.description,
    required this.options,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<MultiSelectQuestionWidget> createState() =>
      _MultiSelectQuestionWidgetState();
}

class _MultiSelectQuestionWidgetState extends State<MultiSelectQuestionWidget> {
  List<ChatBotQuestionOptions> selected = [];

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
            Center(
              child: Text(
                widget.question,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            if (widget.description != null) ...[
              SizedBox(height: 8),
              Text(
                widget.description!,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF000E22),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: widget.options.map((option) {
                  final isChecked = selected.contains(option);
                  return Column(
                    children: [
                      CheckboxListTile(
                        value: isChecked,
                        onChanged: (val) {
                          setState(() {
                            if (val == true) {
                              selected.add(option);
                            } else {
                              selected.remove(option);
                            }
                          });
                        },
                        title: Text(
                          option.optionText,
                          style: context.textTheme.titleSmall!.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        activeColor: Colors.blueAccent,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                      if (widget.options.last != option)
                        Divider(color: Colors.grey, thickness: 0.5),
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
                    variant: ButtonVariant.outlined,
                    color: Color(0xFF23244A),
                    borderSide: BorderSide(color: Colors.purpleAccent),
                    onPressed: selected.isNotEmpty
                        ? () async => widget.onSubmit(selected)
                        : null,
                    title: 'ادامه',
                    titleStyle: TextStyle(color: Colors.white),
                    // style: ElevatedButton.styleFrom(
                    //   backgroundColor: Color(0xFF23244A),
                    //   side: BorderSide(color: Colors.purpleAccent),
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(16),
                    //   ),
                    // ),
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
