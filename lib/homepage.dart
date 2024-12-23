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

  static List<Widget> _widgetOptions(PageController pageController) => <Widget>[
    const Notifications(),
    TrainingSelection(pageController: pageController),
    const Quests(),
    const Leaderboard(),
    const Timer(),
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
          children: _widgetOptions(_pageController),
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