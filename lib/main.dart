import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'start_screen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'splash_screen.dart';
import 'home_screen.dart';
Future<void> saveUserData(String phone) async {
  await FirebaseFirestore.instance.collection("users").add({
    "phone": phone,
    "createdAt": DateTime.now(),
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
await FirebaseAppCheck.instance.activate(androidProvider:AndroidProvider.debug,);
  runApp(const MyApp());
}

class CoinData {
  static int coins = 10000;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}