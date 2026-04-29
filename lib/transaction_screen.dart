import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF061A2F),

      body: SafeArea(
        child: Column(
          children: [

            /// HEADER
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text("Transactions",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ],
            ),

            const SizedBox(height: 10),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("transactions")
                    .orderBy("time", descending: true)
                    .snapshots(),

                builder: (context, snapshot) {

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(color: Colors.green));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("No Transactions Yet",
                          style: TextStyle(color: Colors.white70)),
                    );
                  }

                  final docs = snapshot.data!.docs;

                  /// 🔥 FILTER USER TX
                  final userTx = docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return data['from'] == user!.uid ||
                        data['to'] == user.uid;
                  }).toList();

                  if (userTx.isEmpty) {
                    return const Center(
                      child: Text("No Transactions Yet",
                          style: TextStyle(color: Colors.white70)),
                    );
                  }

                  return ListView.builder(
                    itemCount: userTx.length,
                    itemBuilder: (context, index) {

                      final data =
                          userTx[index].data() as Map<String, dynamic>;

                      bool isSent = data['from'] == user!.uid;
                      int amount = data['amount'];

                      Timestamp timeStamp = data['time'];
                      DateTime date = timeStamp.toDate();

                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 8),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xFF0E2239),
                        ),
                        child: Row(
                          children: [

                            CircleAvatar(
                              radius: 25,
                              backgroundColor:
                                  isSent ? Colors.red : Colors.green,
                              child: Icon(
                                isSent
                                    ? Icons.arrow_upward
                                    : Icons.arrow_downward,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(width: 15),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    isSent ? "Sent" : "Received",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),

                                  const SizedBox(height: 5),

                                  Text(
                                    "${date.day}/${date.month}/${date.year}  ${date.hour}:${date.minute}",
                                    style: const TextStyle(
                                        color: Colors.white54,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ),

                            Text(
                              "${isSent ? "- " : "+ "}₹$amount",
                              style: TextStyle(
                                color: isSent ? Colors.red : Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}