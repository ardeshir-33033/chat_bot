import 'package:hesabo_chat_ai/core/data/data_state.dart';
import 'package:hesabo_chat_ai/features/chat_bot/data/models/chat_bot_message.dart';
import 'package:hesabo_chat_ai/features/chat_bot/domain/repository/chat_bot_repository.dart';
import 'package:hesabo_chat_ai/core/usecase/usecase.dart';


class GetWelcomeQuestionUseCase
    implements UseCase<DataState<ChatBotMessage>, GetWelcomeQuestionsParams> {
  final ChatBotRepository _chatBotRepository;

  GetWelcomeQuestionUseCase(this._chatBotRepository);

  @override
  Future<DataState<ChatBotMessage>> call(
      {required GetWelcomeQuestionsParams params}) {
    return _chatBotRepository.getWelcomeQuestion(
        order: params.order, step: params.step);
  }
}

class GetWelcomeQuestionsParams {
  int step;
  int order;

  GetWelcomeQuestionsParams({required this.order, required this.step});
}
