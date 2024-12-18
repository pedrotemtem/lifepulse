import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class Timer extends StatefulWidget {
  const Timer({super.key});

  @override
  _TimerState createState() => _TimerState();
}

class _TimerState extends State<Timer> {
  final CountDownController _controller = CountDownController();
  bool _isRunning = false;
  final int _seconds = 15;
  final int _minutes = 0;

  @override
  void initState() {
    super.initState();
  }

  void startTimer() {
    setState(() {
      _isRunning = true;
      _controller.start();
    });
  }

  void stopTimer() {
    setState(() {
      _isRunning = false;
      _controller.pause();
    });
  }

  void resetTimer() {
    setState(() {
      _isRunning = false;
      _controller.reset();
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Timer Completed'),
          content: const Text('The countdown timer has finished.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer'),
      ),
      body: Center(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularCountDownTimer(
                  duration: _minutes * 60 + _seconds,
                  initialDuration: 0,
                  controller: _controller,
                  width: 150,
                  height: 150,
                  ringColor: Colors.grey[300]!,
                  ringGradient: null,
                  fillColor: Colors.purpleAccent,
                  fillGradient: null,
                  backgroundColor: Colors.purple[100],
                  backgroundGradient: null,
                  strokeWidth: 20.0,
                  strokeCap: StrokeCap.round,
                  textStyle: const TextStyle(
                      fontSize: 33.0, color: Colors.black, fontWeight: FontWeight.bold),
                  textFormat: CountdownTextFormat.MM_SS,
                  isReverse: true,
                  isReverseAnimation: true,
                  isTimerTextShown: true,
                  autoStart: false,
                  onStart: () {
                    print('Countdown Started');
                  },
                  onComplete: () {
                    print('Countdown Ended');
                    _showCompletionDialog();
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: startTimer,
                  child: const Text('Start Timer'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: stopTimer,
                  child: const Text('Stop Timer'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: resetTimer,
                  child: const Text('Reset Timer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}