import 'package:hesabo_chat_ai/core/data/data_state.dart';
import 'package:hesabo_chat_ai/features/chat_bot/data/models/chat_bot_message.dart';
import 'package:hesabo_chat_ai/features/chat_bot/domain/repository/chat_bot_repository.dart';
import 'package:hesabo_chat_ai/core/usecase/usecase.dart';
import '../../data/models/chat_agent_models/chat_agent_request.dart';

class PostAgentInteractionUseCase
    implements UseCase<DataState<ChatBotMessage>, ChatAgentRequest> {
  final ChatBotRepository _chatBotRepository;

  PostAgentInteractionUseCase(this._chatBotRepository);

  @override
  Future<DataState<ChatBotMessage>> call({required ChatAgentRequest params}) {
    return _chatBotRepository.postAgentInteraction(chatAgentRequest: params);
  }
}
