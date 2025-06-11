import 'package:hesabo_chat_ai/features/chat_bot/data/models/chat_bot_message.dart';
import 'package:hesabo_chat_ai/features/chat_bot/domain/repository/chat_bot_repository.dart';
import 'package:hesabo_chat_ai/features/core/data/data_state.dart';

import '../data_source/chat_data_source.dart';

class ChatBotRepositoryImpl extends ChatBotRepository {
  ChatBotRepositoryImpl(this._chatDataSource);

  final ChatDataSource _chatDataSource;

  @override
  Future<DataState<ChatBotMessage>> getWelcomeQuestion({
    bool? includeOptions = false,
    required order,
    required int step,
  }) async {
    try {
      final response = await _chatDataSource.getWelcomeQuestion(
        order: order,
        step: step,
      );

      return DataSuccess(response.data);
    } on Exception catch (e) {
      // if (e.error is ApiError) {
      return DataFailed(e.toString());
      // } else {
      //   e.errLog();
      //   TODO(hossein): create error handeling classes and use em
      // return const DataFailed('Error, try again');
      // }
    }
  }
}
