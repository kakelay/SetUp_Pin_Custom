import 'package:flutter/material.dart';

class JotParkPage extends StatelessWidget {
  const JotParkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JotPark'),
      ),
      body: const Center(
        child: Text('Welcome to JotPark!'),
      ),
    );
  }
}
