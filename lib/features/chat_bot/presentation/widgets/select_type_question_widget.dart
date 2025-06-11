import 'package:flutter/material.dart';
import 'package:hesabo_chat_ai/features/chat_bot/presentation/widgets/question_title_widget.dart';

class SelectAndTypeOption {
  final String label;
  final String? inputValue;

  SelectAndTypeOption({required this.label, this.inputValue});
}

class SelectAndTypeQuestionWidget extends StatefulWidget {
  final String question;
  final String? description;
  final List<SelectAndTypeOption> options;
  final void Function(List<Map<String, String>>) onSubmit;

  const SelectAndTypeQuestionWidget({
    Key? key,
    required this.question,
    this.description,
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
                              option.label,
                              style: TextStyle(color: Colors.white),
                            ),
                            Spacer(),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              width: 200,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: TextField(
                                  controller: controllers[i],
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'مبلغ به ریال',
                                    hintStyle: TextStyle(color: Colors.white54),
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
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF23244A),
                      side: BorderSide(color: Colors.purpleAccent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: selected.values.any((v) => v)
                        ? () {
                            final result = <Map<String, String>>[];
                            selected.forEach((i, isChecked) {
                              if (isChecked) {
                                final option = widget.options[i];
                                result.add({
                                  'label': option.label,
                                  'value': (controllers[i]?.text ?? ''),
                                });
                              }
                            });
                            widget.onSubmit(result);
                          }
                        : null,
                    child: Text('ادامه', style: TextStyle(color: Colors.white)),
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
