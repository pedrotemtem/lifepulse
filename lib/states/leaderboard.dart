import 'package:flutter/material.dart';

class Leaderboard extends StatelessWidget {
  const Leaderboard({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulated leaderboard data with Portuguese names
    final List<Map<String, dynamic>> leaderboardData = [
      {'id': 1, 'name': 'João', 'score': 200},
      {'id': 2, 'name': 'Ana', 'score': 180},
      {'id': 3, 'name': 'Carlos', 'score': 160},
      {'id': 4, 'name': 'Maria', 'score': 150},
      {'id': 5, 'name': 'Rui', 'score': 140},
      {'id': 6, 'name': 'Sofia', 'score': 130},
      {'id': 7, 'name': 'Miguel', 'score': 120},
      {'id': 8, 'name': 'Inês', 'score': 110},
      {'id': 9, 'name': 'Pedro', 'score': 100},
      {'id': 10, 'name': 'Carla', 'score': 90},
    ];

    // ID of the current user (can be dynamic)
    final int currentUserId = 5; // Maria will be highlighted

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
      ),
      body: ListView.builder(
        itemCount: leaderboardData.length,
        itemBuilder: (context, index) {
          final player = leaderboardData[index];
          final bool isCurrentUser = player['id'] == currentUserId;

          // Determine the medal icon based on the rank
          Widget medalIcon;
          if (index == 0) {
            medalIcon = const Icon(Icons.star, color: Colors.amber); // Gold medal
          } else if (index == 1) {
            medalIcon = const Icon(Icons.star, color: Colors.grey); // Silver medal
          } else if (index == 2) {
            medalIcon = const Icon(Icons.star, color: Colors.brown); // Bronze medal
          } else {
            medalIcon = const SizedBox.shrink(); // No icon for others
          }

          return Container(
            // Highlight the current user with a light blue background
            color: isCurrentUser ? Colors.lightBlue[100] : Colors.transparent,
            child: ListTile(
              leading: CircleAvatar(
                child: Text((index + 1).toString()), // Position number
              ),
              title: Row(
                children: [
                  Text(player['name']), // Name first
                  const SizedBox(width: 5), // Space between name and medal/icon
                  medalIcon, // Medal icon if applicable
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min, // Adjusts size to fit content
                children: [
                  Text('${player['score']}', style: TextStyle(fontSize: 15)), // Increased font size
                  const Icon(Icons.favorite, color: Colors.red), // Heart icon
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
