import 'package:flutter/material.dart';

class InsulinResistanceCalculator extends StatefulWidget {
  @override
  _InsulinResistanceCalculatorState createState() => _InsulinResistanceCalculatorState();
}

class _InsulinResistanceCalculatorState extends State<InsulinResistanceCalculator> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _waistCircumferenceController = TextEditingController();
  String? _gender;
  String? _physicalActivityLevel;
  String? _dietQuality;
  String? _familyHistory;

  void _calculateInsulinResistance() {
    if (_formKey.currentState!.validate()) {
      double score = 0;

      // Calculate the score based on the answers
      score += (_gender == 'Male' ? 2 : 1);
      score += double.tryParse(_ageController.text) ?? 0;
      score += double.tryParse(_weightController.text) ?? 0;
      score += double.tryParse(_heightController.text) ?? 0;
      score += double.tryParse(_waistCircumferenceController.text) ?? 0;
      score += (_physicalActivityLevel == 'Low' ? 3 : _physicalActivityLevel == 'Medium' ? 2 : 1);
      score += (_dietQuality == 'Poor' ? 3 : _dietQuality == 'Average' ? 2 : 1);
      score += (_familyHistory == 'Yes' ? 2 : 1);

      String result = 'Low risk of insulin resistance';
      if (score > 15) {
        result = 'High risk of insulin resistance';
      } else if (score > 10) {
        result = 'Moderate risk of insulin resistance';
      }

      // Show the result
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Insulin Resistance Risk'),
          content: Text(result),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Insulin Resistance Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your weight';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _heightController,
                decoration: InputDecoration(labelText: 'Height (cm)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your height';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _waistCircumferenceController,
                decoration: InputDecoration(labelText: 'Waist Circumference (cm)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your waist circumference';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: InputDecoration(labelText: 'Gender'),
                items: ['Male', 'Female', 'Other']
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _gender = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your gender';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _physicalActivityLevel,
                decoration: InputDecoration(labelText: 'Physical Activity Level'),
                items: [
                  'Low',
                  'Medium',
                  'High'
                ].map((label) => DropdownMenuItem(
                      child: Text(label),
                      value: label,
                    )).toList(),
                onChanged: (value) {
                  setState(() {
                    _physicalActivityLevel = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your physical activity level';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _dietQuality,
                decoration: InputDecoration(labelText: 'Diet Quality'),
                items: [
                  'Poor',
                  'Average',
                  'Good'
                ].map((label) => DropdownMenuItem(
                      child: Text(label),
                      value: label,
                    )).toList(),
                onChanged: (value) {
                  setState(() {
                    _dietQuality = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your diet quality';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _familyHistory,
                decoration: InputDecoration(labelText: 'Family History of Diabetes'),
                items: [
                  'Yes',
                  'No'
                ].map((label) => DropdownMenuItem(
                      child: Text(label),
                      value: label,
                    )).toList(),
                onChanged: (value) {
                  setState(() {
                    _familyHistory = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select if you have a family history of diabetes';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calculateInsulinResistance,
                child: Text('Calculate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
