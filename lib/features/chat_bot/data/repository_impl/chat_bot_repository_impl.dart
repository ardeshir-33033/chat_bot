import 'package:hesabo_chat_ai/features/chat_bot/data/models/chat_bot_message.dart';
import 'package:hesabo_chat_ai/features/chat_bot/data/models/chatbot_answer_models/person_expectation_model.dart';
import 'package:hesabo_chat_ai/features/chat_bot/domain/repository/chat_bot_repository.dart';
import 'package:hesabo_chat_ai/features/core/data/data_state.dart';

import '../data_source/chat_data_source.dart';
import '../models/user_answer_model.dart';

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
      // return const DataFailed('Error, try again');
      // }
    }
  }

  @override
  Future<DataState<void>> postUserResponse({
    required UserAnswerModel userAnswerModel,
  }) async {
    try {
      final response = await _chatDataSource.postUserResponse(
        userAnswerModel: userAnswerModel,
      );

      return DataSuccess(response.data);
    } on Exception catch (e) {
      // if (e.error is ApiError) {
      return DataFailed(e.toString());
      // } else {
      //   e.errLog();
      // return const DataFailed('Error, try again');
      // }
    }
  }

  @override
  Future<DataState<void>> postPersonExpectation({
    required PersonExpectationModel personExpectation,
  }) async {
    try {
      final response = await _chatDataSource.postPersonExpectation(
        personExpectationModel: personExpectation,
      );

      return DataSuccess(response.data);
    } on Exception catch (e) {
      return DataFailed(e.toString());
    }
  }
}
