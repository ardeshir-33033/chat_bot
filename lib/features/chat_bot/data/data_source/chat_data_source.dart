import 'dart:convert';

// import 'package:api_handler/api_handler.dart';
// import 'package:api_handler/feature/api_handler/data/models/query_model.dart';
// import 'package:api_handler/feature/api_handler/presentation/presentation_usecase.dart';
import 'package:dio/dio.dart';
import 'package:hesabo_chat_ai/features/core/api_routing/chat_bot_routing.dart';
import 'package:hesabo_chat_ai/features/core/data/data_state.dart';
import 'package:hesabo_chat_ai/features/core/data/http_response.dart';
import 'package:hesabo_chat_ai/features/core/env/environment.dart';

import '../models/chat_bot_message.dart';

abstract class ChatDataSource {
  Future<HttpResponse<ChatBotMessage>> getWelcomeQuestion({
    bool? includeOptions = false,
    required order,
    required int step,
  });
}

class ChatDataSourceImpl extends ChatDataSource {
  // APIHandler apiHandler = APIHandler();

  @override
  Future<HttpResponse<ChatBotMessage>> getWelcomeQuestion({
    bool? includeOptions = false,
    required order,
    required int step,
  }) async {
    var headers = {
      'Cookie':
          'FGTServer=735F07D05DD730BD20B9CB7403580EDF41EFE943506E7DBBA1F1FF7C0C6CBB1D2F9C7F90848D86',
    };
    var dio = Dio();
    var response = await dio.request(
      'https://api.hesabodev.ir/chatbot/coreapi/welcome_questions/?include_options=true&order=1&step=1',
      options: Options(
        method: 'GET',
        // headers: headers,
      ),
    );

    if (response.statusCode == 200) {
      final ss = ChatBotMessage.fromJson(response.data);
      print(ss);
      final res = HttpResponse<ChatBotMessage>(
        ChatBotMessage.fromJson(response.data),
        Response(requestOptions: RequestOptions()),
      );
      return res;
    } else {
      throw Exception(response.toString());
    }
    // final response1 = await apiHandler.get(
    //   "${ChatBotRouting.getChatBotWelcomeQuestionRouting}welcome_questions",
    //   queries: [
    //     QueryModel(name: "step", value: step.toString()),
    //     QueryModel(name: "order", value: order.toString()),
    //     QueryModel(name: "include_options", value: 'true'),
    //
    //   ],
    //   headerEnum: HeaderEnum.basicHeaderEnum,
    //   responseEnum: ResponseEnum.responseModelEnum,
    // );
    // if (response1.result == ResultEnum.success) {
    //   final res = HttpResponse<ChatBotMessage>(
    //     response1.data,
    //     Response(requestOptions: RequestOptions()),
    //   );
    //   return res;
    // } else {
    //   throw Exception(response1.message.toString());
    // }
  }
}
