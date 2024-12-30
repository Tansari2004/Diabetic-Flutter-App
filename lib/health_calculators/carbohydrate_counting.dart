import 'package:flutter/material.dart';

class CarbohydrateCounting extends StatefulWidget {
  @override
  _CarbohydrateCountingState createState() => _CarbohydrateCountingState();
}

class _CarbohydrateCountingState extends State<CarbohydrateCounting> {
  final TextEditingController _carbIntakeController = TextEditingController();
  String _mealTiming = 'Before Meal';
  String _exerciseIntensity = 'Moderate';
  String _result = '';

  void _calculateCarbohydrates() {
    final double? carbIntake = double.tryParse(_carbIntakeController.text);
    if (carbIntake == null) {
      // Show error if the carb intake value is not a valid number
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid carbohydrate intake.')),
      );
      return;
    }

    setState(() {
      _result = _getCarbAdvice(carbIntake, _mealTiming, _exerciseIntensity);
      _carbIntakeController.clear();
    });
  }

  String _getCarbAdvice(double carbIntake, String mealTiming, String exerciseIntensity) {
    String advice;
    String category;

    if (mealTiming == 'Before Meal') {
      if (carbIntake < 30) {
        category = 'Low';
        advice =
            'Your carbohydrate intake is low. Consider having a balanced meal with adequate carbs, proteins, and fats. Monitor your levels to avoid hypoglycemia.';
      } else if (carbIntake >= 30 && carbIntake < 60) {
        category = 'Moderate';
        advice =
            'Your carbohydrate intake is moderate. Ensure you maintain a balanced diet and monitor your blood sugar levels.';
      } else {
        category = 'High';
        advice =
            'Your carbohydrate intake is high. Consider consulting your dietitian for a balanced meal plan to avoid hyperglycemia.';
      }
    } else if (mealTiming == '2 Hours After Meal') {
      if (carbIntake < 30) {
        category = 'Low';
        advice =
            'Your carbohydrate intake is low. Consider having a balanced meal with adequate carbs, proteins, and fats. Monitor your levels to avoid hypoglycemia.';
      } else if (carbIntake >= 30 && carbIntake < 60) {
        category = 'Moderate';
        advice =
            'Your carbohydrate intake is moderate. Ensure you maintain a balanced diet and monitor your blood sugar levels.';
      } else {
        category = 'High';
        advice =
            'Your carbohydrate intake is high. Consider consulting your dietitian for a balanced meal plan to avoid hyperglycemia.';
      }
    } else {
      category = 'Unknown';
      advice = 'No advice available.';
    }

    if (exerciseIntensity == 'Moderate') {
      advice +=
          '\nWith moderate exercise, ensure you maintain adequate carbohydrate intake to sustain energy levels.';
    } else if (exerciseIntensity == 'Intense') {
      advice +=
          '\nWith intense exercise, monitor your carbohydrate intake closely to avoid both hyperglycemia and hypoglycemia. Consider consulting your healthcare provider for a tailored plan.';
    }

    return 'Category: $category\nAdvice: $advice';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carbohydrate Counting'),
      ),
      body: Container(
        color: Color(0xFFE0F7FA),
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: [
            TextField(
              controller: _carbIntakeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Carbohydrate Intake (g)',
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
              value: _exerciseIntensity,
              items: <String>['Moderate', 'Intense']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _exerciseIntensity = newValue!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Exercise Intensity',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _calculateCarbohydrates,
              child: Text('Calculate Carbohydrates'),
            ),
            SizedBox(height: 20),
            Text(
              _result,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
