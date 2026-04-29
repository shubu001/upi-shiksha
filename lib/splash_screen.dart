import 'dart:async';
import 'package:flutter/material.dart';
import 'start_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  late AnimationController controller;
  late Animation<double> scaleAnim;
  late Animation<double> fadeAnim;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    scaleAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOutCubic),
    );

    fadeAnim = Tween<double>(begin: 0, end: 1).animate(controller);

    controller.forward();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => StartScreen()),
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          /// 🌌 FULL BG
          Positioned.fill(
            child: Image.asset(
              "assets/bg.jpeg",
              fit: BoxFit.cover,
            ),
          ),

          /// 🌑 DARK CINEMATIC OVERLAY
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.7),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          /// 🔥 LIGHT GLOW CENTER
          Center(
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                return Opacity(
                  opacity: fadeAnim.value,
                  child: Transform.scale(
                    scale: scaleAnim.value,
                    child: child,
                  ),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  /// 💎 PREMIUM LOGO GLOW
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.greenAccent.withOpacity(0.4),
                          blurRadius: 80,
                          spreadRadius: 9,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      "assets/logo.png",
                      width: 150,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🔤 TEXT
                  const Text(
                    "UPI-SHIKSHA",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}