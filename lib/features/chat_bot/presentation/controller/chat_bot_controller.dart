import 'package:get/get.dart';
import 'package:hesabo_chat_ai/features/chat_bot/data/models/chat_bot_message.dart'
    show ChatBotMessage;
import 'package:hesabo_chat_ai/features/chat_bot/domain/usecase/get_welcome_question_usecase.dart';
import 'package:hesabo_chat_ai/features/core/data/data_state.dart';
import 'package:hesabo_chat_ai/features/core/utils/utils.dart';

class ChatBotController extends GetxController {
  ChatBotController(this._getWelcomeQuestionUseCase);

  final GetWelcomeQuestionUseCase _getWelcomeQuestionUseCase;

  List<ChatBotMessage> chatBotMessages = [];

  int userId = 1;
  int systemId = 0;

  init() async {
    addMessages('سلام، من آماده ام که شروع کنم');
    Future.delayed(Duration(milliseconds: 500), () {
      addMessages('سلام، فواد خوش حالم که اینجا می‌بینمت', fromUser: false);
    });
    Future.delayed(Duration(milliseconds: 1500), () {
      addMessages('آره بزن بریم', fromUser: true);
    });
    Future.delayed(Duration(milliseconds: 2500), () {
      addMessages('عالیه، بریم سراغ ۵ تا سوال', fromUser: false);
      getWelcomeQuestion();
    });
  }

  Future getWelcomeQuestion() async {
    final res = await _getWelcomeQuestionUseCase.call(params: 1);
    if (res is DataSuccess<ChatBotMessage>) {
      chatBotMessages.add(res.data);
      update();
    } else {
      print(res);
    }
    print(res);
  }

  addMessages(String message, {bool fromUser = true}) {
    ChatBotMessage chatBotMessage = ChatBotMessage(
      id: getRandomNumber(),
      order: 1,
      step: 1,
      text: fromUser ? message : null,
      systemQuestion: fromUser ? null : message,
      systemName: message,
      userId: fromUser ? userId.toString() : systemId.toString(),
      createdAt: DateTime.now(),
    );
    chatBotMessages.add(chatBotMessage);
    update();
  }

  resetData() {
    chatBotMessages = [];
  }
}
