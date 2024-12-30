import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class BloodSugarTracker extends StatefulWidget {
  @override
  _BloodSugarTrackerState createState() => _BloodSugarTrackerState();
}

class _BloodSugarTrackerState extends State<BloodSugarTracker> {
  final TextEditingController _bloodSugarController = TextEditingController();
  String _mealTiming = 'Before Meal';
  List<BloodSugarEntry> _entries = [];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  void _loadEntries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? entriesString = prefs.getString('blood_sugar_entries');
    if (entriesString != null) {
      List<dynamic> entriesJson = jsonDecode(entriesString);
      setState(() {
        _entries = entriesJson.map((e) => BloodSugarEntry.fromJson(e)).toList();
      });
    }
  }

  void _saveEntries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('blood_sugar_entries', jsonEncode(_entries));
  }

  void _addEntry() {
    final double? bloodSugar = double.tryParse(_bloodSugarController.text);
    if (bloodSugar == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid blood sugar level.')),
      );
      return;
    }
    final DateTime now = DateTime.now();

    setState(() {
      _entries.add(BloodSugarEntry(
          sugarLevel: bloodSugar, dateTime: now, mealTiming: _mealTiming));
      _bloodSugarController.clear();
    });
    _saveEntries();
  }

  String _getBloodSugarAdvice(double bloodSugar, String mealTiming) {
    String advice;
    String category;

    if (mealTiming == 'Before Meal') {
      if (bloodSugar < 70) {
        category = 'Low';
        advice =
            'Your blood sugar is low. Consider having a small snack and monitor your levels. If you frequently experience low blood sugar, consult your doctor.';
      } else if (bloodSugar >= 70 && bloodSugar < 100) {
        category = 'Moderate';
        advice = 'Your blood sugar is moderately low. Keep monitoring it.';
      } else if (bloodSugar >= 100 && bloodSugar <= 130) {
        category = 'Perfect';
        advice = 'Your blood sugar is perfect. Keep up the good work!';
      } else {
        category = 'High';
        advice =
            'Your blood sugar is high. Consider consulting your doctor and reviewing your diet and medication.';
      }
    } else if (mealTiming == '2 Hours After Meal') {
      if (bloodSugar < 70) {
        category = 'Low';
        advice =
            'Your blood sugar is low. Consider having a small snack and monitor your levels. If you frequently experience low blood sugar, consult your doctor.';
      } else if (bloodSugar >= 70 && bloodSugar < 140) {
        category = 'Moderate';
        advice = 'Your blood sugar is moderately low. Keep monitoring it.';
      } else if (bloodSugar >= 140 && bloodSugar <= 180) {
        category = 'Perfect';
        advice = 'Your blood sugar is perfect. Keep up the good work!';
      } else {
        category = 'High';
        advice =
            'Your blood sugar is high. Consider consulting your doctor and reviewing your diet and medication.';
      }
    } else {
      category = 'Unknown';
      advice = 'No advice available.';
    }

    return 'Category: $category\nAdvice: $advice';
  }

  Widget _buildEntryList() {
    return ListView.builder(
      itemCount: _entries.length,
      itemBuilder: (context, index) {
        final entry = _entries[index];
        final advice = _getBloodSugarAdvice(entry.sugarLevel, entry.mealTiming);
        return ListTile(
          title: Text(
            '${entry.sugarLevel} mg/dL (${entry.mealTiming})',
            style: TextStyle(
              color: entry.sugarLevel > 180
                  ? Colors.red
                  : entry.sugarLevel < 70
                      ? Colors.orange
                      : Colors.green,
            ),
          ),
          subtitle: Text('${entry.dateTime}\n$advice'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Sugar Tracker'),
      ),
      body: Container(
        color: Color(0xFFE0F7FA),
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _bloodSugarController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Blood Sugar Level (mg/dL)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _mealTiming,
              items: <String>['Before Meal', '2 Hours After Meal']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _mealTiming = newValue!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Timing',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addEntry,
              child: Text('Add Entry'),
            ),
            SizedBox(height: 20),
            Expanded(child: _buildEntryList()),
          ],
        ),
      ),
    );
  }
}

class BloodSugarEntry {
  final double sugarLevel;
  final DateTime dateTime;
  final String mealTiming;

  BloodSugarEntry({
    required this.sugarLevel,
    required this.dateTime,
    required this.mealTiming,
  });

  factory BloodSugarEntry.fromJson(Map<String, dynamic> json) {
    return BloodSugarEntry(
      sugarLevel: json['sugarLevel'].toDouble(),
      dateTime: DateTime.parse(json['dateTime']),
      mealTiming: json['mealTiming'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sugarLevel': sugarLevel,
      'dateTime': dateTime.toIso8601String(),
      'mealTiming': mealTiming,
    };
  }
}