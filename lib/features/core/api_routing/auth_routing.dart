import 'package:hesabo_chat_ai/features/core/env/environment.dart';

class AuthRouting {
  static String baseRouting = "${Environment.getAuthBaseUrl()}idp/api/v1/";
  static String passwordStatusRoute = "${baseRouting}Users/status";
  static String login = "${baseRouting}Auth/login";
}
