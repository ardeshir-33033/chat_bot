import 'package:dio/dio.dart';
import 'package:hesabo_chat_ai/features/auth/data/data_source/auth_data_source.dart';
import 'package:hesabo_chat_ai/features/auth/data/models/auth_tokens_model.dart';
import 'package:hesabo_chat_ai/features/auth/domain/repository/auth_repository.dart';
import 'package:hesabo_chat_ai/core/data/data_state.dart';

class AuthRepositoryImpl extends AuthRepository {
  AuthRepositoryImpl(this._authDataSource);

  final AuthDataSource _authDataSource;

  @override
  Future<DataState<String>> register({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final response = await _authDataSource.register(
        phoneNumber: phoneNumber,
        password: password,
      );
      return DataSuccess(response.data);
    } on Exception catch (e) {
      // if (e.error is ApiError) {
      if (e is DioException) {
        // Handle DioException specifically
        return DataFailed(
          e.response!.data['error'] ?? 'Network error occurred',
        );
      }
      return DataFailed(e.toString());
      // } else {
      //   e.errLog();
      // return const DataFailed('Error, try again');
      // }
    }
  }

  @override
  Future<DataState<AuthTokens>> login({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final response = await _authDataSource.login(
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

  @override
  Future<DataState<AuthTokens>> verify({
    required String phoneNumber,
    required String code,
  }) async {
    try {
      final response = await _authDataSource.verify(
        phoneNumber: phoneNumber,
        code: code,
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
