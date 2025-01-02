import 'package:flutter/material.dart';
import 'package:lifepulse/states/timer.dart';

class TrainingSelection extends StatelessWidget {
  final PageController pageController;
  const TrainingSelection({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              pageController.jumpToPage(4);
            },
            icon: const Icon(Icons.person, size: 40),
            label: const Text('Treinar Sozinho'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(300, 60),
              textStyle: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
              minimumSize: const Size(300, 60),
              textStyle: const TextStyle(fontSize: 20),
            ),
            icon: const Icon(Icons.group, size: 40),
            label: const Text('Treinar em Grupo'),
          ),
        ],
      ),
    );
  }
}