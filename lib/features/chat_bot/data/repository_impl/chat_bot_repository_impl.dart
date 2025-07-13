import 'package:hesabo_chat_ai/features/chat_bot/data/models/bank_account_model.dart';
import 'package:hesabo_chat_ai/features/chat_bot/data/models/chat_bot_message.dart';
import 'package:hesabo_chat_ai/features/chat_bot/data/models/chatbot_answer_models/person_expectation_model.dart';
import 'package:hesabo_chat_ai/features/chat_bot/data/models/income_expense_model.dart';
import 'package:hesabo_chat_ai/features/chat_bot/data/models/most_expense_category_model.dart';
import 'package:hesabo_chat_ai/features/chat_bot/domain/repository/chat_bot_repository.dart';
import 'package:hesabo_chat_ai/core/data/data_state.dart';

import '../data_source/chat_data_source.dart';
import '../models/chat_agent_models/chat_agent_request.dart';
import '../models/sms_transaction_model.dart';
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
  Future<DataState<ChatBotMessage>> postAgentInteraction({
    required ChatAgentRequest chatAgentRequest,
  }) async {
    try {
      final response = await _chatDataSource.postAgentInteraction(
        chatAgentRequest: chatAgentRequest,
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

  @override
  Future<DataState<BankAccount>> postBankAccount({
    required BankAccount bankAccount,
  }) async {
    try {
      final response = await _chatDataSource.postBankAccount(
        bankAccount: bankAccount,
      );

      return DataSuccess(response.data);
    } on Exception catch (e) {
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<void>> postSmsTransactionBatch({
    required List<SmsTransactionModel> smsTransactionModel,
  }) async {
    try {
      final response = await _chatDataSource.postSmsTransactionBatch(
        smsTransactionModel: smsTransactionModel,
      );
      return DataSuccess(response.data);
    } on Exception catch (e) {
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<void>> postFixIncomeExpense({
    required IncomeExpenseModel incomeExpenseModel,
  }) async {
    try {
      final response = await _chatDataSource.postFixIncomeExpense(
        incomeExpenseModel: incomeExpenseModel,
      );
      return DataSuccess(response.data);
    } on Exception catch (e) {
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<void>> postMostExpenseCategory({
    required MostExpenseCategoryModel mostExpenseCategoryModel,
  }) async {
    try {
      final response = await _chatDataSource.postMostExpenseCategory(
        mostExpenseCategoryModel: mostExpenseCategoryModel,
      );
      return DataSuccess(response.data);
    } on Exception catch (e) {
      return DataFailed(e.toString());
    }
  }
}
