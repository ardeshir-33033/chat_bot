import 'package:hesabo_chat_ai/features/core/data/data_state.dart';

abstract class AuthRepository {
  Future<DataState<void>> getPasswordStatus({required String phoneNumber});

  Future<DataState<void>> postLogin({
    required String phoneNumber,
    required String password,
  });
}
