import 'package:flutter/material.dart';

class Quests extends StatelessWidget {
  const Quests({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quests'),
      ),
      body: const Center(
        child: Text('This is Quests'),
      ),
    );
  }
}