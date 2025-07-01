import 'package:hesabo_chat_ai/features/core/utils/utils.dart';

import '../chat_bot_message.dart';

class ChatAgentResponse {
  final ResponseData response;

  ChatAgentResponse({required this.response});

  factory ChatAgentResponse.fromJson(Map<String, dynamic> json) {
    return ChatAgentResponse(response: ResponseData.fromJson(json['response']));
  }

  Map<String, dynamic> toJson() {
    return {'response': response.toJson()};
  }

  ChatBotMessage convertToChatBoMessage() {
    return ChatBotMessage(
      id: getRandomNumber(),
      systemName: response.llmMessage,
      text: response.llmMessage,
      createdAt: DateTime.now(),
    );
  }
}

class ResponseData {
  final String llmMessage;
  final String plotType;
  final List<dynamic>
  data; // Can be more specific if you know the data structure
  final String componentType;

  ResponseData({
    required this.llmMessage,
    required this.plotType,
    required this.data,
    required this.componentType,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      llmMessage: json['llm_message'] as String,
      plotType: json['plot_type'] as String,
      data: json['data'] as List<dynamic>,
      componentType: json['component_type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'llm_message': llmMessage,
      'plot_type': plotType,
      'data': data,
      'component_type': componentType,
    };
  }
}
