import 'package:flutter/material.dart';
import 'package:hesabo_chat_ai/core/components/chat_bot_button.dart';
import 'package:hesabo_chat_ai/di.dart';
import 'package:hesabo_chat_ai/features/auth/presentation/controller/auth_controller.dart';
import 'package:hesabo_chat_ai/features/chat_bot/presentation/pages/chat_bot_page.dart';

// You might not need LoginPasswordPage anymore, depending on your new flow.
// If you're redirecting to a different page after successful login, update this import.
// import 'login_password_page.dart';

class LoginPage extends StatefulWidget {
  // Changed to StatefulWidget to manage form state
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Added FormKey for validation
  final AuthController authController = locator<AuthController>();

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // --- Helper function for Iranian phone number validation ---
  bool isValidIranianPhoneNumber(String phone) {
    // A simple regex for Iranian phone numbers starting with 09 and followed by 9 digits.
    final pattern = RegExp(r'^09\d{9}$');
    return pattern.hasMatch(phone);
  }

  // --- Login logic (placeholder) ---
  Future<void> _performLogin() async {
    if (_formKey.currentState!.validate()) {
      final phone = phoneController.text.trim();
      final password = passwordController.text.trim();

      final res = await authController.login(phone, password);
      if (res) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChatBotPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('نام کاربری یا رمز عبور اشتباه است'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }

      // For demonstration, just show a success message

      // In a real app, navigate to the next screen upon successful login
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
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
          title: const Text('ورود', style: TextStyle(color: textColor)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          // Use SingleChildScrollView to prevent overflow on small screens
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            // Wrap with Form for validation
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 48),
                const Text(
                  'برای ورود، شماره موبایل و رمز عبور خود را وارد کنید',
                  style: TextStyle(color: textColor, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // --- Phone Number Input ---
                TextFormField(
                  // Changed to TextFormField for validation
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
                  // Changed to TextFormField for validation
                  controller: passwordController,
                  obscureText: true,
                  // Hides the input for security
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
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'لطفاً رمز عبور خود را وارد کنید';
                    }
                    if (value.length < 4) {
                      // Example: minimum password length
                      return 'رمز عبور باید حداقل ۶ کاراکتر باشد';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                // --- Login Button ---
                ChatBotButton(
                  title: 'ورود',
                  onPressed: _performLogin,
                  color: primaryPurple,
                  foregroundColor: textColor,
                  // Your ChatBotButton already has a default padding and shape that matches.
                  // If you need more specific padding, you can use `margin` or adjust inside ChatBotButton.
                ),
                // You can add "Forgot Password" or "Register" links here if needed
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    // TODO: Implement "Forgot Password" navigation
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'قابلیت فراموشی رمز عبور به زودی اضافه می‌شود',
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'رمز عبور خود را فراموش کرده‌اید؟',
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
