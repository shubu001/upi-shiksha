import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {

  final player = AudioPlayer();
  final user = FirebaseAuth.instance.currentUser;

  String language = "EN";

  List<Map<String, dynamic>> questionsEN = [
    {
      "q": "What should you do if someone asks for your UPI PIN or OTP?",
      "options": [
        "Share it only with trusted people",
        "Never share it with anyone, including bank officials",
        "Share it if they say they are from the bank",
        "Share it only over phone calls"
      ],
      "answer": 1
    },
    {
      "q": "Which is a safe UPI practice?",
      "options": [
        "Sharing OTP",
        "Keeping PIN secret",
        "Using public WiFi",
        "Clicking unknown links"
      ],
      "answer": 1
    },
    {
      "q": "Safe app download?",
      "options": [
        "Unknown links",
        "Official store",
        "Messages",
        "Ads"
      ],
      "answer": 1
    },
  ];

  List<Map<String, dynamic>> questionsHI = [
    {
      "q": "अगर कोई आपसे UPI PIN या OTP मांगे तो क्या करें?",
      "options": [
        "दोस्तों को बता सकते हैं",
        "किसी को भी नहीं बताना चाहिए",
        "अगर बैंक बोले तो बता दें",
        "फोन पर बता दें"
      ],
      "answer": 1
    },
    {
      "q": "सुरक्षित UPI तरीका क्या है?",
      "options": [
        "OTP शेयर करना",
        "PIN को गुप्त रखना",
        "पब्लिक WiFi यूज़ करना",
        "अनजान लिंक क्लिक करना"
      ],
      "answer": 1
    },
  ];

  List<Map<String, dynamic>> get questions =>
      language == "EN" ? questionsEN : questionsHI;

  int current = 0;
  int selected = -1;
  int score = 0;
  bool showResult = false;

  @override
  void initState() {
    super.initState();
    questionsEN.shuffle();
    questionsHI.shuffle();
  }

  /// 🔊 FIXED SOUND (IMPORTANT)
  Future<void> playSound() async {
    try {
      await player.setReleaseMode(ReleaseMode.stop);
      await player.play(
        AssetSource('sounds/coin.mp3'),
        mode: PlayerMode.lowLatency,
      );
    } catch (e) {
      print("Sound error: $e");
    }
  }

  Future<void> updateCoins(int amount) async {
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .update({
      "coins": FieldValue.increment(amount)
    });
  }

  void nextQuestion() async {
    if (selected == -1) return;

    if (selected == questions[current]['answer']) {
      score++;
      CoinData.coins += 1000;
      await updateCoins(1000);
      await playSound();
    }

    if (current == questions.length - 1) {
      setState(() => showResult = true);
    } else {
      setState(() {
        current++;
        selected = -1;
      });
    }
  }

  /// 🔥 PREMIUM LANGUAGE BUTTON
  Widget langButton(String lang) {
    bool active = language == lang;

    return GestureDetector(
      onTap: () {
        setState(() {
          language = lang;
          current = 0;
          score = 0;
          selected = -1;
          showResult = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: active
              ? const LinearGradient(
                  colors: [Color(0xFF00FF88), Color(0xFF00C853)])
              : null,
          color: active ? null : Colors.white10,
        ),
        child: Text(
          lang == "EN" ? "EN" : "हिंदी",
          style: TextStyle(
            color: active ? Colors.black : Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    if (showResult) {
      int earned = score * 1000;

      return Scaffold(
        backgroundColor: const Color(0xFF061A2F),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.green),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Congratulations 🎉",
                    style: TextStyle(fontSize: 22, color: Colors.white)),
                Text("You scored $score / ${questions.length}",
                    style: const TextStyle(color: Colors.white)),
                Text("You earned ₹$earned",
                    style: const TextStyle(color: Colors.green)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Back"),
                )
              ],
            ),
          ),
        ),
      );
    }

    double progress = (current + 1) / questions.length;

    return Scaffold(
      backgroundColor: const Color(0xFF061A2F),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              /// 🔥 HEADER
              Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [

    /// 🔙 BACK + TITLE
    Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        const Text(
          "UPI Safety Quiz",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ],
    ),

    /// 🌐 LANGUAGE TOGGLE
    Row(
      children: [
        langButton("EN"),
        const SizedBox(width: 5),
        langButton("HI"),
      ],
    )
  ],
),
              const SizedBox(height: 20),

              LinearProgressIndicator(
                value: progress,
                color: Colors.green,
                backgroundColor: Colors.white12,
              ),

              const SizedBox(height: 25),

              Text(
                questions[current]['q'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: 25),

              /// 🔥 PREMIUM OPTIONS
              ...List.generate(4, (index) {
                return GestureDetector(
                  onTap: () => setState(() => selected = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 60,
                    margin: const EdgeInsets.only(bottom: 12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: selected == index
                          ? const LinearGradient(
                              colors: [Color(0xFF00FF88), Color(0xFF00C853)])
                          : null,
                      border: Border.all(
                        color: selected == index
                            ? Colors.green
                            : Colors.white24,
                      ),
                    ),
                    child: Text(
                      questions[current]['options'][index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: selected == index
                            ? Colors.black
                            : Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }),

              const Spacer(),

              /// 🔥 BUTTON
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: nextQuestion,
                child: const Text("Next",
                    style: TextStyle(color: Colors.black)),
              )
            ],
          ),
        ),
      ),
    );
  }
}