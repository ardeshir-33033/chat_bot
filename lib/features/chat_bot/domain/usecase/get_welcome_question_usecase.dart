import 'package:hesabo_chat_ai/features/chat_bot/data/models/chat_bot_message.dart';
import 'package:hesabo_chat_ai/features/chat_bot/domain/repository/chat_bot_repository.dart';
import 'package:hesabo_chat_ai/features/core/usecase/usecase.dart';

import '../../../core/data/data_state.dart';

class GetWelcomeQuestionUseCase implements UseCase<DataState<ChatBotMessage>, int> {
  final ChatBotRepository _chatBotRepository;

  GetWelcomeQuestionUseCase(this._chatBotRepository);

  @override
  Future<DataState<ChatBotMessage>> call({required int params}) {
    return _chatBotRepository.getWelcomeQuestion(order: 1, step: params);
  }
}
