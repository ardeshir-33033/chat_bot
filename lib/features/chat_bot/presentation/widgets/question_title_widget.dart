import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuestionTitleWidget extends StatelessWidget {
  const QuestionTitleWidget({
    super.key,
    required this.question,
    this.description,
  });

  final String question;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          question,
          style: context.textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        if (description != null) ...[
          SizedBox(height: 8),
          Text(description!, style: context.textTheme.bodyMedium),
        ],
      ],
    );
  }
}
