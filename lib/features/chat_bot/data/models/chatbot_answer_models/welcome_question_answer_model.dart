class WelcomeQuestionAnswerModel {
  int questionId;
  String? textResponse;
  List<int>? selectedOptionIds;

  WelcomeQuestionAnswerModel({
    required this.questionId,
    this.textResponse,
    this.selectedOptionIds,
  });
}
