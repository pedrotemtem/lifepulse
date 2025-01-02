import 'package:flutter/material.dart';

class Leaderboard extends StatefulWidget {
  final int currentUserId;
  final List<Map<String, dynamic>> leaderboardData;
  final Function(int, int) updateUserScore;

  const Leaderboard({
    required this.currentUserId,
    required this.leaderboardData,
    required this.updateUserScore,
    super.key,
  });

  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> sortedLeaderboardData = List.from(widget.leaderboardData);
    sortedLeaderboardData.sort((a, b) => b['score'].compareTo(a['score']));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Classificação'),
      ),
      body: ListView.builder(
        itemCount: widget.leaderboardData.length,
        itemBuilder: (context, index) {
          final player = widget.leaderboardData[index];
          final bool isCurrentUser = player['id'] == widget.currentUserId;

          Widget medalIcon;
          if (index == 0) {
            medalIcon = const Icon(Icons.star, color: Colors.amber);
          } else if (index == 1) {
            medalIcon = const Icon(Icons.star, color: Colors.grey);
          } else if (index == 2) {
            medalIcon = const Icon(Icons.star, color: Colors.brown);
          } else {
            medalIcon = const SizedBox.shrink();
          }

          return Container(
            color: isCurrentUser ? Colors.lightBlue[100] : Colors.transparent,
            child: ListTile(
              leading: CircleAvatar(
                child: Text((index + 1).toString()),
              ),
              title: Row(
                children: [
                  Text(player['name']),
                  const SizedBox(width: 5),
                  medalIcon,
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${player['score']}', style: TextStyle(fontSize: 15)),
                  const Icon(Icons.favorite, color: Colors.red),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}