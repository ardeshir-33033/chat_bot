import 'package:hesabo_chat_ai/features/chat_bot/data/models/chat_bot_message.dart';

class ChatAgentRequest {
  final List<ChatAgentMessage> messages;
  final String currentUser;
  final int threadId;
  final bool stream;

  ChatAgentRequest({
    required this.messages,
    required this.currentUser,
    required this.threadId,
    required this.stream,
  });

  factory ChatAgentRequest.fromJson(Map<String, dynamic> json) {
    return ChatAgentRequest(
      messages: (json['messages'] as List)
          .map((e) => ChatAgentMessage.fromJson(e))
          .toList(),
      currentUser: json['current_user'] as String,
      threadId: json['thread_id'] as int,
      stream: json['stream'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messages': messages.map((e) => e.toJson()).toList(),
      'current_user': currentUser,
      'thread_id': threadId,
      'stream': stream,
    };
  }
}

class ChatAgentMessage {
  final String content;
  final String role; // Typically 'user' or 'assistant'

  ChatAgentMessage({required this.content, required this.role});

  factory ChatAgentMessage.fromJson(Map<String, dynamic> json) {
    return ChatAgentMessage(
      content: json['content'] as String,
      role: json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'content': content, 'role': role};
  }
}
