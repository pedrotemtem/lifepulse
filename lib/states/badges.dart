import 'package:flutter/material.dart';

class Badges extends StatelessWidget {
  const Badges({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Badges'),
      ),
      body: const Center(
        child: Text('This is Badges'),
      ),
    );
  }
}