import 'package:flutter/foundation.dart' show immutable;

@immutable
class ChatBotQuestionOptions {
  final int id;
  final int welcomeQuestionId; // Corresponds to welcome_question_id
  final String optionText;      // Corresponds to option_text

  const ChatBotQuestionOptions({
    required this.id,
    required this.welcomeQuestionId,
    required this.optionText,
  });

  factory ChatBotQuestionOptions.fromJson(Map<String, dynamic> json) {
    return ChatBotQuestionOptions(
      id: json['id'] as int,
      welcomeQuestionId: json['welcome_question_id'] as int,
      optionText: json['option_text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'welcome_question_id': welcomeQuestionId,
      'option_text': optionText,
    };
  }

  @override
  String toString() {
    return 'Option(id: $id, welcomeQuestionId: $welcomeQuestionId, optionText: "$optionText")';
  }


  @override
  int get hashCode => id.hashCode ^ welcomeQuestionId.hashCode ^ optionText.hashCode;
}