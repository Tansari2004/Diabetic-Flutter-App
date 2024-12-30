import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';

class BloodSugarEntry {
  final double sugarLevel;
  final DateTime dateTime;
  final String mealTiming;
  final String diabetesType;

  BloodSugarEntry({
    required this.sugarLevel,
    required this.dateTime,
    required this.mealTiming,
    required this.diabetesType,
  });

  factory BloodSugarEntry.fromJson(Map<String, dynamic> json) {
    if (json['sugarLevel'] == null) {
      throw Exception('sugarLevel cannot be null');
    }
    return BloodSugarEntry(
      sugarLevel: json['sugarLevel'].toDouble(),
      dateTime: DateTime.parse(json['dateTime']),
      mealTiming: json['mealTiming'],
      diabetesType: json['diabetesType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sugarLevel': sugarLevel,
      'dateTime': dateTime.toIso8601String(),
      'mealTiming': mealTiming,
      'diabetesType': diabetesType,
    };
  }
}

class BloodSugarTracker extends StatefulWidget {
  @override
  _BloodSugarTrackerState createState() => _BloodSugarTrackerState();
}

class _BloodSugarTrackerState extends State<BloodSugarTracker> {
  final TextEditingController _bloodSugarController = TextEditingController();
  String _mealTiming = 'Before Meal';
  String _diabetesType = 'Type 1';
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
      // Show error if the blood sugar value is not a valid number
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid blood sugar level.')),
      );
      return;
    }
    final DateTime now = DateTime.now();

    setState(() {
      _entries.add(BloodSugarEntry(
          sugarLevel: bloodSugar, dateTime: now, mealTiming: _mealTiming, diabetesType: _diabetesType));
      _bloodSugarController.clear();
    });
    _saveEntries();
  }

  String _getBloodSugarAdvice(double bloodSugar, String mealTiming, String diabetesType) {
    String advice;
    String category;

    if (diabetesType == 'Type 1') {
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
    } else if (diabetesType == 'Type 2') {
      // Similar structure, adjust the ranges and messages as needed
      if (mealTiming == 'Before Meal') {
        if (bloodSugar < 80) {
          category = 'Low';
          advice =
              'Your blood sugar is low. Consider having a small snack and monitor your levels. If you frequently experience low blood sugar, consult your doctor.';
        } else if (bloodSugar >= 80 && bloodSugar < 110) {
          category = 'Moderate';
          advice = 'Your blood sugar is moderately low. Keep monitoring it.';
        } else if (bloodSugar >= 110 && bloodSugar <= 140) {
          category = 'Perfect';
          advice = 'Your blood sugar is perfect. Keep up the good work!';
        } else {
          category = 'High';
          advice =
              'Your blood sugar is high. Consider consulting your doctor and reviewing your diet and medication.';
        }
      } else if (mealTiming == '2 Hours After Meal') {
        if (bloodSugar < 90) {
          category = 'Low';
          advice =
              'Your blood sugar is low. Consider having a small snack and monitor your levels. If you frequently experience low blood sugar, consult your doctor.';
        } else if (bloodSugar >= 90 && bloodSugar < 160) {
          category = 'Moderate';
          advice = 'Your blood sugar is moderately low. Keep monitoring it.';
        } else if (bloodSugar >= 160 && bloodSugar <= 200) {
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
    } else {
      category = 'Unknown';
      advice = 'No advice available.';
    }

    return 'Category: $category\nAdvice: $advice';
  }

  List<FlSpot> _generateSpots(String mealTiming, String diabetesType) {
    List<BloodSugarEntry> filteredEntries = _entries.where((entry) => entry.mealTiming == mealTiming && entry.diabetesType == diabetesType).toList();
    return List.generate(
      filteredEntries.length,
      (index) => FlSpot(index.toDouble(), filteredEntries[index].sugarLevel),
    );
  }

  LineChartData _buildChartData(String mealTiming, String diabetesType) {
    return LineChartData(
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true),
        ),
      ),
      borderData: FlBorderData(show: true),
      lineBarsData: [
        LineChartBarData(
          spots: _generateSpots(mealTiming, diabetesType),
          isCurved: true,
          barWidth: 4,
          belowBarData: BarAreaData(show: false),
          dotData: FlDotData(show: false),
          color: Colors.blue,
        ),
        if (mealTiming == 'Before Meal' && diabetesType == 'Type 1')
          LineChartBarData(
            spots: List.generate(_entries.length, (index) => FlSpot(index.toDouble(), 130)),
                           isCurved: true,
               barWidth: 4,
               belowBarData: BarAreaData(show: false),
               dotData: FlDotData(show: false),
               color: Colors.red,
             ),
           if (mealTiming == 'Before Meal' && diabetesType == 'Type 2')
             LineChartBarData(
               spots: List.generate(_entries.length, (index) => FlSpot(index.toDouble(), 140)),
               isCurved: true,
               barWidth: 4,
               belowBarData: BarAreaData(show: false),
               dotData: FlDotData(show: false),
               color: Colors.green,
             ),
           if (mealTiming == '2 Hours After Meal' && diabetesType == 'Type 1')
             LineChartBarData(
               spots: List.generate(_entries.length, (index) => FlSpot(index.toDouble(), 180)),
               isCurved: true,
               barWidth: 4,
               belowBarData: BarAreaData(show: false),
               dotData: FlDotData(show: false),
               color: Colors.red,
             ),
           if (mealTiming == '2 Hours After Meal' && diabetesType == 'Type 2')
             LineChartBarData(
               spots: List.generate(_entries.length, (index) => FlSpot(index.toDouble(), 180)),
               isCurved: true,
               barWidth: 4,
               belowBarData: BarAreaData(show: false),
               dotData: FlDotData(show: false),
               color: Colors.green,
             ),
         ],
       );
     }

     Widget _buildEntryList() {
       return ListView.builder(
         itemCount: _entries.length,
         itemBuilder: (context, index) {
           final entry = _entries[index];
           final advice = _getBloodSugarAdvice(entry.sugarLevel, entry.mealTiming, entry.diabetesType);
           return ListTile(
             title: Text(
               '${entry.sugarLevel} mg/dL (${entry.mealTiming}) - ${entry.diabetesType}',
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
           actions: [
             IconButton(
               icon: Icon(Icons.refresh),
               onPressed: () {
                 setState(() {
                   _entries.clear();
                 });
               },
             ),
           ],
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
               DropdownButtonFormField<String>(
                 value: _diabetesType,
                 items: <String>['Type 1', 'Type 2']
                     .map((String value) {
                   return DropdownMenuItem<String>(
                     value: value,
                     child: Text(value),
                   );
                 }).toList(),
                 onChanged: (newValue) {
                   setState(() {
                     _diabetesType = newValue!;
                   });
                 },
                 decoration: InputDecoration(
                   labelText: 'Diabetes Type',
                   border: OutlineInputBorder(),
                 ),
               ),
               SizedBox(height: 10),
               ElevatedButton(
                 onPressed: _addEntry,
                 child: Text('Add Entry'),
               ),
               SizedBox(height: 20),
               Expanded(
                 child: _entries.isEmpty
                     ? Center(
                         child: Text('No entries yet. Add some entries to see the chart.'),
                       )
                     : Column(
                         children: [
                           Text(
                             'Blood Sugar Levels Before Meal',
                             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                           ),
                           SizedBox(
                             height: 200,
                             child: LineChart(
                               _buildChartData('Before Meal', _diabetesType),
                             ),
                           ),
                           SizedBox(height: 20),
                           Text(
                             'Blood Sugar Levels 2 Hours After Meal',
                             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                           ),
                           SizedBox(
                             height: 200,
                             child: LineChart(
                               _buildChartData('2 Hours After Meal', _diabetesType),
                             ),
                           ),
                           Expanded(child: _buildEntryList()),
                         ],
                       ),
               ),
             ],
           ),
         ),
       );
     }
   }