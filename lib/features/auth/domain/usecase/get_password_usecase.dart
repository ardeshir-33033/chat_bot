import 'package:hesabo_chat_ai/features/core/usecase/usecase.dart';
import 'package:hesabo_chat_ai/features/auth/domain/repository/auth_repository.dart';
import 'package:hesabo_chat_ai/features/core/data/data_state.dart';

class GetPasswordUseCase implements UseCase<DataState<void>, String> {
  final AuthRepository _authRepository;

  GetPasswordUseCase(this._authRepository);

  @override
  Future<DataState<void>> call({required String params}) {
    return _authRepository.getPasswordStatus(phoneNumber: params);
  }
}
