
import 'package:hesabo_chat_ai/core/env/environment.dart';

class ChatBotRouting {
  static String baseRouting = "${Environment.getBaseUrl()}chatbot/coreapi/";
  static String baseAgentRouting = "${Environment.getBaseUrl()}chatbot/agents/";
  static String getChatBotWelcomeQuestionRouting =
      "${baseRouting}welcome_questions";
  static String postUserResponse = "${baseRouting}user_responses/";
  static String postPersonExpectation = "${baseRouting}person_expectations/";
  static String postAgentInteraction = "${baseAgentRouting}interact/";
  static String postBankAccount = "${baseRouting}bank_accounts/";
  static String postSmsTransactionBatch = "${baseRouting}transactions/batch/";
  static String postFixIncomeExpense = "${baseRouting}fix_income_expenses/";
  static String postMostExpenseCategory = "${baseRouting}most_expense_categories/";

}
