import 'package:flutter/material.dart';
import 'package:hesabo_chat_ai/di.dart';
import 'package:hesabo_chat_ai/features/auth/presentation/controller/auth_controller.dart';
import 'package:hesabo_chat_ai/features/auth/presentation/pages/signup_phone_input_page.dart';
import 'package:hesabo_chat_ai/features/chat_bot/presentation/pages/chat_bot_page.dart';

import 'login_page.dart';

class AuthSelectionPage extends StatefulWidget {
  const AuthSelectionPage({super.key});

  @override
  State<AuthSelectionPage> createState() => _AuthSelectionPageState();
}

class _AuthSelectionPageState extends State<AuthSelectionPage> {
  final AuthController authController = locator<AuthController>();
  bool loading = true;

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    bool res = await authController.initAuth();
    if (res) {
      loading = false;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChatBotPage()),
      );
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF181A2A);
    const primaryPurple = Color(0xFF6C4AB0);
    const secondaryDark = Color(0xFF2E3148);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: loading
              ? Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        color: primaryPurple,
                        strokeWidth: 2.5,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'در حال بارگذاری...',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
              )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // const Text(
                    //   'به چت‌بات خوش آمدید',
                    //   style: TextStyle(
                    //     color: Colors.white,
                    //     fontSize: 24,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    //   textAlign: TextAlign.center,
                    // ),
                    const SizedBox(height: 48),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('ورود', style: TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpPhonePasswordPage(),
                          ),
                        );
                        // Navigator.pushNamed(context, '/signup');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryDark,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: primaryPurple, width: 1.5),
                        ),
                      ),
                      child: const Text(
                        'ثبت نام',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
