import 'package:hesabo_chat_ai/core/env/environment.dart';

class AuthRouting {
  static String baseRouting = "${Environment.getAuthBaseUrl()}chatbot/coreapi/";
  static String register = "${baseRouting}register/";
  static String login = "${baseRouting}login/";
  static String verify = "${baseRouting}register/verify/";
}
