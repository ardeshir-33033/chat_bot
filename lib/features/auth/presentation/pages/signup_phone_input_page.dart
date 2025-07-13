import 'package:flutter/material.dart';
import 'package:hesabo_chat_ai/core/components/chat_bot_button.dart';
import 'package:hesabo_chat_ai/core/data/data_state.dart';
import 'package:hesabo_chat_ai/di.dart';
import 'package:hesabo_chat_ai/features/auth/presentation/controller/auth_controller.dart';
import 'package:hesabo_chat_ai/features/auth/presentation/pages/sms_verify_page.dart';

// Assuming utils.dart contains isValidIranianPhoneNumber
import 'package:hesabo_chat_ai/core/utils/utils.dart';

class SignUpPhonePasswordPage extends StatefulWidget {
  const SignUpPhonePasswordPage({super.key});

  @override
  State<SignUpPhonePasswordPage> createState() =>
      _SignUpPhonePasswordPageState();
}

class _SignUpPhonePasswordPageState extends State<SignUpPhonePasswordPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false; // To toggle password visibility
  final AuthController authController = locator<AuthController>();

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // --- Helper function for Iranian phone number validation (from utils.dart) ---
  // You might already have this in utils.dart, but including it here for completeness
  bool isValidIranianPhoneNumber(String phone) {
    final pattern = RegExp(r'^09\d{9}$');
    return pattern.hasMatch(phone);
  }

  // --- Function to handle sending SMS for verification ---
  Future<void> _sendSmsForSignUp() async {
    if (_formKey.currentState!.validate()) {
      final phoneNumber = phoneController.text.trim();
      final password = passwordController.text.trim();

      final res = await authController.register(phoneNumber, password);
      if (res is DataSuccess<String>) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('در حال ارسال کد به $phoneNumber...'),
            backgroundColor: Colors.blueAccent,
          ),
        );

        // After successful API call for sending SMS, navigate to the verification page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignUpSmsVerifyPage(
              phoneNumber: phoneNumber,
              password:
                  password, // Pass password if needed for final registration after SMS verify
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              res is DataFailed
                  ? 'خطا در ارسال کد: ${res.error}'
                  : 'خطای ناشناخته',
            ),
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
          title: const Text('ثبت نام', style: TextStyle(color: textColor)),
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
                const Text(
                  'برای ثبت نام، شماره موبایل و رمز عبور خود را وارد کنید',
                  style: TextStyle(color: textColor, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // --- Phone Number Input ---
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: textColor),
                  decoration: InputDecoration(
                    hintText: 'شماره موبایل (مثلاً 09123456789)',
                    hintStyle: const TextStyle(color: hintTextColor),
                    filled: true,
                    fillColor: inputFillColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.phone, color: hintTextColor),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'لطفاً شماره موبایل خود را وارد کنید';
                    }
                    if (!isValidIranianPhoneNumber(value.trim())) {
                      return 'شماره موبایل معتبر نیست';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                // --- Password Input ---
                TextFormField(
                  controller: passwordController,
                  obscureText: !_isPasswordVisible,
                  // Controlled by state
                  style: const TextStyle(color: textColor),
                  decoration: InputDecoration(
                    hintText: 'رمز عبور',
                    hintStyle: const TextStyle(color: hintTextColor),
                    filled: true,
                    fillColor: inputFillColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.lock, color: hintTextColor),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: hintTextColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'لطفاً رمز عبور خود را وارد کنید';
                    }
                    if (value.length < 4) {
                      // Example: minimum password length
                      return 'رمز عبور باید حداقل ۶ کاراکتر باشد';
                    }
                    // You can add more complex password validation here (e.g., strong password regex)
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                // --- Send Verification Code Button ---
                ChatBotButton(
                  title: 'ارسال کد تایید',
                  onPressed: _sendSmsForSignUp,
                  color: primaryPurple,
                  // Make sure 'primaryPurple' is defined in your build method or as a constant.
                  foregroundColor:
                      textColor, // Make sure 'textColor' is defined in your build method or as a constant.
                  // The default padding and shape of ChatBotButton already match your original ElevatedButton.
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
