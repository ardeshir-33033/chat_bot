import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:hesabo_chat_ai/features/chat_bot/domain/usecase/post_agent_interaction_usecase.dart';
import 'package:hesabo_chat_ai/features/chat_bot/domain/usecase/post_bank_account_usecase.dart';
import 'package:hesabo_chat_ai/features/chat_bot/domain/usecase/post_person_expectation_usecase.dart';
import 'package:hesabo_chat_ai/features/chat_bot/domain/usecase/post_sms_transaction_batch_usecase.dart';
import 'package:hesabo_chat_ai/features/chat_bot/domain/usecase/post_user_response_usecase.dart';
import 'package:hesabo_chat_ai/features/chat_bot/presentation/controller/chat_bot_controller.dart';

import 'features/chat_bot/data/data_source/chat_data_source.dart';
import 'features/chat_bot/data/repository_impl/chat_bot_repository_impl.dart';
import 'features/chat_bot/domain/repository/chat_bot_repository.dart';
import 'features/chat_bot/domain/usecase/get_welcome_question_usecase.dart';

GetIt locator = GetIt.instance;

Future setup() async {
  dataInjection();
  repositoryInjection();
  useCaseInjection();

  controllerInjection();
}

void controllerInjection() {
  locator.registerSingleton<ChatBotController>(
    Get.put(
      ChatBotController(
        locator(),
        locator(),
        locator(),
        locator(),
        locator(),
        locator(),
      ),
    ),
  );
}

void useCaseInjection() {
  locator.registerLazySingleton<GetWelcomeQuestionUseCase>(
    () => GetWelcomeQuestionUseCase(locator()),
  );

  locator.registerLazySingleton<PostUserResponseUseCase>(
    () => PostUserResponseUseCase(locator()),
  );

  locator.registerLazySingleton<PostPersonExpectationUseCase>(
    () => PostPersonExpectationUseCase(locator()),
  );
  locator.registerLazySingleton<PostAgentInteractionUseCase>(
    () => PostAgentInteractionUseCase(locator()),
  );
  locator.registerLazySingleton<PostBankAccountUseCase>(
    () => PostBankAccountUseCase(locator()),
  );
  locator.registerLazySingleton<PostSmsTransactionBatchUseCase>(
    () => PostSmsTransactionBatchUseCase(locator()),
  );
}

void repositoryInjection() {
  locator.registerLazySingleton<ChatBotRepository>(
    () => ChatBotRepositoryImpl(locator()),
  );
}

void dataInjection() {
  locator.registerSingleton<ChatDataSource>(ChatDataSourceImpl());
}
