import 'package:flutter/material.dart';
import 'meal_plan_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DietPlansType1 extends StatefulWidget {
  @override
  _DietPlansType1State createState() => _DietPlansType1State();
}

class _DietPlansType1State extends State<DietPlansType1> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _a1cController = TextEditingController();
  final _avgBloodSugarController = TextEditingController();
  final _insulinDoseController = TextEditingController();
  String? _gender;
  String? _activityLevel;
  String? _exerciseRoutine;
  String? _mealTiming;
  String? _insulinRegimen;
  String? _dietaryGoal;
  String? _carbCountingKnowledge;
  String? _insulinDose;
  String? _carbIntake;
  String _mealPlan = '';
  String _foodsToCut = '';

  @override
  void initState() {
    super.initState();
    _loadMealPlan();
  }

  void _loadMealPlan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _mealPlan = prefs.getString('meal_plan') ?? '';
      _foodsToCut = prefs.getString('foods_to_cut') ?? '';
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Generate the meal plan
      String mealPlan = _generateMealPlan();
      String foodsToCut = _generateFoodsToCut();

      // Save the meal plan to shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('meal_plan', mealPlan);
      await prefs.setString('foods_to_cut', foodsToCut);

      setState(() {
        _mealPlan = mealPlan;
        _foodsToCut = foodsToCut;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MealPlanPage(mealPlan: mealPlan, foodsToCut: foodsToCut),
        ),
      );
    }
  }

  String _generateMealPlan() {
    // Example logic to generate a meal plan based on user's input
    // You can enhance this logic further based on more detailed criteria
    if (_dietaryGoal == 'Better Blood Sugar Control') {
      return '''
Monday:
Breakfast: 
- Scrambled eggs with spinach (2g carbs)
- Whole grain toast (15g carbs)
- Greek yogurt (10g carbs)
Lunch:
- Grilled chicken salad (10g carbs)
- Apple slices (15g carbs)
- Hummus with cucumber (10g carbs)
Dinner:
- Baked salmon with broccoli (8g carbs)
- Quinoa (20g carbs)
- Mixed berries (15g carbs)
... (continue for other days)
''';
    } else if (_dietaryGoal == 'Weight Management') {
      return '''
Monday:
Breakfast: 
- Smoothie with almond milk, spinach, and protein powder (10g carbs)
- Scrambled eggs with avocado (5g carbs)
Lunch:
- Quinoa salad with chickpeas and veggies (20g carbs)
- Greek yogurt (10g carbs)
Dinner:
- Grilled chicken with steamed veggies (10g carbs)
- Sweet potato (25g carbs)
... (continue for other days)
''';
    } else {
      return '''
Monday:
Breakfast: 
- Whole grain cereal with almond milk (25g carbs)
- Greek yogurt (10g carbs)
Lunch:
- Chicken salad with mixed greens (10g carbs)
- Apple slices (15g carbs)
Dinner:
- Grilled beef with broccoli (8g carbs)
- Quinoa (20g carbs)
... (continue for other days)
''';
    }
  }

  String _generateFoodsToCut() {
    return '''
Foods to Cut:
- Sugary beverages (soda, fruit juice)
- Refined grains (white bread, white rice)
- Trans fats (fried foods, baked goods)
- Processed snacks (chips, crackers)
- Sweets and desserts (cakes, cookies)
- High-fat dairy (whole milk, cream)
- Fatty cuts of meat (bacon, sausage)
- Packaged foods with added sugar
- Sweetened breakfast cereals
- High-sodium foods (canned soups, processed meats)
    ''';
  }

  void _showInsulinDoseInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Insulin Dose Information'),
        content: Text(
          'Insulin dose refers to the amount of insulin you take to manage your blood sugar levels. '
          'This can vary based on your meal content and timing. Consult your healthcare provider for accurate dosing.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showCarbCountingTip() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Carbohydrate Counting Tips'),
        content: Text(
          'Carbohydrate counting helps you manage your blood sugar levels by keeping track of the carbs you eat. '
          '1. Read food labels to know the carb content. '
          '2. Use a carb counting app or reference guide. '
          '3. Be mindful of portion sizes.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diabetes Type 1 Meal Plan'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Reset the meal plan
              setState(() {
                _mealPlan = '';
                _foodsToCut = '';
              });
            },
          ),
        ],
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
                controller: _weightController,                decoration: InputDecoration(labelText: 'Weight (kg)'),
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
                controller: _a1cController,
                decoration: InputDecoration(labelText: 'A1C (%)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your A1C';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _avgBloodSugarController,
                decoration: InputDecoration(labelText: 'Average Blood Sugar (mg/dL)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your average blood sugar';
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
                value: _activityLevel,
                decoration: InputDecoration(labelText: 'Activity Level'),
                items: [
                  'Sedentary',
                  'Lightly Active',
                  'Moderately Active',
                  'Very Active'
                ].map((label) => DropdownMenuItem(
                      child: Text(label),
                      value: label,
                    )).toList(),
                onChanged: (value) {
                  setState(() {
                    _activityLevel = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your activity level';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _exerciseRoutine,
                decoration: InputDecoration(labelText: 'Exercise Routine'),
                items: [
                  'No Exercise',
                  'Light Exercise (1-2 times/week)',
                  'Moderate Exercise (3-4 times/week)',
                  'Heavy Exercise (5+ times/week)'
                ].map((label) => DropdownMenuItem(
                      child: Text(label),
                      value: label,
                    )).toList(),
                onChanged: (value) {
                  setState(() {
                    _exerciseRoutine = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your exercise routine';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _insulinDoseController,
                      decoration: InputDecoration(labelText: 'Insulin Dose (units)'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your insulin dose';
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.help_outline),
                    onPressed: _showInsulinDoseInfo,
                  ),
                ],
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _carbCountingKnowledge,
                decoration: InputDecoration(labelText: 'Carbohydrate Counting Knowledge'),
                items: [
                  'Beginner',
                  'Intermediate',
                  'Expert'
                ].map((label) => DropdownMenuItem(
                      child: Text(label),
                      value: label,
                    )).toList(),
                onChanged: (value) {
                  setState(() {
                    _carbCountingKnowledge = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your carbohydrate counting knowledge level';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: _showCarbCountingTip,
                      child: Text('Carbohydrate Counting Tips'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _carbIntake,
                decoration: InputDecoration(labelText: 'Carbohydrate Intake (grams per meal)'),
                items: [
                  'I don\'t know',
                  'Less than 30 grams',
                  '30-50 grams',
                  '50-70 grams',
                  'More than 70 grams'
                ].map((label) => DropdownMenuItem(
                      child: Text(label),
                      value: label,
                    )).toList(),
                onChanged: (value) {
                  setState(() {
                    _carbIntake = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your carbohydrate intake';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _dietaryGoal,
                decoration: InputDecoration(labelText: 'Dietary Goal'),
                items: [
                  'Better Blood Sugar Control',
                  'Weight Management',
                  'General Health'
                ].map((label) => DropdownMenuItem(
                      child: Text(label),
                      value: label,
                    )).toList(),
                onChanged: (value) {
                  setState(() {
                    _dietaryGoal = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your dietary goal';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
              SizedBox(height: 20),
              if (_mealPlan.isNotEmpty && _foodsToCut.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Personalized Meal Plan:',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _mealPlan,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Foods to Cut:',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _foodsToCut,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}