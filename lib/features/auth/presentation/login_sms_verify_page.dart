import 'package:flutter/material.dart';

class LoginSmsVerifyPage extends StatelessWidget {
  final String phone;
  final TextEditingController codeController = TextEditingController();

  LoginSmsVerifyPage({super.key, required this.phone});

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
          title: const Text(
            'ورود با رمز موقت',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 48),
              Text(
                'کد پیامک شده به شماره $phone را وارد کنید',
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: codeController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                maxLength: 6,
                decoration: InputDecoration(
                  counterText: '',
                  hintText: 'مثلاً 123456',
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
                  final code = codeController.text.trim();
                  if (code.length < 4 || code.length > 6) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('کد وارد شده معتبر نیست'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    return;
                  }

                  // TODO: verify OTP using phone & code, then receive token

                  Navigator.pushReplacementNamed(context, '/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('ورود'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // TODO: resend code logic
                },
                child: const Text(
                  'ارسال مجدد کد',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
