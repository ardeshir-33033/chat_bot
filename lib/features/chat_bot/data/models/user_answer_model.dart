class UserAnswerModel {
  final int personId;
  final int questionId;
  final List<int>? selectedOptionIds;
  final String? answerText;

  UserAnswerModel({
    required this.personId,
    required this.questionId,
    this.selectedOptionIds,
    this.answerText,
  });

  factory UserAnswerModel.fromJson(Map<String, dynamic> json) {
    return UserAnswerModel(
      personId: json['person_id'],
      questionId: json['question_id'],
      selectedOptionIds: List<int>.from(json['selected_option_ids'] ?? []),
      answerText: json['answer_text'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'person_id': personId,
      'question_id': questionId,
      'selected_option_ids': selectedOptionIds,
      'answer_text': answerText,
    };
  }
}
