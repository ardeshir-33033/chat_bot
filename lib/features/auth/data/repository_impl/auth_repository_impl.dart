import 'package:hesabo_chat_ai/features/auth/data/data_source/auth_data_source.dart';
import 'package:hesabo_chat_ai/features/auth/domain/repository/auth_repository.dart';
import 'package:hesabo_chat_ai/features/core/data/data_state.dart';

class AuthRepositoryImpl extends AuthRepository {
  AuthRepositoryImpl(this._authDataSource);

  final AuthDataSource _authDataSource;

  @override
  Future<DataState<void>> getPasswordStatus({
    required String phoneNumber,
  }) async {
    try {
      final response = await _authDataSource.getPasswordStatus(
        phoneNumber: phoneNumber,
      );
      return DataSuccess(response.data);
    } on Exception catch (e) {
      // if (e.error is ApiError) {
      return DataFailed(e.toString());
      // } else {
      //   e.errLog();
      // return const DataFailed('Error, try again');
      // }
    }
  }

  @override
  Future<DataState<void>> postLogin({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final response = await _authDataSource.postLogin(
        phoneNumber: phoneNumber,
        password: password,
      );
      return DataSuccess(response.data);
    } on Exception catch (e) {
      // if (e.error is ApiError) {
      return DataFailed(e.toString());
      // } else {
      //   e.errLog();
      // return const DataFailed('Error, try again');
      // }
    }
  }
}
