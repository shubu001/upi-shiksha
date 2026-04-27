import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  /// 🔥 RESET PASSWORD FUNCTION
  void resetPassword() async {
    if (emailController.text.isEmpty) {
      showMessage("Please enter your email");
      return;
    }

    try {
      setState(() => isLoading = true);

      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );

      setState(() => isLoading = false);

      showMessage("Password reset link sent to your email");

    } catch (e) {
      setState(() => isLoading = false);
      showMessage("Error: Invalid email or user not found");
    }
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [

          /// 🌌 BACKGROUND
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// 🌑 OVERLAY
          Container(color: Colors.black.withOpacity(0.6)),

          /// 📱 CONTENT
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [

                  const SizedBox(height: 120),

                  /// 🔙 BACK BUTTON
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// 🔥 TITLE
                  const Text(
                    "Forgot Password",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Enter your email to receive reset link",
                    style: TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 40),

                  /// 📧 EMAIL FIELD
                  TextField(
                    controller: emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Enter your Email",
                      hintStyle: const TextStyle(color: Colors.white54),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.white30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.green),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// 🔘 BUTTON
                  GestureDetector(
                    onTap: isLoading ? null : resetPassword,
                    child: Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.greenAccent, Colors.teal],
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.black)
                            : const Text(
                                "Send Reset Link",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}