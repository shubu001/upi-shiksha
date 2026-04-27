import 'package:flutter/material.dart';

class LearnUPIScreen extends StatefulWidget {
  const LearnUPIScreen({super.key});

  @override
  State<LearnUPIScreen> createState() => _LearnUPIScreenState();
}

class _LearnUPIScreenState extends State<LearnUPIScreen> {

  bool isEnglish = true;

  void toggleLang(bool value) {
    setState(() {
      isEnglish = value;
    });
  }

  /// 🔥 PREMIUM LANGUAGE BUTTON
  Widget langButton(bool value, String text) {
    bool active = isEnglish == value;

    return GestureDetector(
      onTap: () => toggleLang(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: active
              ? const LinearGradient(
                  colors: [Color(0xFF00FF88), Color(0xFF00C853)])
              : null,
          color: active ? null : Colors.white10,
        ),
        child: Text(
          text,
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

    List<Map<String, dynamic>> tips = isEnglish
        ? [
            {"icon": Icons.shield, "text": "Always verify recipient details before sending money"},
            {"icon": Icons.warning, "text": "Never share your OTP or PIN"},
            {"icon": Icons.lock, "text": "Beware of phishing scams"},
            {"icon": Icons.phone_android, "text": "Enable 2FA security"},
            {"icon": Icons.check_circle, "text": "Avoid unknown payment requests"},
            {"icon": Icons.verified_user, "text": "Verify QR authenticity"},
            {"icon": Icons.system_update, "text": "Keep apps updated"},
            {"icon": Icons.visibility_outlined, "text": "Report suspicious activity"},
          ]
        : [
            {"icon": Icons.shield, "text": "पैसे भेजने से पहले जांच करें"},
            {"icon": Icons.warning, "text": "OTP या PIN शेयर न करें"},
            {"icon": Icons.lock, "text": "फर्जी स्कैम से बचें"},
            {"icon": Icons.phone_android, "text": "2FA चालू रखें"},
            {"icon": Icons.check_circle, "text": "अनजान रिक्वेस्ट से बचें"},
            {"icon": Icons.verified_user, "text": "QR जांचें"},
            {"icon": Icons.system_update, "text": "ऐप अपडेट रखें"},
            {"icon": Icons.visibility_outlined, "text": "संदिग्ध गतिविधि रिपोर्ट करें"},
          ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF061A2F), Color(0xFF0B1E35)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: Column(
            children: [

              /// 🔥 HEADER
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new,
                              color: Colors.white, size: 18),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Text(
                          isEnglish
                              ? "Learn Safe UPI"
                              : "सुरक्षित UPI",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        langButton(true, "EN"),
                        langButton(false, "हिंदी"),
                      ],
                    )
                  ],
                ),
              ),

              /// 🔥 CONTENT
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [

                    /// 🔥 HERO CARD
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.withOpacity(0.2),
                            Colors.transparent
                          ],
                        ),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green.withOpacity(0.2),
                            ),
                            child: const Icon(Icons.security,
                                color: Colors.green, size: 35),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            isEnglish
                                ? "Stay Safe Online"
                                : "ऑनलाइन सुरक्षित रहें",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isEnglish
                                ? "Protect yourself from UPI frauds & scams"
                                : "UPI धोखाधड़ी से खुद को बचाएं",
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white70),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// 🔥 TIPS
                    ...tips.map((item) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.white.withOpacity(0.05),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green.withOpacity(0.2),
                              ),
                              child: Icon(item["icon"],
                                  color: Colors.green),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                item["text"],
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14),
                              ),
                            )
                          ],
                        ),
                      );
                    }).toList(),

                    const SizedBox(height: 20),

                    /// 🔥 EXTRA KNOWLEDGE BOX
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.orange),
                        color: Colors.orange.withOpacity(0.05),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEnglish
                                ? "Did You Know?"
                                : "क्या आप जानते हैं?",
                            style: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            isEnglish
                                ? "UPI transactions are instant but irreversible. Always double-check before sending money."
                                : "UPI ट्रांजैक्शन तुरंत होते हैं लेकिन वापस नहीं होते। भेजने से पहले जांच करें।",
                            style: const TextStyle(color: Colors.white70),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// 🔥 SCAM BOX
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.red),
                        color: Colors.red.withOpacity(0.05),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            isEnglish
                                ? "Common Scam Signs"
                                : "धोखाधड़ी संकेत",
                            style: const TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            isEnglish
                                ? "• OTP requests\n• Unknown links\n• Lottery scams\n• Urgent calls\n• Fake bank alerts"
                                : "• OTP मांगना\n• अनजान लिंक\n• लॉटरी स्कैम\n• फर्जी कॉल\n• बैंक धोखा",
                            style: const TextStyle(color: Colors.white70),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}