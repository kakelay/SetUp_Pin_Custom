import 'package:flutter/material.dart';

class JotParkPage extends StatelessWidget {
  const JotParkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
        title: const Text('JotPark Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Online/Offline QR Code",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            Container(
              height: 300,
              width: 300,
              child: Image.asset(
                'assets/images/qrcode.png',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
