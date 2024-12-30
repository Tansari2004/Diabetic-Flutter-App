import 'package:flutter/material.dart';

class BMICalculator extends StatefulWidget {
  @override
  _BMICalculatorState createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _gender = 'Male';
  String _bmiResult = '';
  String _bmiInterpretation = '';
  String _improvementTips = '';

  void _calculateBMI() {
    final double height = double.parse(_heightController.text) / 100;
    final double weight = double.parse(_weightController.text);
    final double bmi = weight / (height * height);

    setState(() {
      _bmiResult = bmi.toStringAsFixed(1);
      _bmiInterpretation = _getBMIInterpretation(bmi);
      _improvementTips = _getImprovementTips(bmi);
    });
  }

  String _getBMIInterpretation(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return 'Normal weight';
    } else if (bmi >= 25 && bmi < 29.9) {
      return 'Overweight';
    } else {
      return 'Obesity';
    }
  }

  String _getImprovementTips(double bmi) {
    if (bmi < 18.5) {
      return 'You are underweight. Consider eating more balanced meals with higher calorie content. Engage in strength training exercises to build muscle mass. Consult with a healthcare provider for a personalized plan.';
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return 'You have a normal weight. Maintain your current lifestyle by eating a balanced diet and engaging in regular physical activity. Continue to monitor your BMI and make adjustments as needed.';
    } else if (bmi >= 25 && bmi < 29.9) {
      return 'You are overweight. Consider adopting a healthier diet with fewer calories and more fruits and vegetables. Increase your physical activity, focusing on both cardio and strength training exercises. Consult with a healthcare provider for a personalized plan.';
    } else {
      return 'You are in the obesity range. It is important to take action to reduce your weight to lower your risk of health problems. Consider working with a healthcare provider to create a comprehensive weight loss plan that includes a healthy diet, regular exercise, and possibly behavioral therapy.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
      ),
      body: Container(
        color: Color(0xFFE0F7FA),
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: [
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Height (cm)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Weight (kg)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Age',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _gender,
              items: <String>['Male', 'Female'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _gender = newValue!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateBMI,
              child: Text('Calculate BMI'),
            ),
            SizedBox(height: 20),
            Text(
              'BMI: $_bmiResult',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Interpretation: $_bmiInterpretation',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Improvement Tips: $_improvementTips',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
