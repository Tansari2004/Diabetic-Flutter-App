import 'package:flutter/material.dart';

class A1CEstimator extends StatefulWidget {
  @override
  _A1CEstimatorState createState() => _A1CEstimatorState();
}

class _A1CEstimatorState extends State<A1CEstimator> {
  final TextEditingController _averageBloodSugarController = TextEditingController();
  String _a1cResult = '';
  String _a1cDefinition = '';
  String _advice = '';

  void _estimateA1C() {
    final double averageBloodSugar = double.parse(_averageBloodSugarController.text);
    // A1C estimation formula: (average blood glucose + 46.7) / 28.7
    final double a1c = (averageBloodSugar + 46.7) / 28.7;

    setState(() {
      _a1cResult = a1c.toStringAsFixed(1) + ' %';
      _a1cDefinition = _getA1CDefinition(a1c);
      _advice = _getAdvice(a1c);
    });
  }

  String _getA1CDefinition(double a1c) {
    if (a1c < 5.7) {
      return 'Normal: An A1C below 5.7% is considered normal.';
    } else if (a1c >= 5.7 && a1c < 6.5) {
      return 'Prediabetes: An A1C between 5.7% and 6.4% is considered prediabetes.';
    } else {
      return 'Diabetes: An A1C of 6.5% or higher is indicative of diabetes.';
    }
  }

  String _getAdvice(double a1c) {
    if (a1c < 5.7) {
      return 'Maintain a healthy lifestyle with a balanced diet and regular exercise to keep your A1C level within the normal range.';
    } else if (a1c >= 5.7 && a1c < 6.5) {
      return 'Consider making lifestyle changes such as improving your diet, increasing physical activity, and monitoring your blood sugar levels regularly. Consult with a healthcare provider for personalized advice.';
    } else {
      return 'It is important to take steps to manage your diabetes. This includes following a healthy diet, engaging in regular exercise, monitoring your blood sugar levels, and possibly taking medication as prescribed by your healthcare provider. Regular check-ups with your healthcare provider are essential.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('A1C Estimator'),
      ),
      body: Container(
        color: Color(0xFFE0F7FA),
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Text(
              'Please enter your average blood sugar level over the past 2-3 months to estimate your A1C level.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _averageBloodSugarController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Average Blood Sugar (mg/dL)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _estimateA1C,
              child: Text('Estimate A1C'),
            ),
            SizedBox(height: 20),
            Text(
              'Estimated A1C: $_a1cResult',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              _a1cDefinition,
              style: TextStyle(fontSize: 18),
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

