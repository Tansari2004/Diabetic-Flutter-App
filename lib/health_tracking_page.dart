import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Medication {
  final String name;
  final int doses;
  final String time;

  Medication({
    required this.name,
    required this.doses,
    required this.time,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      name: json['name'],
      doses: json['doses'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'doses': doses,
      'time': time,
    };
  }
}

class MedicationTracker extends StatefulWidget {
  @override
  _MedicationTrackerState createState() => _MedicationTrackerState();
}

class _MedicationTrackerState extends State<MedicationTracker> {
  final TextEditingController _medicationNameController = TextEditingController();
  final TextEditingController _dosesController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  List<Medication> _medications = [];

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _loadMedications();
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {},
    );
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _scheduleNotification(Medication medication) async {
    final timeParts = medication.time.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    final now = DateTime.now();
    final scheduledTime = DateTime(now.year, now.month, now.day, hour, minute);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Medication Reminder',
      'It\'s time to take your medication: ${medication.name}',
      tz.TZDateTime.from(scheduledTime, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id',
          'your_channel_name',
          channelDescription: 'your_channel_description',
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  void _loadMedications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? medicationsString = prefs.getString('medications');
    if (medicationsString != null) {
      List<dynamic> medicationsJson = jsonDecode(medicationsString);
      setState(() {
        _medications = medicationsJson.map((e) => Medication.fromJson(e)).toList();
      });
    }
  }

  void _saveMedications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('medications', jsonEncode(_medications));
  }

  void _addMedication() {
    final String name = _medicationNameController.text;
    final int doses = int.parse(_dosesController.text);
    final String time = _timeController.text;

    setState(() {
      final medication = Medication(name: name, doses: doses, time: time);
      _medications.add(medication);
      _scheduleNotification(medication);
      _medicationNameController.clear();
      _dosesController.clear();
      _timeController.clear();
    });
    _saveMedications();
  }

  Widget _buildMedicationList() {
    return ListView.builder(
      itemCount: _medications.length,
      itemBuilder: (context, index) {
        final medication = _medications[index];
        return ListTile(
          title: Text('${medication.name}'),
          subtitle: Text('Doses: ${medication.doses}, Time: ${medication.time}'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medication Tracker'),
      ),
      body: Container(
        color: Color(0xFFE0F7FA),
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _medicationNameController,
              decoration: InputDecoration(
                labelText: 'Medication Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _dosesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Doses',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _timeController,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                labelText: 'Time (HH:MM)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addMedication,
              child: Text('Add Medication'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _medications.isEmpty
                  ? Center(
                      child: Text('No medications added yet. Add some medications to see the list.'),
                    )
                  : _buildMedicationList(),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  tz.initializeTimeZones();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medication Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MedicationTracker(),
    );
  }
}