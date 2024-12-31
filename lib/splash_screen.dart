import 'package:flutter/material.dart';
import 'package:lifepulse/homepage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MyHomePage()),
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/lifepulse_name.png',
                width: 300,
                height: 300,
              ),
              const SizedBox(height: 20),
              const Text(
                  'Tap anywhere to start',
                  style: TextStyle(
                      fontSize: 22,
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}