import 'package:flutter/material.dart';
import 'main.dart';
import 'send_money_screen.dart';
import 'quiz_screen.dart';
import 'scan_qr_screen.dart';
import 'profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'transaction_screen.dart';
import 'start_screen.dart';
import 'learn_upi_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    checkFirstTimeUser();
  }

  Future<void> checkFirstTimeUser() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    if (!doc.exists || doc.data()?['isProfileCreated'] != true) {
      Future.delayed(Duration.zero, () {
        showWelcomePopup();
      });
    }
  }

  void refresh() {
    setState(() {});
  }

  /// 🔥 PREMIUM CARD (UPDATED DESIGN)
  Widget card(String title, String subtitle,IconData icon, VoidCallback onTap, Color color) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),

          /// 🔥 GLASS EFFECT
          color: Colors.white.withOpacity(0.01),

           border: Border.all(color: const Color.fromARGB(255, 105, 240, 174)),

          /// 🔥 GLOW
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.01),
              blurRadius: 4,
              spreadRadius: 0.1,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.15),
              ),
              child: Icon(icon, color: color, size: 36),
            ),
            const SizedBox(height: 15),
            Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),

                    /// SUBTITLE
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Color.fromARGB(174, 255, 255, 255),
                    fontSize:13,
                    height:1.3,
                    )
                  )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          /// 🔥 BACKGROUND
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Container(color: Colors.black.withOpacity(0.7)),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  /// 🔝 HEADER
                 Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    
    const SizedBox(height: 10),

    /// 🔥 LEFT SIDE (LOGO + TEXT)
    Row(
      children: [

        /// LOGO WITH SOFT GLOW BG
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.15),
          ),
          child: Image.asset(
            "assets/logo.png", // 👉 apna logo yaha
            height: 40,
            width: 50,
          ),
        ),

        const SizedBox(width: 0),

        /// APP NAME
        const Text(
          "UPI-SHIKSHA",
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ],
    ),

    /// 🔥 RIGHT SIDE (PROFILE WITH GLOW)
    GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProfileScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(1), // glow thickness
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [
              Color(0xFF00FF88),
              Color(0xFF00C853),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.9),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const CircleAvatar(
          radius: 20,
          backgroundColor: Color(0xFF0E2239),
          child: Icon(Icons.person, color: Colors.white),
        ),
      ),
    ),
  ],
),

const SizedBox(height: 50), // 👈 HEADER ke baad add kar

/// 🔥 COIN CARD

StreamBuilder(
  stream: FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .snapshots(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return const CircularProgressIndicator();
    }

    var data = snapshot.data!;
    int coins = data['coins'] ?? 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 5), // 👈 subtle spacing
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          colors: [
            Colors.green.withOpacity(0.1),
            Colors.transparent
          ],
        ),
        border: Border.all(color: const Color.fromARGB(255, 105, 240, 174)),
        boxShadow: [
          BoxShadow(
            color: Colors.greenAccent.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            "₹$coins",
            style: const TextStyle(
              fontSize: 32,
              color: Colors.greenAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Shiksha Coins 🪙",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  },
),

                  /// 🔥 GRID (UNCHANGED LOGIC)
                  const SizedBox(height: 20),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 30,
                      mainAxisSpacing: 30,
                      
                      childAspectRatio: 1.1,
                      children: [

                        card("Learn UPI",
                        "Learn safe payments", 
                        
                        Icons.menu_book, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const LearnUPIScreen()),
                          );
                        }, const Color.fromARGB(255, 16, 219, 23)), 

                        card("Send Money",
                        "Send coins easily",
                         Icons.send_to_mobile_sharp, () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SendMoneyScreen(
                                  scannedName: '',
                                  scannedUpiId: '',
                                )),
                          );
                          refresh();
                        }, const Color.fromARGB(255, 77, 255, 169)),

                        card("Scan QR", 
                        "Scan & pay",
                        Icons.qr_code_scanner, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ScanQRScreen()),
                          );
                        }, const Color.fromARGB(255, 34, 223, 176)),

                        card("Quiz",
                        "Test your knowledge",
                         Icons.psychology, () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const QuizScreen()),
                          );
                          setState(() {});
                        }, Colors.yellow),

                        card("Transactions",
                        "View history",
                         Icons.sync_alt, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const TransactionScreen()),
                          );
                        }, Colors.orange),
                      ],
                    ),
                  ),
                  
                  const Text("©️ 2026 UPI-Shiksha. All rights reserved.",
                      style: TextStyle(color: Color.fromARGB(138, 255, 255, 255), 
                      fontSize:11)),
                      
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

void showWelcomePopup() {
}