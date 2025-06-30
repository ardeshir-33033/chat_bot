import 'package:hesabo_chat_ai/features/core/env/environment.dart';

class ChatBotRouting {
  static String baseRouting = "${Environment.getBaseUrl()}chatbot/coreapi/";
  static String getChatBotWelcomeQuestionRouting =
      "${baseRouting}welcome_questions";
  static String postUserResponse = "${baseRouting}user_responses/";
  static String postPersonExpectation = "${baseRouting}person_expectations/";
  // "${baseRouting}user_responses";
}
