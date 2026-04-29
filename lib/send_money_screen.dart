import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SendMoneyScreen extends StatefulWidget {
  final String scannedName;
  final String scannedUpiId;

  const SendMoneyScreen({
    super.key,
    required this.scannedName,
    required this.scannedUpiId,
  });

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {

  final TextEditingController upiController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  String receiverName = "";
  int balance = 0;

  @override
  void initState() {
    super.initState();

    upiController.text = widget.scannedUpiId;

    fetchBalance();

    upiController.addListener(() {
      detectUser();
    });
  }

  /// 🔥 FETCH BALANCE
  void fetchBalance() async {
    final user = FirebaseAuth.instance.currentUser;

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();

    setState(() {
      balance = doc['coins'] ?? 0;
    });
  }

  /// 🔥 DETECT USER (FAKE DEMO)
  void detectUser() {
    String input = upiController.text.trim();

    if (input == "1234567890" || input == "1234567890@upishiksha") {
      setState(() => receiverName = "User 1");
    } else if (input == "9876543210" || input == "9876543210@upi") {
      setState(() => receiverName = "User 2");
    } else {
      setState(() => receiverName = "");
    }
  }

  /// 🔥 SEND MONEY (FIXED)
  void sendMoney() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (receiverName.isEmpty) {
        showResult(false, "Invalid Receiver");
        return;
      }

      if (amountController.text.isEmpty) {
        showResult(false, "Enter amount");
        return;
      }

      int amount = int.parse(amountController.text);

      if (amount > balance) {
        showResult(false, "Insufficient Balance");
        return;
      }

      print("🔥 STARTING TRANSACTION...");
      print("USER ID: ${user!.uid}");
      print("RECEIVER: $receiverName");
      print("AMOUNT: $amount");

      /// 🔥 TEMP: SAME USER (so it shows in transactions)
      await FirebaseFirestore.instance.collection("transactions").add({
        "from": user.uid,
        "to": user.uid,
        "amount": amount,
        "time": Timestamp.now(),
      });

      print("✅ TRANSACTION SAVED");

      /// 🔥 UPDATE BALANCE
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .update({
        "coins": FieldValue.increment(-amount),
      });

      setState(() {
        balance -= amount;
      });

      showResult(true, "Payment Successful");

    } catch (e) {
      print("❌ ERROR: $e");
      showResult(false, "Payment Failed");
    }
  }

  void showResult(bool success, String message) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xFF0E2239),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Icon(
                success ? Icons.check_circle : Icons.cancel,
                color: success ? Colors.green : Colors.red,
                size: 80,
              ),

              const SizedBox(height: 15),

              Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),

              const SizedBox(height: 15),

              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 11, 30, 53),
      resizeToAvoidBottomInset: true,

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF061A2F), Color(0xFF0B1E35)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                children: [

                  /// HEADER
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text("Send Money",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// CARD
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green),
                      color: const Color(0xFF0E2239),
                    ),
                    child: Column(
                      children: [

                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.green,
                          child: Icon(Icons.send, color: Colors.white),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          "Recipient Phone Number ",
                          style: TextStyle(color: Colors.white),
                        ),

                        const SizedBox(height: 10),

                        TextField(
                          controller: upiController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Enter the phone number",
                            hintStyle:
                                const TextStyle(color: Colors.white54),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 11, 30, 53),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                        ),

                        const SizedBox(height: 10),

                        if (receiverName.isNotEmpty)
                          Text(
                            "Receiver: $receiverName",
                            style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),

                        const SizedBox(height: 20),

                        const Text("Amount (Shiksha Coins)",
                            style: TextStyle(color: Colors.white)),

                        const SizedBox(height: 10),

                        TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            prefixText: "₹ ",
                            prefixStyle:
                                const TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 11, 30, 53),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.green)),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          "Available: ₹$balance",
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: sendMoney,
                    child: Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Text("Send Money",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.blue),
                    ),
                    child: const Text(
                      "💡 Tip: Always verify the recipient details before sending money.",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}