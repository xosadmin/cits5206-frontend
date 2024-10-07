import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

// QRCodePage: A page to display the generated QR code
class QRCodePage extends StatelessWidget {
  final String data; // This is the data for the QR code

  QRCodePage({required this.data}); // Constructor that accepts the data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Share/Download"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the QR code
            QrImageView(
              data: data, // The data to encode as a QR code
              version: QrVersions.auto, // Auto select the best version for the data
              size: 200.0, // Size of the QR code
            ),
            SizedBox(height: 20),
            Text(
              "Scan the QR code to download/share the note",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10.0),
            Text(
              "podcast.mp3",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
