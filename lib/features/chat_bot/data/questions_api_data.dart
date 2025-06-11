class QuestionsApiData {
  int totalOrders = 5;
  List<int> ordersTotalSteps = [
    3,
    3,
    2,
    2,
    1,
  ];

  List<String> yesNoQuestions = ["has_fix_income", "has_expense_categories", "debt", ];
  List<String> multiSelectQuestions = ["user_goal", "fix_income_type", "most_recent_categories",];
  List<String> singleSelectQuestions = ["most_expense_categories", "sms_bank_permission"];
  List<String> textQuestions = ["income_amount", ];
  List<String> selectAndTypeQuestions = ["fix_income_list" , "expense_categories"];

}
enum QuestionType {
  yesNo,
  multiSelect,
  singleSelect,
  text,
  selectAndType,
}