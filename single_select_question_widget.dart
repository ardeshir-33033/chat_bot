import 'package:flutter/material.dart';

class SingleSelectQuestionWidget extends StatelessWidget {
  final String question;
  final String? description;
  final List<String> options;
  final void Function(String) onSelected;

  const SingleSelectQuestionWidget({
    Key? key,
    required this.question,
    this.description,
    required this.options,
    required this.onSelected,
  }) : super(key: key);

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
              question,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            if (description != null) ...[
              SizedBox(height: 8),
              Text(
                description!,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF181A2A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: List.generate(options.length, (index) {
                  return InkWell(
                    onTap: () => onSelected(options[index]),
                    borderRadius: index == 0
                        ? BorderRadius.vertical(top: Radius.circular(12))
                        : index == options.length - 1
                            ? BorderRadius.vertical(bottom: Radius.circular(12))
                            : BorderRadius.zero,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: index == 0
                            ? BorderRadius.vertical(top: Radius.circular(12))
                            : index == options.length - 1
                                ? BorderRadius.vertical(bottom: Radius.circular(12))
                                : BorderRadius.zero,
                        color: Colors.transparent,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.chevron_left, color: Colors.white),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              options[index],
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 