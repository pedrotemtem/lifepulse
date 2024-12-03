import 'package:flutter/material.dart';

class Quests extends StatelessWidget {
  const Quests({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
    // Streak group - increasing streak goals
    {'title': '1-week streak', 'description': 'Complete the 30-minute timer 7 days in a row!', 'icon': Icons.timer, 'group': 'Streak', 'hearts': 30},
    {'title': '2-week streak', 'description': 'Complete 10 exercises in two weeks!', 'icon': Icons.timer, 'group': 'Streak', 'hearts': 40},
    {'title': '3-week streak', 'description': 'Complete 15 exercises in three weeks!', 'icon': Icons.timer, 'group': 'Streak', 'hearts': 50},
    {'title': '4-week streak', 'description': 'Complete 20 exercises in four weeks!', 'icon': Icons.timer, 'group': 'Streak', 'hearts': 60},
    {'title': '5-week streak', 'description': 'Complete 25 exercises in five weeks!', 'icon': Icons.timer, 'group': 'Streak', 'hearts': 70},

    // Friends group - increasing friends goals
    {'title': '1 Friend', 'description': 'Add your first friend to the app!', 'icon': Icons.group, 'group': 'Friends', 'hearts': 10},
    {'title': '4 Friends', 'description': 'Add 4 friends to the app!', 'icon': Icons.group, 'group': 'Friends', 'hearts': 20},
    {'title': '10 Friends', 'description': 'Add 10 friends to the app!', 'icon': Icons.group, 'group': 'Friends', 'hearts': 30},
    {'title': '15 Friends', 'description': 'Add 15 friends to the app!', 'icon': Icons.group, 'group': 'Friends', 'hearts': 40},
    {'title': '20 Friends', 'description': 'Add 20 friends to the app!', 'icon': Icons.group, 'group': 'Friends', 'hearts': 50},

    // Health group - New health-related quests
    {'title': 'Hydration Goal', 'description': 'Drink 8 glasses of water every day for a week!', 'icon': Icons.local_drink, 'group': 'Health', 'hearts': 20},
    {'title': 'Outdoor Exercise', 'description': 'Exercise outdoors for at least 30 minutes every day for a week.', 'icon': Icons.directions_run, 'group': 'Health', 'hearts': 25},
    {'title': 'Mindfulness Meditation', 'description': 'Practice mindfulness meditation for 15 minutes every day for a week.', 'icon': Icons.spa, 'group': 'Health', 'hearts': 30},
    {'title': 'Sleep Goal', 'description': 'Sleep at least 7 hours every night for a week.', 'icon': Icons.bedtime, 'group': 'Health', 'hearts': 35},
  ];

  final Map<String, Color> _groupColors = {
    'Streak': Colors.lightGreenAccent,
    'Friends': Colors.lightBlueAccent,
    'Health': Colors.orange,
  };

  int streakCountDays = 28; // Streak count in days
  int friendsCount = 10; // Friend count

  @override
  void initState() {
    super.initState();
    _validateQuests();
  }

  void _validateQuests() {
    for (var quest in _quests) {
      assert(quest['title'] != null, 'Quest is missing title');
      assert(quest['group'] != null, 'Quest is missing group');
      assert(quest['hearts'] is int, 'Quest hearts should be an integer');
      quest['completed'] ??= false; // Ensure the completed key exists
    }
  }

  bool _isQuestAutomaticallyCompleted(Map<String, dynamic> quest) {
    try {
      if (quest['group'] == 'Streak') {
        int streakWeeks = int.parse(quest['title']!.split('-')[0]);
        return streakCountDays >= (streakWeeks * 7);
      } else if (quest['group'] == 'Friends') {
        int friendsRequired = int.parse(quest['title']!.split(' ')[0]);
        return friendsCount >= friendsRequired;
      }
    } catch (e) {
      debugPrint('Error in _isQuestAutomaticallyCompleted: $e');
    }
    return false;
  }

  void _markAsDone(Map<String, dynamic> quest) {
    setState(() {
      quest['completed'] = true;
    });
  }

  void _undoMarkAsDone(Map<String, dynamic> quest) {
    setState(() {
      quest['completed'] = false;
    });
  }

  void _handleDoneButton(BuildContext context, Map<String, dynamic> quest) {
    if (_isQuestAutomaticallyCompleted(quest)) {
      // Show a dialog informing the user
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Quest Automatically Tracked"),
          content: const Text("This quest is automatically tracked and cannot be marked manually."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else {
      // Show confirmation dialog before marking as completed
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Confirm Completion"),
          content: const Text("Are you sure you want to mark this quest as completed?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("No"),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _markAsDone(quest);
                },
                child: const Text(
                  "Yes",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      );
    }
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
                return _buildQuestTile(quest, _groupColors[group]!);
              }).toList(),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildQuestTile(Map<String, dynamic> quest, Color color) {
    bool isAutomaticallyCompleted = _isQuestAutomaticallyCompleted(quest);
    bool isManuallyCompleted = quest['completed'] ?? false;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: (isAutomaticallyCompleted || isManuallyCompleted)
            ? Colors.grey.withOpacity(0.4)
            : color.withOpacity(0.2),
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
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[ListTile(title: Text(quest['description']!))],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 5),
            child: Row(
              children: [
                Text(
                  '${quest['hearts']}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: (isAutomaticallyCompleted || isManuallyCompleted) ? Colors.grey : Colors.black,
                  ),
                ),
                Icon(
                  Icons.favorite,
                  color: (isAutomaticallyCompleted || isManuallyCompleted) ? Colors.grey : Colors.red,
                  size: 18,
                ),
              ],
            ),
          ),
          if (quest['group'] == 'Health' && !isAutomaticallyCompleted && !isManuallyCompleted)
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
                onPressed: () => _handleDoneButton(context, quest),
              ),
            ),
        ],
      ),
    );
  }
}

