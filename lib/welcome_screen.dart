import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'create_profile_screen.dart';

class WelcomeScreen extends StatelessWidget {
  final String phone;
  const WelcomeScreen({super.key, required this.phone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.8),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: const LinearGradient(
                colors: [Color(0xFF1B3358), Color(0xFF0B1E35)],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// ICON
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                  child: const Icon(Icons.auto_awesome,
                      color: Colors.black, size: 35),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Welcome to UPI Shiksha 🎉", textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                const Text(
                  "You've successfully verified your account.\nLet's set up your profile to get started with UPI Shiksha!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),

                const SizedBox(height: 20),

                /// FEATURES BOX
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Column(
                    children: const [
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 10),
                          Expanded(child: Text("Get ₹10,000 Shiksha Coins to start",
                              style: TextStyle(color: Colors.white70))),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 10),
                          Expanded(child: Text("Learn safe UPI payment practices",
                              style: TextStyle(color: Colors.white70))),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 10),
                          Expanded(child: Text("Practice transactions in a safe environment",
                              style: TextStyle(color: Colors.white70))),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                /// BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => CreateProfileScreen(phone: phone),
                      ),
                      );
                    },
                    child: const Text("Continue",
                        style: TextStyle(color: Colors.black)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}