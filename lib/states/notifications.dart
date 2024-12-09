import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:intl/intl.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  TimeOfDay _selectedTime = TimeOfDay(hour: 8, minute: 0);
  List<int> _selectedWeekdays = [];
  final CountDownController _controller = CountDownController();
  bool _isRunning = false;
  final int _seconds = 15;
  final int _minutes = 0;

  @override
  void initState() {
    super.initState();
    requestNotificationPermissions();
  }

  void requestNotificationPermissions() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  void scheduleWeeklyNotification(int hour, int minute, List<int> weekdays) async {
    for (int weekday in weekdays) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: weekday,
          channelKey: 'basic_channel',
          title: 'Weekly Notification',
          body: 'This is your weekly notification',
        ),
        schedule: NotificationCalendar(
          weekday: weekday,
          hour: hour,
          minute: minute,
          second: 0,
          millisecond: 0,
          repeats: true,
        ),
      );
    }
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

  void _showScheduledNotifications() async {
    List<NotificationModel> scheduledNotifications = await AwesomeNotifications().listScheduledNotifications();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Scheduled Notifications'),
          content:
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: scheduledNotifications.map((notification) {
                  return ListTile(
                    title: Text(notification.content!.title ?? 'No Title'),
                    subtitle: Text('Scheduled for: ${notification.schedule.toString()}'),
                  );
                }).toList(),
              ),
            ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void cancelAllNotifications() {
    AwesomeNotifications().cancelAll();
  }

  void _showNotificationSettingsDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        List<int> tempSelectedWeekdays = List.from(_selectedWeekdays);
        TimeOfDay tempSelectedTime = _selectedTime;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Notification Settings'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: tempSelectedTime,
                        initialEntryMode: TimePickerEntryMode.dialOnly,
                        builder: (BuildContext context, Widget? child) {
                          return MediaQuery(
                            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                            child: child ?? Container(),
                          );
                        },
                      );
                      if (picked != null) {
                        setState(() {
                          tempSelectedTime = picked;
                        });
                      }
                    },
                    child: const Text('Select Time for Weekly Notification'),
                  ),
                  const SizedBox(height: 20),
                  Text('Selected time: ${tempSelectedTime.format(context)}'),
                  const SizedBox(height: 20),
                  WeekdaySelector(
                    initialSelectedWeekdays: tempSelectedWeekdays,
                    onChanged: (weekdays) {
                      setState(() {
                        tempSelectedWeekdays = weekdays;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: cancelAllNotifications,
                    child: const Text('Remove All Notifications'),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Save'),
                  onPressed: () {
                    setState(() {
                      _selectedTime = tempSelectedTime;
                      _selectedWeekdays = tempSelectedWeekdays;
                    });
                    scheduleWeeklyNotification(_selectedTime.hour, _selectedTime.minute, _selectedWeekdays);
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
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
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _showNotificationSettingsDialog,
                  child: const Text('Notification Settings'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _showScheduledNotifications,
                  child: const Text('Scheduled Notifications'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WeekdaySelector extends StatefulWidget {
  final Function(List<int>) onChanged;
  final List<int> initialSelectedWeekdays;

  const WeekdaySelector({required this.onChanged, required this.initialSelectedWeekdays, super.key});

  @override
  _WeekdaySelectorState createState() => _WeekdaySelectorState();
}

class _WeekdaySelectorState extends State<WeekdaySelector> {
  List<int> _selectedWeekdays = [];

  @override
  void initState() {
    super.initState();
    _selectedWeekdays = widget.initialSelectedWeekdays;
  }

  void _onWeekdaySelected(bool selected, int weekday) {
    setState(() {
      if (selected) {
        _selectedWeekdays.add(weekday);
      } else {
        _selectedWeekdays.remove(weekday);
      }
    });
    widget.onChanged(_selectedWeekdays);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.0,
      children: List.generate(7, (index) {
        String weekday = DateFormat.E().format(DateTime(2021, 1, index + 4));
        return FilterChip(
          label: Text(weekday),
          selected: _selectedWeekdays.contains(index + 1),
          onSelected: (selected) => _onWeekdaySelected(selected, index + 1),
        );
      }),
    );
  }
}