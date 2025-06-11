class QuestionsApiData {
 static int totalOrders = 5;
 static List<int> ordersTotalSteps = [
    3,
    3,
    2,
    2,
    1,
  ];

 QuestionType getQuestionTypeFromSystemName(String systemName) {
   const yesNoNames = {'has_fix_income', 'has_expense_categories', 'debt'};
   const multiSelectNames = {"user_goal", "fix_income_type", "most_recent_categories",};
   const singleSelectNames = {"most_expense_categories", "sms_bank_permission"};
   const textNames = {"income_amount",};
   const selectAndTypeNames = {"fix_income_list" , "expense_categories"};

   if (yesNoNames.contains(systemName)) return QuestionType.yesNo;
   if (multiSelectNames.contains(systemName)) return QuestionType.multiSelect;
   if (singleSelectNames.contains(systemName)) return QuestionType.singleSelect;
   if (textNames.contains(systemName)) return QuestionType.text;
   if (selectAndTypeNames.contains(systemName)) return QuestionType.selectAndType;

   throw Exception('Unknown system name: $systemName');
 }

}
enum QuestionType {
  yesNo,
  multiSelect,
  singleSelect,
  text,
  selectAndType,
}