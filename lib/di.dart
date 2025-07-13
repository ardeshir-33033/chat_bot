import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:hesabo_chat_ai/core/data/auth_data_controller.dart';
import 'package:hesabo_chat_ai/core/storage/hive/hive_local_storage.dart';
import 'package:hesabo_chat_ai/core/storage/hive/hive_storage.dart';
import 'package:hesabo_chat_ai/features/auth/data/data_source/auth_data_source.dart';
import 'package:hesabo_chat_ai/features/auth/data/repository_impl/auth_repository_impl.dart';
import 'package:hesabo_chat_ai/features/auth/domain/repository/auth_repository.dart';
import 'package:hesabo_chat_ai/features/auth/domain/usecase/login_usecase.dart';
import 'package:hesabo_chat_ai/features/auth/domain/usecase/register_usecase.dart';
import 'package:hesabo_chat_ai/features/auth/domain/usecase/verify_usecase.dart';
import 'package:hesabo_chat_ai/features/auth/presentation/controller/auth_controller.dart';
import 'package:hesabo_chat_ai/features/chat_bot/domain/usecase/post_agent_interaction_usecase.dart';
import 'package:hesabo_chat_ai/features/chat_bot/domain/usecase/post_bank_account_usecase.dart';
import 'package:hesabo_chat_ai/features/chat_bot/domain/usecase/post_most_expense_category_usecase.dart';
import 'package:hesabo_chat_ai/features/chat_bot/domain/usecase/post_person_expectation_usecase.dart';
import 'package:hesabo_chat_ai/features/chat_bot/domain/usecase/post_sms_transaction_batch_usecase.dart';
import 'package:hesabo_chat_ai/features/chat_bot/domain/usecase/post_user_response_usecase.dart';
import 'package:hesabo_chat_ai/features/chat_bot/presentation/controller/chat_bot_controller.dart';

import 'features/chat_bot/data/data_source/chat_data_source.dart';
import 'features/chat_bot/data/repository_impl/chat_bot_repository_impl.dart';
import 'features/chat_bot/domain/repository/chat_bot_repository.dart';
import 'features/chat_bot/domain/usecase/get_welcome_question_usecase.dart';
import 'features/chat_bot/domain/usecase/post_fix_income_expense_usecase.dart';

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
        locator(),
        locator(),
      ),
    ),
  );
  locator.registerSingleton<AuthController>(
    Get.put(AuthController(locator(), locator(), locator(), locator())),
  );
  locator.registerSingleton<AuthDataController>(Get.put(AuthDataController()));
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
  locator.registerLazySingleton<PostFixIncomeExpenseUseCase>(
    () => PostFixIncomeExpenseUseCase(locator()),
  );
  locator.registerLazySingleton<PostMostExpenseCategoryUseCase>(
    () => PostMostExpenseCategoryUseCase(locator()),
  );
  locator.registerLazySingleton<LoginUseCase>(() => LoginUseCase(locator()));
  locator.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(locator()),
  );
  locator.registerLazySingleton<VerifyUseCase>(() => VerifyUseCase(locator()));
}

void repositoryInjection() {
  locator.registerLazySingleton<ChatBotRepository>(
    () => ChatBotRepositoryImpl(locator()),
  );
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(locator()),
  );
}

void dataInjection() {
  locator
      .registerSingleton<HiveLocalStorage>(HiveLocalStorageImpl())
      .initialStorage();
  locator.registerSingleton<ChatDataSource>(ChatDataSourceImpl());
  locator.registerSingleton<AuthDataSource>(AuthDataSourceImpl());
}
