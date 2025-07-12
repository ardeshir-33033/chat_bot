import 'package:hesabo_chat_ai/features/chat_bot/data/models/most_expense_category_model.dart';
import 'package:hesabo_chat_ai/features/chat_bot/domain/repository/chat_bot_repository.dart';
import 'package:hesabo_chat_ai/features/core/usecase/usecase.dart';

import '../../../core/data/data_state.dart';

class PostMostExpenseCategoryUseCase
    implements UseCase<DataState<void>, MostExpenseCategoryModel> {
  final ChatBotRepository _chatBotRepository;

  PostMostExpenseCategoryUseCase(this._chatBotRepository);

  @override
  Future<DataState<void>> call({required MostExpenseCategoryModel params}) {
    return _chatBotRepository.postMostExpenseCategory(
      mostExpenseCategoryModel: params,
    );
  }
}
