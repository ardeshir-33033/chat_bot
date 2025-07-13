
import 'package:hesabo_chat_ai/core/data/data_state.dart';
import 'package:hesabo_chat_ai/features/chat_bot/data/models/sms_transaction_model.dart';
import 'package:hesabo_chat_ai/features/chat_bot/domain/repository/chat_bot_repository.dart';
import 'package:hesabo_chat_ai/core/usecase/usecase.dart';

class PostSmsTransactionBatchUseCase
    implements UseCase<DataState<void>, List<SmsTransactionModel>> {
  final ChatBotRepository _chatBotRepository;

  PostSmsTransactionBatchUseCase(this._chatBotRepository);

  @override
  Future<DataState<void>> call({required List<SmsTransactionModel> params}) {
    return _chatBotRepository.postSmsTransactionBatch(
      smsTransactionModel: params,
    );
  }
}
