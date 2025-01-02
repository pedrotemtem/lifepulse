import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_analog_clock/flutter_analog_clock.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  TimeOfDay _selectedTime = TimeOfDay(hour: 8, minute: 0);
  List<int> _selectedWeekdays = [];

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

  void scheduleWeeklyNotification(
      int hour, int minute, List<int> weekdays) async {
    for (int weekday in weekdays) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: weekday,
          channelKey: 'basic_channel',
          title: 'Lembrete Diário',
          body: 'Não se esqueça de fazer o seu treino diário!',
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

  void cancelAllNotifications() {
    AwesomeNotifications().cancelAll();
    setState(() {
      _selectedWeekdays.clear();
    });
  }

  /*void _showScheduledNotifications() async {
    List<NotificationModel> scheduledNotifications =
        await AwesomeNotifications().listScheduledNotifications();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notificações Agendadas'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: scheduledNotifications.map((notification) {
                return ListTile(
                  title: Text(notification.content!.title ?? 'No Title'),
                  subtitle: Text(
                      'Scheduled for: ${notification.schedule.toString()}'),
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
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () async {
                    final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: _selectedTime,
                      initialEntryMode: TimePickerEntryMode.dial,
                    );
                    if (picked != null && picked != _selectedTime) {
                      setState(() {
                        _selectedTime = picked;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Defina o horário do seu lembrete diário',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 180,
                          height: MediaQuery.of(context).size.width - 180,
                          child: AnalogClock(
                            key: ValueKey<DateTime>(DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                              _selectedTime.hour,
                              _selectedTime.minute,
                            )),
                            isKeepTime: false,
                            dateTime: DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                              _selectedTime.hour,
                              _selectedTime.minute,
                            ),
                            dialColor: Colors.white,
                            hourHandColor: Colors.black,
                            minuteHandColor: Colors.black,
                            secondHandColor: Colors.red,
                            hourNumberColor: Colors.black,
                            dialBorderColor: Colors.black,
                            centerPointColor: Colors.black,
                            centerPointWidthFactor: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  _selectedTime.format(context),
                  style: TextStyle(fontSize: 24.0),
                ),
                const SizedBox(height: 20),
                WeekdaySelector(
                  initialSelectedWeekdays: _selectedWeekdays,
                  onChanged: (weekdays) {
                    setState(() {
                      _selectedWeekdays = weekdays;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[100],
                    minimumSize: const Size(320, 50),
                  ),
                  onPressed: () {
                    scheduleWeeklyNotification(_selectedTime.hour,
                        _selectedTime.minute, _selectedWeekdays);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Notificações Definidas'),
                          content: const Text(
                              'As notificações foram definidas com sucesso.'),
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
                  },
                  child: const Text('Definir Notificações'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(200, 50),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onPressed: () {
                    cancelAllNotifications();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Notificações Desativadas'),
                         content: const Text(
                            'As notificações foram desativadas com sucesso.'),
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
                  },
                  child: const Text('Destativar Notificações'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TimePickerWidget extends StatefulWidget {
  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay> onTimeChanged;

  const TimePickerWidget({
    required this.initialTime,
    required this.onTimeChanged,
    super.key,
  });

  @override
  _TimePickerWidgetState createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: _selectedTime,
          initialEntryMode: TimePickerEntryMode.dial,
        );
        if (picked != null && picked != _selectedTime) {
          setState(() {
            _selectedTime = picked;
          });
          widget.onTimeChanged(picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          'Horário Selecionado: ${_selectedTime.format(context)}',
          style: const TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}

class WeekdaySelector extends StatefulWidget {
  final Function(List<int>) onChanged;
  final List<int> initialSelectedWeekdays;

  const WeekdaySelector(
      {required this.onChanged,
      required this.initialSelectedWeekdays,
      super.key});

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
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 18.0,
            children: List.generate(4, (index) {
              String weekday =
                  DateFormat.E().format(DateTime(2021, 1, index + 4));
              return FilterChip(
                label: Text(
                  weekday,
                  style: const TextStyle(fontSize: 18.0),
                ),
                padding: const EdgeInsets.all(12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                selected: _selectedWeekdays.contains(index + 1),
                onSelected: (selected) =>
                    _onWeekdaySelected(selected, index + 1),
              );
            }),
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 18.0,
            children: List.generate(3, (index) {
              String weekday =
                  DateFormat.E().format(DateTime(2021, 1, index + 8));
              return FilterChip(
                label: Text(
                  weekday,
                  style: const TextStyle(fontSize: 18.0),
                ),
                padding: const EdgeInsets.all(12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                selected: _selectedWeekdays.contains(index + 5),
                onSelected: (selected) =>
                    _onWeekdaySelected(selected, index + 5),
              );
            }),
          ),
        ],
      ),
    );
  }
}
