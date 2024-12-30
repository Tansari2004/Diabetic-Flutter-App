import 'package:flutter/material.dart';

class InsulinDosageCalculator extends StatefulWidget {
  @override
  _InsulinDosageCalculatorState createState() => _InsulinDosageCalculatorState();
}

class _InsulinDosageCalculatorState extends State<InsulinDosageCalculator> {
  final TextEditingController _currentBloodSugarController = TextEditingController();
  final TextEditingController _targetBloodSugarController = TextEditingController();
  final TextEditingController _carbohydratesController = TextEditingController();
  String _insulinDosageResult = '';
  String _advice = '';

  void _calculateInsulinDosage() {
    final double currentBloodSugar = double.parse(_currentBloodSugarController.text);
    final double targetBloodSugar = double.parse(_targetBloodSugarController.text);
    final double carbohydrates = double.parse(_carbohydratesController.text);

    // Simplified rules for calculation
    final double insulinSensitivity = 50;  // Assumed value
    final double carbToInsulinRatio = 10;  // Assumed value

    final double correctionDose = (currentBloodSugar - targetBloodSugar) / insulinSensitivity;
    final double mealDose = carbohydrates / carbToInsulinRatio;
    final double totalInsulinDose = correctionDose + mealDose;

    setState(() {
      _insulinDosageResult = totalInsulinDose.toStringAsFixed(1) + ' units';
      _advice = _getAdvice(totalInsulinDose);
    });
  }

  String _getAdvice(double insulinDose) {
    if (insulinDose < 4) {
      return 'Your insulin dosage is low. Monitor your blood sugar levels closely. Consider consulting your healthcare provider to ensure this dosage is correct for you.';
    } else if (insulinDose >= 4 && insulinDose <= 10) {
      return 'Your insulin dosage is moderate. Follow your prescribed regimen. Keep an eye on your blood sugar levels and adjust your diet and physical activity as needed.';
    } else {
      return 'Your insulin dosage is high. Follow your healthcare provider’s instructions carefully. Be vigilant about monitoring your blood sugar levels to avoid hypoglycemia.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Insulin Dosage Calculator'),
      ),
      body: Container(
        color: Color(0xFFE0F7FA),
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Text(
              'Enter the information below:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _currentBloodSugarController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Current Blood Sugar',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _targetBloodSugarController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Target Blood Sugar',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _carbohydratesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Carbs in Meal',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateInsulinDosage,
              child: Text('Calculate Dosage'),
            ),
            SizedBox(height: 20),
            Text(
              'Total Insulin Dosage: $_insulinDosageResult',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              _advice,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
