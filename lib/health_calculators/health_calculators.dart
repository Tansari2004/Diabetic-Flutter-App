
import 'package:flutter/material.dart';
import 'bmi_calculator.dart';
import 'calorie_needs_calculator.dart';
import 'blood_sugar_tracker.dart'; // Ensure this matches the file and class name
import 'insulin_dosage_calculator.dart';
import 'a1c_estimator.dart';
import 'carbohydrate_counting.dart';
import 'insulin_resistance_calculator.dart';

class HealthCalculators extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Calculators'),
      ),
      body: Container(
        color: Color(0xFFE0F7FA),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              _buildCalculatorButton(
                context,
                'BMI Calculator',
                'Calculate your Body Mass Index',
                Icons.calculate,
                BMICalculator(),
              ),
              _buildCalculatorButton(
                context,
                'Calorie Needs Calculator',
                'Calculate your daily caloric needs',
                Icons.fastfood,
                CalorieNeedsCalculator(),
              ),
              _buildCalculatorButton(
                context,
                'Blood Sugar Tracker',
                'Track your blood sugar levels',
                Icons.show_chart,
                BloodSugarTracker(), // Ensure this matches the file and class name
              ),
              _buildCalculatorButton(
                context,
                'Insulin Dosage Calculator',
                'Calculate your insulin dosage',
                Icons.healing,
                InsulinDosageCalculator(),
              ),
              _buildCalculatorButton(
                context,
                'A1C Estimator',
                'Estimate your A1C levels',
                Icons.assessment,
                A1CEstimator(),
              ),
              _buildCalculatorButton(
                context,
                'Carbohydrate Counting',
                'Calculate your daily carbohydrate intake',
                Icons.restaurant,
                CarbohydrateCounting(),
              ),
              _buildCalculatorButton(
                context,
                'Insulin Resistance Calculator',
                'Check for insulin resistance',
                Icons.local_hospital,
                InsulinResistanceCalculator(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalculatorButton(
      BuildContext context, String title, String description, IconData icon, Widget page) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Icon(icon, size: 40, color: Colors.blueAccent),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
        trailing: Icon(Icons.arrow_forward, color: Colors.blueAccent),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
      ),
    );
  }
}