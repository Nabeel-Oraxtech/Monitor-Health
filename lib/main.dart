import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:monitor_health/components/video_player.dart';
import 'package:monitor_health/payment.dart';
import 'package:monitor_health/vitals.dart';
import 'package:monitor_health/pdfviewer.dart';
import 'package:signature/signature.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: MonitorHealth(),
      ),
    ),
  );
}

class MonitorHealth extends StatefulWidget {
  const MonitorHealth({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MonitorHealthState createState() => _MonitorHealthState();
}

class _MonitorHealthState extends State<MonitorHealth> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  Uint8List? _signatureBytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          // Signature Pad
          Expanded(
            child: Signature(
              controller: _controller,
              height: 300,
              backgroundColor: Colors.white,
            ),
          ),
          // Save, Clear, and Graph Buttons
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Clear the signature pad
                    _controller.clear();
                    // Clear the saved signature bytes
                    setState(() {
                      _signatureBytes = null;
                    });
                  },
                  child: const Text('Clear'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the Graph screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const VitalsScreen()),
                    );
                  },
                  child: const Text('Graph'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PdfViewerScreen()),
                    );
                  },
                  child: const Text('Pdf'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VideoPlayerScreen()),
                    );
                  },
                  child: const Text('Video'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PaymentScreen()),
                    );
                  },
                  child: const Text('Payment'),
                ),
              ],
            ),
          ),
          // Display the saved signature image
          if (_signatureBytes != null) ...[
            const SizedBox(height: 20),
            Image.memory(_signatureBytes!),
          ],
        ],
      ),
    );
  }
}
