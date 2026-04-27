import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  // User ka data save karne ka function
  static Future<void> saveNewUser(String name) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // 1. Name ko clean karo (spaces hatao aur lowercase karo)
        String cleanName = name.trim().toLowerCase().replaceAll(' ', '');
        
        // 2. RangeError se bachne ke liye safe UPI ID generation
        // Agar naam khali ho toh 'user' use hoga, warna pura naam
        String finalNamePart = cleanName.isEmpty ? "user" : cleanName;
        String autoUpiId = "$finalNamePart@upishiksha";

        // 3. Firestore mein data save karna (Capital 'F' in FirebaseFirestore)
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': name.trim(),
          'phone': user.phoneNumber,
          'upiId': autoUpiId,
          'shikshaCoins': 10000, // Naye user ko 10,000 coins free gift
          'uid': user.uid,
          'createdAt': FieldValue.serverTimestamp(),
        });
        
        print("User Saved to Database successfully!");
      } catch (e) {
        print("Error saving user: $e");
      }
    } else {
      print("No user is currently signed in.");
    }
  }

  // User ka data fetch karne ka function (StartScreen ke liye)
  static Stream<DocumentSnapshot> getUserData() {
    User? user = FirebaseAuth.instance.currentUser;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .snapshots();
  }
}