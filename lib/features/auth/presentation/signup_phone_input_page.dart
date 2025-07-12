import 'package:flutter/material.dart';
import 'package:hesabo_chat_ai/features/auth/presentation/signup_sms_verify_page.dart';
import 'package:hesabo_chat_ai/features/core/utils/utils.dart';

class SignUpPhoneInputPage extends StatelessWidget {
  final TextEditingController phoneController = TextEditingController();

  SignUpPhoneInputPage({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF181A2A);
    const primaryPurple = Color(0xFF6C4AB0);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          title: const Text('ثبت نام', style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 48),
              const Text(
                'شماره موبایل خود را وارد کنید',
                style: TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'مثلاً 09123456789',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF2E3148),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpSmsVerifyPage(),
                    ),
                  );
                  String phoneNumber = phoneController.text.trim();
                  if (phoneNumber.isNotEmpty) {
                    final bool result = isValidIranianPhoneNumber(phoneNumber);
                    if (result) {}
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'ارسال کد تایید',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
