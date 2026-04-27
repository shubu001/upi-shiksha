import 'package:flutter/material.dart';
import 'otp_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.6),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [

                  Image.asset("assets/logo.png", height: 120),

                  const SizedBox(height: 10),

                  const Text(
                    "UPI-SHIKSHA",
                    style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  ),

                  const Text(
                    "India's Digital Payment Learning Platform",
                    style: TextStyle(color: Color.fromARGB(180, 255, 255, 255), fontSize: 14),
                  ),

                  const SizedBox(height: 40),

                  /// PHONE FIELD WITH +91 + DIVIDER
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.greenAccent),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          const Text("🇮🇳 +91",
                              style: TextStyle(color: Colors.white)),

                          const SizedBox(width: 8),

                          Container(
                            height: 25,
                            width: 1,
                            color: Colors.white30,
                          ),

                          const SizedBox(width: 8),

                          Expanded(
                            child: TextField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter number",
                                hintStyle: TextStyle(color: Colors.white54),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "We'll send an OTP to verify your number. Standard SMS charges may apply.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white54, fontSize: 10),
                  ),

                  const SizedBox(height: 55), // 🔥 spacing increased

                  /// CONTINUE BUTTON
                  GestureDetector(
                    onTap: () {
                      if (phoneController.text.length == 10) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OTPScreen(
                              phone: phoneController.text,
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: 250,
                      height: 55,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.greenAccent, Colors.teal],
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Text(
                          "Continue",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "By continuing, you agree to our Terms of service and privacy policy.\n© 2026 UPI-SHIKSHA. All rights reserved",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color.fromARGB(138, 255, 255, 255), fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}