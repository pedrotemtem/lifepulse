import 'package:flutter/material.dart';

class Quests extends StatelessWidget {
  const Quests({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quests'),
      ),
      body: const ExpansionTileExample(),
    );
  }
}

class ExpansionTileExample extends StatefulWidget {
  const ExpansionTileExample({super.key});

  @override
  State<ExpansionTileExample> createState() => _ExpansionTileExampleState();
}

class _ExpansionTileExampleState extends State<ExpansionTileExample> {
  final List<Map<String, dynamic>> _quests = [
    {'title': 'Quest 1', 'subtitle': '1-week streak', 'description': 'Complete the 30 minute timer 7 days in a row!', 'icon': Icons.timer},
    {'title': 'Quest 2', 'subtitle': '2-week streak', 'description': 'Complete 10 exercises in two weeks!', 'icon': Icons.fitness_center},
    {'title': 'Quest 3', 'subtitle': 'Daily meditation', 'description': 'Meditate for 10 minutes each day for a week.', 'icon': Icons.self_improvement},
    {'title': 'Quest 4', 'subtitle': 'Healthy diet', 'description': 'Eat at least 5 servings of vegetables daily for a week.', 'icon': Icons.restaurant},
    {'title': 'Quest 5', 'subtitle': 'Hydration goal', 'description': 'Drink 8 glasses of water every day for a week.', 'icon': Icons.local_drink},
    {'title': 'Quest 6', 'subtitle': 'Reading challenge', 'description': 'Read for at least 20 minutes each day for a week.', 'icon': Icons.book},
    {'title': 'Quest 7', 'subtitle': 'Outdoor activity', 'description': 'Spend 30 minutes outside every day for a week.', 'icon': Icons.nature},
    {'title': 'Quest 8', 'subtitle': 'Sleep goal', 'description': 'Get at least 7 hours of sleep every night for a week.', 'icon': Icons.bedtime},
    {'title': 'Quest 9', 'subtitle': 'Digital detox', 'description': 'Limit screen time to 2 hours daily for a week.', 'icon': Icons.phonelink_erase},
    {'title': 'Quest 10', 'subtitle': 'Gratitude journal', 'description': 'Write down three things you are grateful for each day for a week.', 'icon': Icons.favorite},
  ];

  void _markAsDone(int index) {
    setState(() {
      _quests.removeAt(index);
    });
  }

  void _showConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Done"),
        content: const Text("You have marked this quest as done!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "Undo",
              style: TextStyle(fontSize: 12),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _markAsDone(index);
              Navigator.of(context).pop();
            },
            child: const Text(
              "OK",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _quests.length,
      itemBuilder: (context, index) {
        final quest = _quests[index];
        return _buildQuestTile(quest, index);
      },
    );
  }

  Widget _buildQuestTile(Map<String, dynamic> quest, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueGrey),
        color: Colors.lightBlueAccent,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(quest['icon']),
          ),
          Expanded(
            child: ExpansionTile(
              shape: const RoundedRectangleBorder(),
              title: Text(quest['title']!),
              subtitle: Text(quest['subtitle']!),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[
                ListTile(title: Text(quest['description']!)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.lightGreen,
                border: Border.all(color: Colors.black),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.done,
                  size: 24,
                ),
                onPressed: () {
                  _showConfirmationDialog(context, index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

