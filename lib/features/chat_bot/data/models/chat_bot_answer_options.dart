import 'package:flutter/foundation.dart' show immutable;

@immutable
class ChatBotAnswerOptions {
  final int id;
  final String optionValue;
  final String optionText;

  const ChatBotAnswerOptions({
    required this.id,
    required this.optionValue,
    required this.optionText,
  });

  factory ChatBotAnswerOptions.fromJson(Map<String, dynamic> json) {
    return ChatBotAnswerOptions(
      id: json['id'] as int,
      optionValue: json['option_value'] as String,
      optionText: json['option_text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'option_value': optionValue, 'option_text': optionText};
  }
}
