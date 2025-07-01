import 'package:flutter/material.dart';

import '../questions_api_data.dart';
import 'chat_bot_question_options.dart';

class ChatBotMessage {
  final int id;
  final int? order;
  final int? step;
  String? text;
  final String systemName;
  String? userId;
  final String? systemQuestion;
  final DateTime? createdAt;
  bool fromAgent;
  List<ChatBotQuestionOptions>? options;
  QuestionType? questionType;

  ChatBotMessage({
    required this.id,
    this.order,
    this.step,
    required this.systemName,
    this.text,
    this.systemQuestion,
    this.userId,
    this.fromAgent = false,
    this.createdAt,
    this.options,
    this.questionType,
  });

  factory ChatBotMessage.fromJson(Map<String, dynamic> json) {
    var optionsListFromJson = json['options'] as List<dynamic>?;
    List<ChatBotQuestionOptions>? optionsList;
    if (optionsListFromJson != null) {
      optionsList = optionsListFromJson
          .map(
            (optionJson) => ChatBotQuestionOptions.fromJson(
              optionJson as Map<String, dynamic>,
            ),
          )
          .toList();
    }
    final questionType = QuestionsApiData().getQuestionTypeFromSystemName(
      json['system_name'],
    );

    return ChatBotMessage(
      id: json['id'] as int,
      order: json['order'] as int,
      step: json['step'] as int,
      systemQuestion: json['question_text'] as String,
      options: optionsList,
      systemName: json['system_name'] as String,
      questionType: questionType,
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order': order,
      'step': step,
      'question_text': systemQuestion,
      'system_name': systemName,
      'options': options?.map((option) => option.toJson()).toList(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatBotMessage &&
        other.id == id &&
        other.order == order &&
        other.step == step &&
        other.text == text &&
        other.systemName == systemName;
  }

  bool isQuestion() {
    if (options != null) {
      return true;
    } else {
      return false;
    }
  }

  bool isAnswer() {
    if (systemQuestion != null && options == null && text != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    return id.hashCode ^
        order.hashCode ^
        step.hashCode ^
        text.hashCode ^
        systemName.hashCode;
  }
}
