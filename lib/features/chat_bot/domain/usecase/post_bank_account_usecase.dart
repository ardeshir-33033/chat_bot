import 'package:hesabo_chat_ai/features/chat_bot/data/models/bank_account_model.dart';
import 'package:hesabo_chat_ai/features/chat_bot/data/models/chat_bot_message.dart';
import 'package:hesabo_chat_ai/features/chat_bot/domain/repository/chat_bot_repository.dart';
import 'package:hesabo_chat_ai/features/core/usecase/usecase.dart';
import '../../../core/data/data_state.dart';

class PostBankAccountUseCase
    implements UseCase<DataState<BankAccount>, BankAccount> {
  final ChatBotRepository _chatBotRepository;

  PostBankAccountUseCase(this._chatBotRepository);

  @override
  Future<DataState<BankAccount>> call({required BankAccount params}) {
    return _chatBotRepository.postBankAccount(bankAccount: params);
  }
}
