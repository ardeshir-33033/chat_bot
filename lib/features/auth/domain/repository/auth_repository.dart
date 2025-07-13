import 'package:hesabo_chat_ai/core/data/data_state.dart';
import 'package:hesabo_chat_ai/features/auth/data/models/auth_tokens_model.dart';

abstract class AuthRepository {
  Future<DataState<String>> register({
    required String phoneNumber,
    required String password,
  });

  Future<DataState<AuthTokens>> login({
    required String phoneNumber,
    required String password,
  });

  Future<DataState<AuthTokens>> verify({
    required String phoneNumber,
    required String code,
  });
}
