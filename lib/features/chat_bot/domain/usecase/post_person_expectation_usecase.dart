import 'package:hesabo_chat_ai/core/data/data_state.dart';
import 'package:hesabo_chat_ai/features/chat_bot/data/models/chatbot_answer_models/person_expectation_model.dart';
import 'package:hesabo_chat_ai/features/chat_bot/domain/repository/chat_bot_repository.dart';
import 'package:hesabo_chat_ai/core/usecase/usecase.dart';

class PostPersonExpectationUseCase
    implements UseCase<DataState<void>, PersonExpectationModel> {
  final ChatBotRepository _chatBotRepository;

  PostPersonExpectationUseCase(this._chatBotRepository);

  @override
  Future<DataState<void>> call({required PersonExpectationModel params}) {
    return _chatBotRepository.postPersonExpectation(personExpectation: params);
  }
}
