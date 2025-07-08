import 'package:hesabo_chat_ai/features/core/usecase/usecase.dart';
import 'package:hesabo_chat_ai/features/auth/domain/repository/auth_repository.dart';
import 'package:hesabo_chat_ai/features/core/data/data_state.dart';

class LoginUseCase implements UseCase<DataState<void>, LoginParams> {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  @override
  Future<DataState<void>> call({required LoginParams params}) {
    return _authRepository.postLogin(
      phoneNumber: params.phoneNumber,
      password: params.password,
    );
  }
}

class LoginParams {
  final String phoneNumber;
  final String password;

  LoginParams({required this.phoneNumber, required this.password});
}
