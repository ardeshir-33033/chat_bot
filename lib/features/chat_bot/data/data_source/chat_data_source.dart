import 'dart:convert';

// import 'package:api_handler/api_handler.dart';
// import 'package:api_handler/feature/api_handler/data/models/query_model.dart';
// import 'package:api_handler/feature/api_handler/presentation/presentation_usecase.dart';
import 'package:dio/dio.dart';
import 'package:hesabo_chat_ai/features/chat_bot/data/models/chat_agent_models/chat_agent_answer.dart';
import 'package:hesabo_chat_ai/features/core/api_routing/chat_bot_routing.dart';
import 'package:hesabo_chat_ai/features/core/data/data_state.dart';
import 'package:hesabo_chat_ai/features/core/data/http_response.dart';
import 'package:hesabo_chat_ai/features/core/env/environment.dart';

import '../models/chat_agent_models/chat_agent_request.dart';
import '../models/chat_bot_message.dart';
import '../models/chatbot_answer_models/person_expectation_model.dart';
import '../models/user_answer_model.dart';

abstract class ChatDataSource {
  Future<HttpResponse<ChatBotMessage>> getWelcomeQuestion({
    bool? includeOptions = false,
    required order,
    required int step,
  });

  Future<HttpResponse<void>> postUserResponse({
    required UserAnswerModel userAnswerModel,
  });

  Future<HttpResponse<void>> postPersonExpectation({
    required PersonExpectationModel personExpectationModel,
  });

  Future<HttpResponse<ChatBotMessage>> postAgentInteraction({
    required ChatAgentRequest chatAgentRequest,
  });
}

class ChatDataSourceImpl extends ChatDataSource {
  // APIHandler apiHandler = APIHandler();

  @override
  Future<HttpResponse<ChatBotMessage>> getWelcomeQuestion({
    bool? includeOptions = true,
    required order,
    required int step,
  }) async {
    var headers = {
      'Cookie':
          'FGTServer=735F07D05DD730BD20B9CB7403580EDF41EFE943506E7DBBA1F1FF7C0C6CBB1D2F9C7F90848D86',
    };
    var dio = Dio();
    var response = await dio.request(
      '${ChatBotRouting.getChatBotWelcomeQuestionRouting}/?include_options=true&order=$order&step=$step',
      options: Options(
        method: 'GET',
        // headers: headers,
      ),
    );

    if (response.statusCode == 200) {
      final data = ChatBotMessage.fromJson(response.data);
      print(data);
      final res = HttpResponse<ChatBotMessage>(
        data,
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

  @override
  Future<HttpResponse<ChatBotMessage>> postAgentInteraction({
    required ChatAgentRequest chatAgentRequest,
  }) async {
    var headers = {
      'Content-Type': 'application/json',
      'Cookie':
          'FGTServer=735F07D05DD730BD20B9CB7403580EDF41EFE943506E7DBBA1F1FF7C0C6CBB1D2F9C7F90878D86',
    };
    var dio = Dio();
    var response = await dio.request(
      // ChatBotRouting.postAgentInteraction,
      "https://api.hesabodev.ir/chatbot/agents/interact/",
      data: jsonEncode(chatAgentRequest.toJson()),

      options: Options(method: 'POST', headers: headers),
    );

    if (response.statusCode == 200) {
      final data = ChatAgentResponse.fromJson(response.data);
      print(data);
      ChatBotMessage message = data.convertToChatBoMessage();

      final res = HttpResponse<ChatBotMessage>(
        message,
        Response(requestOptions: RequestOptions()),
      );
      return res;
    } else {
      throw Exception(response.toString());
    }
  }

  @override
  Future<HttpResponse<void>> postUserResponse({
    required UserAnswerModel userAnswerModel,
  }) async {
    var headers = {
      'Cookie':
          'FGTServer=735F07D05DD730BD20B9CB7403580EDF41EFE943506E7DBBA1F1FF7C0C6CBB1D2F9C7F90848D86',
    };
    var dio = Dio();
    var response = await dio.request(
      ChatBotRouting.postUserResponse,
      options: Options(method: 'POST', headers: headers),
      data: jsonEncode(userAnswerModel.toJson()),
    );

    if (response.statusCode == 200) {
      HttpResponse<void> voidResponse = HttpResponse(null, response);

      return voidResponse;
    } else {
      throw Exception(response.toString());
    }
  }

  @override
  Future<HttpResponse<void>> postPersonExpectation({
    required PersonExpectationModel personExpectationModel,
  }) async {
    var headers = {
      'Cookie':
          'FGTServer=735F07D05DD730BD20B9CB7403580EDF41EFE943506E7DBBA1F1FF7C0C6CBB1D2F9C7F90848D86',
    };
    var dio = Dio();
    var response = await dio.request(
      ChatBotRouting.postPersonExpectation,
      options: Options(method: 'POST', headers: headers),
      data: jsonEncode(personExpectationModel.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      HttpResponse<void> voidResponse = HttpResponse(null, response);

      return voidResponse;
    } else {
      throw Exception(response.toString());
    }
  }
}
