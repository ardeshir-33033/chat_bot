import 'package:hesabo_chat_ai/core/data/data_state.dart';
import 'package:hesabo_chat_ai/features/chat_bot/data/models/income_expense_model.dart';
import 'package:hesabo_chat_ai/features/chat_bot/domain/repository/chat_bot_repository.dart';
import 'package:hesabo_chat_ai/core/usecase/usecase.dart';

class PostFixIncomeExpenseUseCase
    implements UseCase<DataState<void>, IncomeExpenseModel> {
  final ChatBotRepository _chatBotRepository;

  PostFixIncomeExpenseUseCase(this._chatBotRepository);

  @override
  Future<DataState<void>> call({required IncomeExpenseModel params}) {
    return _chatBotRepository.postFixIncomeExpense(incomeExpenseModel: params);
  }
}
