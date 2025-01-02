import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Quests extends StatefulWidget {
  final Function(int, int) updateUserScore;
  const Quests({
    required this.updateUserScore,
    super.key,
  });

  @override
  _QuestsState createState() => _QuestsState();
}

class _QuestsState extends State<Quests> {
  List<String> workoutDates = [];
  int streakCountDays = 0;
  final List<Map<String, dynamic>> _quests = [
    // Streak group - increasing streak goals
    {'title': '1 dia de sequência', 'description': 'Complete o cronômetro de 30 minutos por 1 dia!', 'icon': Icons.timer, 'group': 'Streak', 'hearts': 5, 'completed': false},
    {'title': '2 dias de sequência', 'description': 'Complete o cronômetro de 30 minutos por 2 dias seguidos!', 'icon': Icons.timer, 'group': 'Streak', 'hearts': 10, 'completed': false},
    {'title': '3 dias de sequência', 'description': 'Complete o cronômetro de 30 minutos por 3 dias seguidos!', 'icon': Icons.timer, 'group': 'Streak', 'hearts': 15, 'completed': false},
    {'title': '4 dias de sequência', 'description': 'Complete o cronômetro de 30 minutos por 4 dias seguidos!', 'icon': Icons.timer, 'group': 'Streak', 'hearts': 20, 'completed': false},
    {'title': '5 dias de sequência', 'description': 'Complete o cronômetro de 30 minutos por 5 dias seguidos!', 'icon': Icons.timer, 'group': 'Streak', 'hearts': 25, 'completed': false},
    {'title': '6 dias de sequência', 'description': 'Complete o cronômetro de 30 minutos por 6 dias seguidos!', 'icon': Icons.timer, 'group': 'Streak', 'hearts': 30, 'completed': false},
    {'title': '7 dias de sequência', 'description': 'Complete o cronômetro de 30 minutos por 7 dias seguidos!', 'icon': Icons.timer, 'group': 'Streak', 'hearts': 35, 'completed': false},

    // Friends group - increasing friends goals
    {'title': '1 Amigo', 'description': 'Adicine o seu primeiro amigo!', 'icon': Icons.group, 'group': 'Friends', 'hearts': 5, 'completed': false},
    {'title': '4 Amigos', 'description': 'Adicione 2 amigos!', 'icon': Icons.group, 'group': 'Friends', 'hearts': 10, 'completed': false},
    {'title': '10 Amigos', 'description': 'Adicione 10 amigos!', 'icon': Icons.group, 'group': 'Friends', 'hearts': 20, 'completed': false},
    {'title': '15 Amigos', 'description': 'Adicione 15 amigos!', 'icon': Icons.group, 'group': 'Friends', 'hearts': 25, 'completed': false},
    {'title': '20 Amigos', 'description': 'Adicione 20 amigos!', 'icon': Icons.group, 'group': 'Friends', 'hearts': 30, 'completed': false},

    // Health group - New health-related quests
    {'title': 'Meta de Hidratação', 'description': 'Beba 8 copos de água todos os dias durante uma semana!', 'icon': Icons.local_drink, 'group': 'Health', 'hearts': 5, 'completed': false},
    {'title': 'Exercício ao Ar Livre', 'description': 'Exercite-se ao ar livre por pelo menos 30 minutos durante uma semana.', 'icon': Icons.directions_run, 'group': 'Health', 'hearts': 10, 'completed': false},
    {'title': 'Meditação Mindfulness', 'description': 'Pratique meditação mindfulness por 15 minutos durante uma semana.', 'icon': Icons.spa, 'group': 'Health', 'hearts': 15, 'completed': false},
    {'title': 'Meta de Sono', 'description': 'Durma pelo menos 7 horas todas as noites durante uma semana.', 'icon': Icons.bedtime, 'group': 'Health', 'hearts': 20, 'completed': false},
  ];

  @override
  void initState() {
    super.initState();
    _loadWorkoutDates();
    _loadCompletedQuests();
  }

  void _loadWorkoutDates() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      workoutDates = prefs.getStringList('workoutDates') ?? [];
      _calculateStreak();
    });
  }

  void _loadCompletedQuests() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (var quest in _quests) {
        quest['completed'] = prefs.getBool(quest['title']) ?? false;
        quest['scoreCollected'] = prefs.getBool('${quest['title']}_scoreCollected') ?? false;
      }
    });
  }

  void _saveCompletedQuest(String title, bool completed, {bool scoreCollected = false}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(title, completed);
    prefs.setBool('${title}_scoreCollected', scoreCollected);
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
    List<DateTime> last7Days = _getLast7Days().reversed.toList();
    int streak = 0;
    for (DateTime date in last7Days) {
      if (_workedOutOn(date)) {
        streak++;
      } else {
        break;
      }
    }
    print('Calculated streak: $streak');
    setState(() {
      streakCountDays = streak;
    });
  }

  String _getDayName(int weekday) {
    const dayNames = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
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
              "Performance dos últimos 7 dias:",
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
              height: MediaQuery.of(context).size.height - 350,
              child: ExpansionTileExample(
                streakCountDays: streakCountDays,
                saveCompletedQuest: _saveCompletedQuest,
                quests: _quests,
                updateUserScore: widget.updateUserScore,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExpansionTileExample extends StatefulWidget {
  final int streakCountDays;
  final Function(String, bool, {bool scoreCollected}) saveCompletedQuest;
  final List<Map<String, dynamic>> quests;
  final Function(int, int) updateUserScore;

  const ExpansionTileExample({
    required this.streakCountDays,
    required this.saveCompletedQuest,
    required this.quests,
    required this.updateUserScore,
    super.key
  });

  @override
  State<ExpansionTileExample> createState() => _ExpansionTileExampleState();
}

class _ExpansionTileExampleState extends State<ExpansionTileExample> {

  final Map<String, Color> _groupColors = {
    'Streak': Colors.lightGreenAccent,
    'Friends': Colors.lightBlueAccent,
    'Health': Colors.orange,
  };

  int friendsCount = 9;

  @override
  void initState() {
    super.initState();
    _validateQuests();
  }

  void _validateQuests() {
    for (var quest in widget.quests) {
      assert(quest['title'] != null, 'Quest is missing title');
      assert(quest['group'] != null, 'Quest is missing group');
      assert(quest['hearts'] is int, 'Quest hearts should be an integer');
      quest['completed'] ??= false; // Ensure the completed key exists
    }
  }

  bool _isQuestAutomaticallyCompleted(Map<String, dynamic> quest) {
    try {
      if (quest['completed'] == true) {
        return true;
      }

      if (quest['group'] == 'Streak') {
        int streakDays = int.parse(quest['title']!.split(' ')[0]);
        if (widget.streakCountDays >= streakDays) {
          setState(() {
            quest['completed'] = true;
          });
          widget.saveCompletedQuest(quest['title'], true);
          return true;
        }
      } else if (quest['group'] == 'Friends') {
        int friendsRequired = int.parse(quest['title']!.split(' ')[0]);
        if (friendsCount >= friendsRequired) {
          setState(() {
            quest['completed'] = true;
          });
          widget.saveCompletedQuest(quest['title'], true);
          return true;
        }
      }
    } catch (e) {
      debugPrint('Error in _isQuestAutomaticallyCompleted: $e');
    }
    return false;
  }

  /*void _markAsDone(Map<String, dynamic> quest) {
    setState(() {
      quest['completed'] = true;
      widget.saveCompletedQuest(quest['title'], true);
      widget.updateUserScore(10, quest['hearts']);
    });
  }

  void _undoMarkAsDone(Map<String, dynamic> quest) {
    setState(() {
      quest['completed'] = false;
      widget.saveCompletedQuest(quest['title'], false);
      widget.updateUserScore(10, -quest['hearts']);
    });
  }*/

  void _handleDoneButton(BuildContext context, Map<String, dynamic> quest) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar conclusão"),
        content: const Text("Você tem certeza que deseja marcar esta tarefa como concluída?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Não"),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  quest['completed'] = true;
                  quest['scoreCollected'] = true;
                  widget.saveCompletedQuest(quest['title'], true, scoreCollected: true);
                  widget.updateUserScore(10, quest['hearts']);
                });
              },
              child: const Text(
                "Sim",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<Map<String, dynamic>>> groupedQuests = {};
    for (var quest in widget.quests) {
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
    bool isScoreCollected = quest['scoreCollected'] ?? false;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: (isAutomaticallyCompleted || isManuallyCompleted)
            ? color.withOpacity(0.4)
            : Colors.grey.withOpacity(0.2),
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
          if ((isAutomaticallyCompleted || isManuallyCompleted) && !isScoreCollected)
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