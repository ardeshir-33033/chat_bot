import 'package:hesabo_chat_ai/features/chat_bot/data/models/chat_bot_message.dart';
import 'package:hesabo_chat_ai/features/chat_bot/data/models/user_answer_model.dart';
import 'package:hesabo_chat_ai/features/core/data/data_state.dart';

import '../../data/models/chatbot_answer_models/person_expectation_model.dart';

abstract class ChatBotRepository {
  Future<DataState<ChatBotMessage>> getWelcomeQuestion({
    bool? includeOptions,
    required order,
    required int step,
  });

  Future<DataState<void>> postUserResponse({
    required UserAnswerModel userAnswerModel,
  });

  Future<DataState<void>> postPersonExpectation({
    required PersonExpectationModel personExpectation,
  });
}
