import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'home_screen.dart';
import 'start_screen.dart'; // 🔥 ADD THIS

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "";
  String phone = "";
  String upiId = "";

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();

        if (doc.exists && doc.data() != null) {
          setState(() {
            name = doc['name'] ?? "User";
            phone = (doc['phone'] ?? "").replaceAll("+91", "");
            upiId = doc['upiId'] ?? "";
            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);
        }
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void showQR() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFF111827),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "My QR Code",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              QrImageView(
                data: "$name|$upiId",
                size: 200,
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 15),
              Text(
                upiId,
                style: const TextStyle(color: Colors.greenAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔥 UPDATED LOGOUT
  void logout() async {
    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const StartScreen()), // 🔥 FIXED
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              /// 🔝 TOP BAR (UPDATED)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  /// 🔙 BACK BUTTON (NEW)
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),

                  const Text("Profile",
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),

                  /// ❌ CLOSE BUTTON
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),

              const SizedBox(height: 20),

              /// 🟩 PROFILE CARD (UNCHANGED)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.greenAccent),
                  color: const Color(0xFF1E293B),
                ),
                child: Column(
                  children: [

                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.green,
                          child: Icon(Icons.person, color: Colors.black),
                        ),
                        const SizedBox(width: 15),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isLoading ? "Loading..." : name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Text(
                              "UPI Shiksha User",
                              style: TextStyle(color: Colors.white60),
                            )
                          ],
                        )
                      ],
                    ),

                    const SizedBox(height: 20),
                    const Divider(color: Colors.white24),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        const Icon(Icons.phone, color: Colors.blue),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Mobile Number",
                                style: TextStyle(color: Colors.white60)),
                            Text(
                              isLoading ? "Loading..." : phone,
                              style: const TextStyle(color: Colors.white),
                            )
                          ],
                        )
                      ],
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: [
                        const Icon(Icons.credit_card, color: Colors.green),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("UPI ID",
                                style: TextStyle(color: Colors.white60)),
                            Text(
                              isLoading ? "Loading..." : upiId,
                              style: const TextStyle(color: Colors.greenAccent),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              GestureDetector(
                onTap: showQR,
                child: Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.greenAccent, Colors.teal],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.greenAccent.withOpacity(0.6),
                        blurRadius: 20,
                      )
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      "Show My QR",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.blueGrey.withOpacity(0.3),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lightbulb, color: Colors.yellow),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Tip: Share your QR code with others to receive Shiksha Coins instantly!",
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  ],
                ),
              ),

              const Spacer(),

              GestureDetector(
                onTap: logout,
                child: Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(
                    child: Text(
                      "Log Out",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}