import 'package:flutter/material.dart';

class TextQuestionWidget extends StatefulWidget {
  final String question;
  final String? description;
  final String hintText;
  final void Function(String) onSubmit;

  const TextQuestionWidget({
    Key? key,
    required this.question,
    this.description,
    required this.hintText,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<TextQuestionWidget> createState() => _TextQuestionWidgetState();
}

class _TextQuestionWidgetState extends State<TextQuestionWidget> {
  final controller = TextEditingController();

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
            Text(
              widget.question,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
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
            TextField(
              controller: controller,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Color(0xFF181A2A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.purpleAccent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.purpleAccent),
                ),
              ),
              textDirection: TextDirection.rtl,
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
                    onPressed: controller.text.isNotEmpty
                        ? () => widget.onSubmit(controller.text)
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
