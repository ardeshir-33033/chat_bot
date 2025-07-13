import 'package:hesabo_chat_ai/core/usecase/usecase.dart';
import 'package:hesabo_chat_ai/features/auth/data/models/auth_tokens_model.dart';
import 'package:hesabo_chat_ai/features/auth/domain/repository/auth_repository.dart';
import 'package:hesabo_chat_ai/core/data/data_state.dart';

class VerifyUseCase implements UseCase<DataState<AuthTokens>, VerifyParams> {
  final AuthRepository _authRepository;

  VerifyUseCase(this._authRepository);

  @override
  Future<DataState<AuthTokens>> call({required VerifyParams params}) {
    return _authRepository.verify(
      phoneNumber: params.phoneNumber,
      code: params.code,
    );
  }
}

class VerifyParams {
  final String phoneNumber;
  final String code;

  VerifyParams({required this.phoneNumber, required this.code});
}
