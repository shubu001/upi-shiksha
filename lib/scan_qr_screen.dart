import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'send_money_screen.dart';

class ScanQRScreen extends StatefulWidget {
  const ScanQRScreen({super.key});

  @override
  State<ScanQRScreen> createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> {
  bool isScanning = false;
  bool isScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF061A2F),
      body: Stack(
        children: [

          /// 📸 CAMERA
          if (isScanning)
            MobileScanner(
              onDetect: (barcodeCapture) {
                if (isScanned) return;

                final barcode = barcodeCapture.barcodes.first;
                final String? code = barcode.rawValue;

                if (code != null) {
                  setState(() {
                    isScanned = true;
                  });

                  try {
                    // 🔥 QR DATA SPLIT
                    final parts = code.split("|");

                    if (parts.length < 2) {
                      throw Exception("Invalid QR");
                    }

                    String name = parts[0];
                    String upiId = parts[1];

                    // 🔥 OPEN SEND MONEY SCREEN
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SendMoneyScreen(
                          scannedUpiId: upiId,
                          scannedName: name,
                        ),
                      ),
                    );

                  } catch (e) {
                    // ❌ INVALID QR
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Error"),
                        content: const Text("Invalid QR Code"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() {
                                isScanned = false;
                              });
                            },
                            child: const Text("OK"),
                          )
                        ],
                      ),
                    );
                  }
                }
              },
            ),

          /// 🌑 DARK OVERLAY
          if (isScanning)
            Container(color: Colors.black.withOpacity(0.6)),

          /// 📱 UI
          SafeArea(
            child: Column(
              children: [

                /// 🔝 TOP BAR
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        "Scan QR Code",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// 📦 CARD
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1B3358), Color(0xFF0B1E35)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green),
                    ),
                    child: Column(
                      children: [

                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Colors.blue, Colors.lightBlueAccent],
                            ),
                          ),
                          child: const Icon(Icons.qr_code,
                              size: 40, color: Colors.white),
                        ),

                        const SizedBox(height: 15),

                        const Text(
                          "Position the QR code within the frame to scan",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70),
                        ),

                        const SizedBox(height: 20),

                        /// 🔘 BUTTON
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: Colors.green,
                            ),
                            onPressed: () {
                              setState(() {
                                isScanning = true;
                                isScanned = false;
                              });
                            },
                            child: const Text(
                              "Start Camera",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// 💡 TIP BOX
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.blueAccent),
                    ),
                    child: const Text(
                      "💡 Tip: Always verify the recipient details before making a payment.",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// 🟩 SCAN BOX
                if (isScanning)
                  Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}