import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart';

class CreateProfileScreen extends StatefulWidget {
  final String phone; // 🔥 ADD THIS

  const CreateProfileScreen({super.key, required this.phone});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {

  final TextEditingController nameController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  String upiId = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    nameController.addListener(() {
      setState(() {
        upiId = nameController.text
            .trim()
            .toLowerCase()
            .replaceAll(" ", "") + "@upishiksha";
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    /// 🔥 USE PASSED PHONE (NOT FIREBASE)
    String phone = widget.phone.replaceAll("+91", "");

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.8),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100, left: 20, right: 20, bottom: 20),
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

                const Text(
                  "Complete Your Profile",
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Please enter your name to complete your profile setup.",
                  style: TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                /// NAME FIELD
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Your Name",
                    hintStyle: const TextStyle(color: Colors.white54),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// DETAILS BOX
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Text("Your Profile Details:",
                          style: TextStyle(color: Colors.white70)),

                      const SizedBox(height: 10),

                      /// 🔥 FIXED LINE
                      Text("Phone Number: $phone",
                          style: const TextStyle(color: Colors.white)),

                      const SizedBox(height: 5),

                      Text(
                        "UPI ID: ${upiId.isEmpty ? "yourname@upishiksha" : upiId}",
                        style: const TextStyle(color: Colors.green),
                      ),

                      const SizedBox(height: 5),

                      const Text("Starting Balance: ₹10,000",
                          style: TextStyle(color: Colors.green)),
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

                    onPressed: isLoading ? null : () async {

                      if (nameController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Enter your name")),
                        );
                        return;
                      }

                      if (user == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("User not logged in")),
                        );
                        return;
                      }

                      setState(() => isLoading = true);

                      try {

                        String finalUpi = upiId.isEmpty
                            ? "user@upishiksha"
                            : upiId;

                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user!.uid)
                            .set({
                          "name": nameController.text.trim(),
                          "phone": phone, // 🔥 FIXED
                          "upiId": finalUpi,
                          "coins": 10000,
                          "isProfileCreated": true,
                        });

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                        );

                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error: $e")),
                        );
                      } finally {
                        setState(() => isLoading = false);
                      }
                    },

                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.black)
                        : const Text("Create Profile",
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