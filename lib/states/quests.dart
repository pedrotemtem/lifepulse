import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Quests extends StatefulWidget {
  const Quests({super.key});

  @override
  _QuestsState createState() => _QuestsState();
}

class _QuestsState extends State<Quests> {
  List<String> workoutDates = [];
  int streakCountDays = 0;

  @override
  void initState() {
    super.initState();
    _loadWorkoutDates();
  }

  void _loadWorkoutDates() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      workoutDates = prefs.getStringList('workoutDates') ?? [];
      _calculateStreak();
    });
  }

  List<DateTime> _getLast7Days() {
    DateTime now = DateTime.now();
    return List.generate(7, (index) => now.subtract(Duration(days: index))).reversed.toList();
  }

  bool _workedOutOn(DateTime date) {
    return workoutDates.any((workoutDate) {
      DateTime parsedDate = DateTime.parse(workoutDate);
      return parsedDate.year == date.year &&
          parsedDate.month == date.month &&
          parsedDate.day == date.day;
    });
  }

  void _calculateStreak() {
    List<DateTime> last7Days = _getLast7Days();
    int streak = 0;
    for (DateTime date in last7Days) {
      if (_workedOutOn(date)) {
        streak++;
      }
    }
    print('Calculated streak: $streak');
    setState(() {
      streakCountDays = streak;
    });
  }

  String _getDayName(int weekday) {
    const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return dayNames[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> last7Days = _getLast7Days();
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "Last 7 days performance:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: last7Days.map((date) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                    color: _workedOutOn(date) ? Colors.green : Colors.red[400],
                  ),
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(4),
                  child: Column(
                    children: [
                      Text(
                        date.day.toString(),
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _getDayName(date.weekday),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height - 200, // Adjust the height as needed
              child: ExpansionTileExample(streakCountDays: streakCountDays),
            ),
          ],
        ),
      ),
    );
  }
}

class ExpansionTileExample extends StatefulWidget {
  final int streakCountDays;

  const ExpansionTileExample({
    required this.streakCountDays,
    super.key
  });

  @override
  State<ExpansionTileExample> createState() => _ExpansionTileExampleState();
}

class _ExpansionTileExampleState extends State<ExpansionTileExample> {
  final List<Map<String, dynamic>> _quests = [
    {'title': '1 day streak', 'description': 'Complete the 30-minute timer 1 day', 'icon': Icons.timer, 'group': 'Streak', 'hearts': 30, 'completed': false},
    {'title': '2 day streak', 'description': 'Complete the 30-minute timer 2 days in a row!', 'icon': Icons.timer, 'group': 'Streak', 'hearts': 40, 'completed': false},
    {'title': '3 day streak', 'description': 'Complete the 30-minute timer 3 days in a row!', 'icon': Icons.timer, 'group': 'Streak', 'hearts': 50, 'completed': false},
    {'title': '4 day streak', 'description': 'Complete the 30-minute timer 4 days in a row!', 'icon': Icons.timer, 'group': 'Streak', 'hearts': 60, 'completed': false},
    {'title': '5 day streak', 'description': 'Complete the 30-minute timer 5 days in a row!', 'icon': Icons.timer, 'group': 'Streak', 'hearts': 70, 'completed': false},
  ];

  final Map<String, Color> _groupColors = {
    'Streak': Colors.lightGreenAccent,
    'Friends': Colors.lightBlueAccent,
    'Health': Colors.orange,
  };

  @override
  void initState() {
    super.initState();
    _loadQuestCompletion();
  }

  void _loadQuestCompletion() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (var quest in _quests) {
        quest['completed'] = prefs.getBool(quest['title']) ?? false;
        if (quest['group'] == 'Streak') {
          int streakDays = int.parse(quest['title']!.split(' ')[0]);
          if (widget.streakCountDays >= streakDays) {
            quest['completed'] = true;
            prefs.setBool(quest['title'], true);
          }
        }
      }
    });
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
    bool isAutomaticallyCompleted = quest['completed'];
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

  void _handleDoneButton(BuildContext context, Map<String, dynamic> quest) {
    if (quest['completed']) {
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

  void _markAsDone(Map<String, dynamic> quest) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      quest['completed'] = true;
      prefs.setBool(quest['title'], true);
    });
  }
}