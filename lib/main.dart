import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:lifepulse/splash_screen.dart';


void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
    "resource://drawable/noimage",
    [
      NotificationChannel(
        channelKey: "basic_channel",
        channelName: "Basic notifications",
        channelDescription: "Notification channel for basic tests",
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white
      )
    ],
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifePulse',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}