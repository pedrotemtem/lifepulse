import 'package:flutter/material.dart';
import 'package:lifepulse/states/training_selection.dart';
import 'package:lifepulse/states/notifications.dart';
import 'package:lifepulse/states/timer.dart';
import 'package:lifepulse/states/quests.dart';
import 'package:lifepulse/states/leaderboard.dart';
import 'package:lifepulse/splash_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  List<Map<String, dynamic>> leaderboardData = [
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
  void updateUserScore(int userId, int points) {
    setState(() {
      for (var player in leaderboardData) {
        if (player['id'] == userId) {
          player['score'] += points;
          break;
        }
      }
      leaderboardData.sort((a, b) => b['score'].compareTo(a['score']));
    });
  }

  static List<Widget> _widgetOptions(
      PageController pageController,
      List<Map<String, dynamic>> leaderboardData,
      Function(int, int) updateUserScore) => <Widget>[
    const Notifications(),
    TrainingSelection(pageController: pageController),
    const Quests(),
    Leaderboard(
        currentUserId: 9,
        leaderboardData: leaderboardData,
        updateUserScore: updateUserScore
    ),
    Timer(onTrainingComplete: (int points){
      updateUserScore(9, points);
    }),
  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('LifePulse'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SplashScreen()),
              );
            },
          ),
        ),
        body: PageView(
          controller: _pageController,
          children: _widgetOptions(_pageController, leaderboardData, updateUserScore),
          onPageChanged: (int index) {
            if (index < 3) {
              setState(() {
                _selectedIndex = index;
              });
            }
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timer),
              label: 'Timer',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Quests',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard),
              label: 'Leaderboard',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          unselectedItemColor: Colors.grey[800],
          onTap: _onItemTapped,
        ),
      );
  }
}