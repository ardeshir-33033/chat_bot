import 'package:flutter/material.dart';

import '../../../../di.dart';
import '../controller/chat_bot_controller.dart';

class ChatBotMetaDataWidgets extends StatefulWidget {
  const ChatBotMetaDataWidgets({super.key});

  @override
  State<ChatBotMetaDataWidgets> createState() => _ChatBotMetaDataWidgetsState();
}

class _ChatBotMetaDataWidgetsState extends State<ChatBotMetaDataWidgets> {
  final TextEditingController threadIdController = TextEditingController();
  final TextEditingController currentUserIdController = TextEditingController();

  ChatBotController controller = locator<ChatBotController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: threadIdController,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          textDirection: TextDirection.rtl,
          onChanged: (value) {
            controller.threadId = int.parse(value);
          },
          decoration: InputDecoration(
            hintText: 'Thread ID',
            hintStyle: const TextStyle(color: Colors.white70, fontSize: 16),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            filled: true,
            fillColor: const Color(0xFF23244A),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Colors.purpleAccent,
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Colors.purpleAccent,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Colors.purpleAccent,
                width: 2,
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        TextField(
          controller: currentUserIdController,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          textDirection: TextDirection.rtl,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            controller.currentUser = value;
          },
          decoration: InputDecoration(
            hintText: 'User Id',
            hintStyle: const TextStyle(color: Colors.white70, fontSize: 16),

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            filled: true,
            fillColor: const Color(0xFF23244A),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Colors.purpleAccent,
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Colors.purpleAccent,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Colors.purpleAccent,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
