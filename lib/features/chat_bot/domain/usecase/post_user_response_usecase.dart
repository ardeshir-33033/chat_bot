import 'package:hesabo_chat_ai/core/data/data_state.dart';
import 'package:hesabo_chat_ai/features/chat_bot/data/models/chat_bot_message.dart';
import 'package:hesabo_chat_ai/features/chat_bot/domain/repository/chat_bot_repository.dart';
import 'package:hesabo_chat_ai/core/usecase/usecase.dart';
import '../../data/models/user_answer_model.dart';

class PostUserResponseUseCase
    implements UseCase<DataState<void>, PostUserResponseUseCaseParams> {
  final ChatBotRepository _chatBotRepository;

  PostUserResponseUseCase(this._chatBotRepository);

  @override
  Future<DataState<void>> call({
    required PostUserResponseUseCaseParams params,
  }) {
    return _chatBotRepository.postUserResponse(userAnswerModel: params.userAnswerModel);
  }
}

class PostUserResponseUseCaseParams {
  UserAnswerModel userAnswerModel;

  PostUserResponseUseCaseParams({required this.userAnswerModel});
}
