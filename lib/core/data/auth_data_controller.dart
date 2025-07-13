import 'package:get/get.dart';
import 'package:hesabo_chat_ai/features/auth/data/models/auth_tokens_model.dart';

class AuthDataController extends GetxController {
  late AuthTokens _authTokens;

  set authTokens(AuthTokens tokens) {
    _authTokens = tokens;
  }

  AuthTokens get authTokens => _authTokens;

  String get accessToken => _authTokens.access;

  String get refreshToken => _authTokens.refresh;

  int get userId => _authTokens.personId;
}
