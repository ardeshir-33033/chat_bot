import 'package:flutter/material.dart';
import 'package:hesabo_chat_ai/di.dart';
import 'package:hesabo_chat_ai/features/auth/presentation/controller/auth_controller.dart';
import 'package:hesabo_chat_ai/features/auth/presentation/pages/auth_selection_page.dart';

class ChatBotTopHeader extends StatefulWidget {
  const ChatBotTopHeader({super.key});

  @override
  State<ChatBotTopHeader> createState() => _ChatBotTopHeaderState();
}

class _ChatBotTopHeaderState extends State<ChatBotTopHeader> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.apps, color: Colors.white, size: 32),
              Text(
                'دستیار هوشمند حسابو',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: () {
                  locator<AuthController>().logout();
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AuthSelectionPage(),
                    ),
                  );
                },
                child: Icon(Icons.logout, color: Colors.white, size: 32),
              ),
            ],
          ),
        ),
        // Assistant Icon
        // Positioned(
        //   top: 80,
        //   left: 0,
        //   right: 0,
        //   child: Center(
        //     child: Container(
        //       width: 100,
        //       height: 100,
        //       decoration: BoxDecoration(
        //         shape: BoxShape.circle,
        //         gradient: RadialGradient(
        //           colors: [Colors.purpleAccent, Colors.black],
        //           center: Alignment.center,
        //           radius: 0.8,
        //         ),
        //         boxShadow: [
        //           BoxShadow(
        //             color: Colors.purpleAccent.withOpacity(0.6),
        //             blurRadius: 30,
        //             spreadRadius: 5,
        //           ),
        //         ],
        //       ),
        //       child: Center(
        //         child: Container(
        //           width: 60,
        //           height: 60,
        //           decoration: BoxDecoration(
        //             shape: BoxShape.circle,
        //             color: Colors.black,
        //           ),
        //           child: Icon(
        //             Icons.blur_on,
        //             color: Colors.purpleAccent,
        //             size: 40,
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
