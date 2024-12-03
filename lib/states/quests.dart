import 'package:flutter/material.dart';

class Quests extends StatelessWidget {
  const Quests({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
    {'title': 'Quest 1', 'subtitle': '1-week streak', 'description': 'Complete the 30 minute timer 7 days in a row!', 'icon': Icons.timer, 'group': 'Streak', 'hearts': 30},
    {'title': 'Quest 2', 'subtitle': '2-week streak', 'description': 'Complete 10 exercises in two weeks!', 'icon': Icons.fitness_center, 'group': 'Streak', 'hearts': 40},
    {'title': 'Quest 3', 'subtitle': 'Daily meditation', 'description': 'Meditate for 10 minutes each day for a week.', 'icon': Icons.self_improvement, 'group': 'Friends', 'hearts': 20},
    {'title': 'Quest 4', 'subtitle': 'Healthy diet', 'description': 'Eat at least 5 servings of vegetables daily for a week.', 'icon': Icons.restaurant, 'group': 'Health', 'hearts': 25},
    {'title': 'Quest 5', 'subtitle': 'Hydration goal', 'description': 'Drink 8 glasses of water every day for a week.', 'icon': Icons.local_drink, 'group': 'Health', 'hearts': 15},
    {'title': 'Quest 6', 'subtitle': 'Reading challenge', 'description': 'Read for at least 20 minutes each day for a week.', 'icon': Icons.book, 'group': 'Friends', 'hearts': 20},
    {'title': 'Quest 7', 'subtitle': 'Outdoor activity', 'description': 'Spend 30 minutes outside every day for a week.', 'icon': Icons.nature, 'group': 'Health', 'hearts': 30},
    {'title': 'Quest 8', 'subtitle': 'Sleep goal', 'description': 'Get at least 7 hours of sleep every night for a week.', 'icon': Icons.bedtime, 'group': 'Health', 'hearts': 35},
    {'title': 'Quest 9', 'subtitle': 'Digital detox', 'description': 'Limit screen time to 2 hours daily for a week.', 'icon': Icons.phonelink_erase, 'group': 'Health', 'hearts': 25},
    {'title': 'Quest 10', 'subtitle': 'Gratitude journal', 'description': 'Write down three things you are grateful for each day for a week.', 'icon': Icons.favorite, 'group': 'Friends', 'hearts': 20},
    {'title': 'Quest 11', 'subtitle': 'Workout buddy', 'description': 'Exercise with a friend three times a week for a month.', 'icon': Icons.group, 'group': 'Friends', 'hearts': 50},
    {'title': 'Quest 12', 'subtitle': 'Weekly meetup', 'description': 'Catch up with a friend over coffee once a week for a month.', 'icon': Icons.coffee, 'group': 'Friends', 'hearts': 30},
    {'title': 'Quest 13', 'subtitle': 'Mindfulness practice', 'description': 'Practice mindfulness meditation for 15 minutes daily for two weeks.', 'icon': Icons.spa, 'group': 'Health', 'hearts': 40},
  ];

  final Map<String, Color> _groupColors = {
    'Streak': Colors.lightGreenAccent,
    'Friends': Colors.lightBlueAccent,
    'Health': Colors.orange,
  };

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
    Map<String, List<Map<String, dynamic>>> groupedQuests = {};
    for (var quest in _quests) {
      if (!groupedQuests.containsKey(quest['group'])) {
        groupedQuests[quest['group']] = [];
      }
      groupedQuests[quest['group']]!.add(quest);
    }

    return ListView(
      children: groupedQuests.keys.map((group) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                group,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Column(
              children: groupedQuests[group]!.map((quest) {
                final index = _quests.indexOf(quest);
                return _buildQuestTile(quest, index, _groupColors[group]!);
              }).toList(),
            )
          ],
        );
      }).toList(),
    );
  }

  Widget _buildQuestTile(Map<String, dynamic> quest, int index, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        border: Border.all(color: Colors.blueGrey),
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
            padding: const EdgeInsets.only(left: 10, right: 5),
            child: Row(
              children: [
                Text(
                  '${quest['hearts']}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 18,
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
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
        ],
      ),
    );
  }
}
