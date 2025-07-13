import 'package:hesabo_chat_ai/core/usecase/usecase.dart';
import 'package:hesabo_chat_ai/features/auth/domain/repository/auth_repository.dart';
import 'package:hesabo_chat_ai/core/data/data_state.dart';

class RegisterUseCase implements UseCase<DataState<String>, RegisterParams> {
  final AuthRepository _authRepository;

  RegisterUseCase(this._authRepository);

  @override
  Future<DataState<String>> call({required RegisterParams params}) {
    return _authRepository.register(
      phoneNumber: params.phoneNumber,
      password: params.password,
    );
  }
}

class RegisterParams {
  final String phoneNumber;
  final String password;

  RegisterParams({required this.phoneNumber, required this.password});
}
