import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class Timer extends StatefulWidget {
  final Function(int) onTrainingComplete;
  final Function onWorkoutComplete;
  const Timer({
    required this.onTrainingComplete,
    required this.onWorkoutComplete,
    super.key,
  });

  @override
  _TimerState createState() => _TimerState();
}

class _TimerState extends State<Timer> {
  final CountDownController _controller = CountDownController();
  final int _seconds = 5;
  final int _minutes = 0;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
  }

  void startTimer() {
    setState(() {
      if (_isPaused) {
        _controller.resume();
      } else {
        _controller.start();
      }
      _isPaused = false;
    });
  }

  void stopTimer() {
    setState(() {
      _controller.pause();
      _isPaused = true;
    });
  }

  void resetTimer() {
    setState(() {
      _controller.reset();
      _isPaused = false;
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
              'Congratulations!',
              style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold
              ),
          ),
          content:const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'You have completed today\'s training!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 10),
              Text(
                'You have gained:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '30',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 26.0,
                        color: Colors.red,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(width: 5),
                  Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 40.0,
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                widget.onTrainingComplete(30);
                widget.onWorkoutComplete();
              },
            ),
          ],
        );
      },
    );
  }

  void _showStopTrainingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Stop Workout?'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Are you sure you want to stop the training?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 10),
                Text(
                  'You will not gain any hearts!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0),
                ),
              ],
            ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                _controller.resume();
              },
            ),
            TextButton(
              child: const Text('Stop'),
              onPressed: () {
                resetTimer();
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
        title: Container(
          width: double.infinity,
          color: Colors.lightBlue[200],
          padding: const EdgeInsets.all(16.0),
          child: const Text(
            'Train Alone',
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularCountDownTimer(
                    duration: _minutes * 60 + _seconds,
                    initialDuration: 0,
                    controller: _controller,
                    width: 200,
                    height: 200,
                    ringColor: Colors.blueGrey,
                    ringGradient: null,
                    fillColor: Colors.blue[600]!,
                    fillGradient: null,
                    backgroundColor: Colors.blue[100],
                    backgroundGradient: null,
                    strokeWidth: 60.0,
                    strokeCap: StrokeCap.round,
                    textStyle: const TextStyle(
                        fontSize: 50.0, color: Colors.black, fontWeight: FontWeight.bold),
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
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        iconSize: 48,
                        icon: const Icon(Icons.play_arrow),
                        onPressed: startTimer,
                      ),
                      IconButton(
                        iconSize: 48,
                        icon: const Icon(Icons.pause),
                        onPressed: stopTimer,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: Icon(Icons.stop, size: 48, color: Colors.grey[700],),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size.fromWidth(260),
                backgroundColor: Colors.grey[300],
              ),
              onPressed: () {
                _controller.pause();
                _showStopTrainingDialog();
              },
              label:
                Text(
                  'Stop training',
                  style: TextStyle(
                      fontSize: 28,
                      color: Colors.grey[800]!,
                  )
                ),
            ),
          ),
        ],
      ),
    );
  }
}