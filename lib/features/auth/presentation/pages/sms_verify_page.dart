import 'package:flutter/material.dart';
import 'package:hesabo_chat_ai/core/components/chat_bot_button.dart';
import 'package:hesabo_chat_ai/core/data/data_state.dart';
import 'package:hesabo_chat_ai/di.dart';
import 'package:hesabo_chat_ai/features/auth/presentation/controller/auth_controller.dart';
import 'package:hesabo_chat_ai/features/chat_bot/presentation/pages/chat_bot_page.dart';
// import 'package:pin_code_fields/pin_code_fields.dart'; // Consider adding this package for a better OTP input

class SignUpSmsVerifyPage extends StatefulWidget {
  final String phoneNumber;
  final String password; // Pass password if needed for final registration

  const SignUpSmsVerifyPage({
    super.key,
    required this.phoneNumber,
    required this.password,
  });

  @override
  State<SignUpSmsVerifyPage> createState() => _SignUpSmsVerifyPageState();
}

class _SignUpSmsVerifyPageState extends State<SignUpSmsVerifyPage> {
  final TextEditingController smsCodeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController authController = locator<AuthController>();

  @override
  void initState() {
    smsCodeController.text = authController.tempSmsCode!;
    super.initState();
  }

  @override
  void dispose() {
    smsCodeController.dispose();
    super.dispose();
  }

  Future<void> _verifySmsCodeAndRegister() async {
    if (_formKey.currentState!.validate()) {
      final AuthController authController = locator<AuthController>();

      try {
        final res = await authController.verify(
          widget.phoneNumber,
          authController.tempSmsCode!,
        );
        if (res is DataSuccess) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const ChatBotPage()),
            // Replace with your actual home page
            (Route<dynamic> route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('کد تایید اشتباه است'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطا در تایید کد: ${e.toString()}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF181A2A);
    const primaryPurple = Color(0xFF6C4AB0);
    const inputFillColor = Color(0xFF2E3148);
    const hintTextColor = Colors.white54;
    const textColor = Colors.white;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          title: const Text('تایید کد', style: TextStyle(color: textColor)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 48),
                Text(
                  'کد تایید ارسال شده به شماره ${widget.phoneNumber} را وارد کنید',
                  style: const TextStyle(color: textColor, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // --- SMS Code Input ---
                TextFormField(
                  controller: smsCodeController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 6,
                  // Assuming a 6-digit SMS code
                  style: const TextStyle(
                    color: textColor,
                    fontSize: 24,
                    letterSpacing: 8,
                  ),
                  decoration: InputDecoration(
                    hintText: '_ _ _ _ _ _',
                    // Placeholder for 6 digits
                    hintStyle: const TextStyle(
                      color: hintTextColor,
                      fontSize: 24,
                      letterSpacing: 8,
                    ),
                    filled: true,
                    fillColor: inputFillColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    counterText: "", // Hide the default character counter
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'لطفاً کد تایید را وارد کنید';
                    }
                    if (value.length != 6 ||
                        !RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'کد تایید ۶ رقمی و عددی معتبر نیست';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                // --- Verify and Register Button ---
                ChatBotButton(
                  title: 'تایید و ثبت نام',
                  onPressed: _verifySmsCodeAndRegister,
                  color: primaryPurple,
                  // Make sure 'primaryPurple' is defined in your build method or as a constant.
                  foregroundColor:
                      textColor, // Make sure 'textColor' is defined in your build method or as a constant.
                  // The default padding and shape of ChatBotButton already match your original ElevatedButton.
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    // TODO: Implement resend SMS code logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'کد تایید مجدداً به شماره ${widget.phoneNumber} ارسال شد.',
                        ),
                      ),
                    );
                    // You might want to call your API again to resend the code here.
                  },
                  child: const Text(
                    'ارسال مجدد کد',
                    style: TextStyle(color: primaryPurple),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// A simple placeholder for your home page
class PlaceholderHomePage extends StatelessWidget {
  const PlaceholderHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('صفحه اصلی')),
      body: const Center(child: Text('ثبت نام با موفقیت انجام شد!')),
    );
  }
}
