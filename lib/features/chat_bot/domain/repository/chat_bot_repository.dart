import 'package:hesabo_chat_ai/features/chat_bot/data/models/chat_bot_message.dart';
import 'package:hesabo_chat_ai/features/core/data/data_state.dart';

abstract class ChatBotRepository {
  Future<DataState<ChatBotMessage>> getWelcomeQuestion({
    bool? includeOptions,
    required order,
    required int step,
  });
}
