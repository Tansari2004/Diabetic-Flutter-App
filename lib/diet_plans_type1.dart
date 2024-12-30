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
  String? _dietaryGoal;
  String? _carbCountingKnowledge;
  String? _carbIntake;
  String? _medication;
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
    String mealPlan = '';

    if (_dietaryGoal == 'Better Blood Sugar Control') {
      if (_activityLevel == 'Sedentary') {
        mealPlan = _bloodSugarControlSedentaryPlan();
      } else if (_activityLevel == 'Lightly Active') {
        mealPlan = _bloodSugarControlLightlyActivePlan();
      } else if (_activityLevel == 'Moderately Active') {
        mealPlan = _bloodSugarControlModeratelyActivePlan();
      } else if (_activityLevel == 'Very Active') {
        mealPlan = _bloodSugarControlVeryActivePlan();
      }
    } else if (_dietaryGoal == 'Weight Management') {
      if (_activityLevel == 'Sedentary') {
        mealPlan = _weightManagementSedentaryPlan();
      } else if (_activityLevel == 'Lightly Active') {
        mealPlan = _weightManagementLightlyActivePlan();
      } else if (_activityLevel == 'Moderately Active') {
        mealPlan = _weightManagementModeratelyActivePlan();
      } else if (_activityLevel == 'Very Active') {
        mealPlan = _weightManagementVeryActivePlan();
      }
    } else if (_dietaryGoal == 'General Health') {
      if (_activityLevel == 'Sedentary') {
        mealPlan = _generalHealthSedentaryPlan();
      } else if (_activityLevel == 'Lightly Active') {
        mealPlan = _generalHealthLightlyActivePlan();
      } else if (_activityLevel == 'Moderately Active') {
        mealPlan = _generalHealthModeratelyActivePlan();
      } else if (_activityLevel == 'Very Active') {
        mealPlan = _generalHealthVeryActivePlan();
      }
    }

    // Adjust the meal plan slightly based on the selected medication
    if (_medication == 'Insulin') {
      mealPlan += '''
Additional Snacks:
- 1 small apple (15g carbs) mid-morning
- 1 Greek yogurt (10g carbs) mid-afternoon
''';
    } else if (_medication == 'Metformin') {
      mealPlan += '''
Additional Snacks:
- 1 handful of almonds (5g carbs) mid-morning
- 1 small orange (15g carbs) mid-afternoon
''';
    }

    return mealPlan;
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

  // Example meal plans for different scenarios
  String _bloodSugarControlSedentaryPlan() {
    return '''
Monday:
Breakfast: 
1. Scrambled eggs with spinach (2g carbs)
2. Whole grain toast (15g carbs)
Lunch:
1. Grilled chicken salad (10g carbs)
2. Apple slices (15g carbs)
Dinner:
1. Baked salmon with broccoli (8g carbs)
2. Quinoa (20g carbs)

Tuesday:
Breakfast: 
1. Oatmeal with berries (25g carbs)
2. Hard-boiled eggs (1g carbs)
Lunch:
1. Turkey and avocado wrap (20g carbs)
2. Carrot sticks (10g carbs)
Dinner:
1. Stir-fried tofu with vegetables (12g carbs)
2. Brown rice (30g carbs)
''';
  }

  String _bloodSugarControlLightlyActivePlan() {
    return '''
Monday:
Breakfast: 
1. Greek yogurt with berries (15g carbs)
2. Whole grain toast (15g carbs)
Lunch:
1. Tuna salad (5g carbs)
2. Crackers (20g carbs)
Dinner:
1. Grilled shrimp with asparagus (8g carbs)
2. Mashed sweet potatoes (25g carbs)

Tuesday:
Breakfast: 
1. Smoothie with spinach, banana, and almond milk (20g carbs)
2. Whole grain cereal (25g carbs)
Lunch:
1. Chicken Caesar salad (10g carbs)
2. Apple (15g carbs)
Dinner:
1. Beef stir-fry with vegetables (15g carbs)
2. Cauliflower rice (5g carbs)
''';
  }

  String _bloodSugarControlModeratelyActivePlan() {
    return '''
Monday:
Breakfast: 
1. Yogurt parfait with granola (30g carbs)
2. Boiled eggs (1g carbs)
Lunch:
1. Ham and cheese sandwich on whole grain bread (25g carbs)
2. Baby carrots (10g carbs)
Dinner:
1. Baked chicken with green beans (8g carbs)
2. Lentil soup (25g carbs)

Tuesday:
Breakfast: 
1. Pancakes with sugar-free syrup (20g carbs)
2. Turkey bacon (1g carbs)
Lunch:
1. Spinach and feta wrap (20g carbs)
2. Celery sticks with peanut butter (8g carbs)
Dinner:
1. Pork chops with sautéed spinach (5g carbs)
2. Wild rice (25g carbs)
''';
  }

  String _bloodSugarControlVeryActivePlan() {
    return '''
Monday:
Breakfast: 
1. Omelet with veggies (5g carbs)
2. Whole grain muffin (20g carbs)
Lunch:
1. Chicken and vegetable soup (15g carbs)
2. Whole grain crackers (20g carbs)
Dinner:
1. Grilled fish with roasted Brussels sprouts (10g carbs)
2. Brown rice (30g carbs)

Tuesday:
Breakfast: 
1. Whole grain toast with peanut butter (20g carbs)
2. Mixed nuts (5g carbs)
Lunch:
1. Turkey and avocado wrap (20g carbs)
2. Carrot sticks (10g carbs)
Dinner:
1. Stir-fried tofu with vegetables (12g carbs)
2. Brown rice (30g carbs)
''';
  }

  String _weightManagementSedentaryPlan() {
    return '''
Monday:
Breakfast: 
1. Smoothie with almond milk, spinach, and protein powder (10g carbs)
2. Scrambled eggs with avocado (5g carbs)
Lunch:
1Lunch:
1. Quinoa salad with chickpeas and veggies (20g carbs)
2. Greek yogurt (10g carbs)
Dinner:
1. Grilled chicken with steamed veggies (10g carbs)
2. Sweet potato (25g carbs)

Tuesday:
Breakfast: 
1. Chia pudding with berries (15g carbs)
2. Boiled eggs (1g carbs)
Lunch:
1. Turkey lettuce wraps (15g carbs)
2. Mixed nuts (5g carbs)
Dinner:
1. Baked salmon with asparagus (8g carbs)
2. Brown rice (30g carbs)
''';
  }

  String _weightManagementLightlyActivePlan() {
    return '''
Monday:
Breakfast: 
1. Whole grain toast with avocado (15g carbs)
2. Cottage cheese (8g carbs)
Lunch:
1. Spinach and feta salad (10g carbs)
2. Apple slices (15g carbs)
Dinner:
1. Grilled shrimp with broccoli (8g carbs)
2. Lentil soup (20g carbs)

Tuesday:
Breakfast: 
1. Oatmeal with nuts and seeds (20g carbs)
2. Greek yogurt (10g carbs)
Lunch:
1. Tuna salad with cucumber slices (5g carbs)
2. Pear slices (15g carbs)
Dinner:
1. Chicken stir-fry with veggies (10g carbs)
2. Quinoa (20g carbs)
''';
  }

  String _weightManagementModeratelyActivePlan() {
    return '''
Monday:
Breakfast: 
1. Smoothie with kale, banana, and almond milk (20g carbs)
2. Hard-boiled eggs (1g carbs)
Lunch:
1. Chickpea and veggie salad (20g carbs)
2. Cottage cheese (8g carbs)
Dinner:
1. Baked tofu with roasted veggies (12g carbs)
2. Wild rice (25g carbs)

Tuesday:
Breakfast: 
1. Greek yogurt with mixed berries (15g carbs)
2. Scrambled eggs with spinach (2g carbs)
Lunch:
1. Turkey and cheese wrap in lettuce (10g carbs)
2. Carrot sticks (10g carbs)
Dinner:
1. Grilled pork with green beans (10g carbs)
2. Mashed sweet potatoes (25g carbs)
''';
  }

  String _weightManagementVeryActivePlan() {
    return '''
Monday:
Breakfast: 
1. Whole grain toast with peanut butter (20g carbs)
2. Mixed nuts (5g carbs)
Lunch:
1. Caesar salad with chicken (10g carbs)
2. Orange slices (15g carbs)
Dinner:
1. Baked fish with Brussels sprouts (10g carbs)
2. Brown rice (30g carbs)

Tuesday:
Breakfast: 
1. Whole grain cereal with almond milk (25g carbs)
2. Greek yogurt (10g carbs)
Lunch:
1. Chicken salad with mixed greens (10g carbs)
2. Apple slices (15g carbs)
Dinner:
1. Grilled beef with broccoli (8g carbs)
2. Quinoa (20g carbs)
''';
  }

  String _generalHealthSedentaryPlan() {
    return '''
Monday:
Breakfast: 
1. Oatmeal with nuts and berries (25g carbs)
2. Boiled eggs (1g carbs)
Lunch:
1. Tuna wrap with whole grain tortilla (20g carbs)
2. Carrot sticks (10g carbs)
Dinner:
1. Baked chicken with green beans (10g carbs)
2. Brown rice (30g carbs)

Tuesday:
Breakfast: 
1. Smoothie with spinach, banana, and almond milk (20g carbs)
2. Whole grain toast (15g carbs)
Lunch:
1. Turkey and avocado salad (10g carbs)
2. Orange slices (12g carbs)
Dinner:
1. Grilled shrimp with cauliflower rice (8g carbs)
2. Lentil soup (20g carbs)
''';
  }

  String _generalHealthLightlyActivePlan() {
    return '''
Monday:
Breakfast: 
1. Whole grain toast with peanut butter (20g carbs)
2. Mixed nuts (5g carbs)
Lunch:
1. Chicken Caesar salad (10g carbs)
2. Pear slices (15g carbs)
Dinner:
1. Beef stir-fry with veggies (15g carbs)
2. Wild rice (25g carbs)

Tuesday:
Breakfast: 
1. Yogurt parfait with granola (30g carbs)
2. Scrambled eggs (1g carbs)
Lunch:
1. Ham and cheese sandwich on whole grain bread (25g carbs)
2. Celery sticks (5g carbs)
Dinner:
1. Baked chicken with broccoli (8g carbs)
2. Quinoa (20g carbs)
''';
  }

  String _generalHealthModeratelyActivePlan() {
    return '''
Monday:
Breakfast: 
1. Pancakes with sugar-free syrup (20g carbs)
2. Turkey bacon (1g carbs)
Lunch:
1. Spinach and feta wrap (20g carbs)
2. Cucumber slices (5g carbs)
Dinner:
1. Pork chops with sautéed spinach (5g carbs)
2. Sweet potato (25g carbs)

Tuesday:
Breakfast: 
1. Omelet with veggies (5g carbs)
2. Whole grain muffin (20g carbs)
Lunch:
1. Chicken and veggie soup (15g carbs)
2. Whole grain crackers (20g carbs)
Dinner:
1. Grilled fish with roasted Brussels sprouts (10g carbs)
2. Brown rice (30g carbs)
''';
  }

  String _generalHealthVeryActivePlan() {
    return '''
Monday:
Breakfast: 
1. Whole grain toast with almond butter (20g carbs)
2. Greek yogurt (10g carbs)
Lunch:
1. Grilled chicken with quinoa salad (15g carbs)
2. Carrot sticks (10g carbs)
Dinner:
1. Beef stew with vegetables (12g carbs)
2. Brown rice (30g carbs)

Tuesday:
Breakfast: 
1. Smoothie with spinach, kale, and protein powder (15g carbs)
2. Boiled eggs (1g carbs)
Lunch:
1. Tuna salad with avocado (10g carbs)
2. Whole grain crackers (20g carbs)
Dinner:
1. Baked salmon with asparagus (8g carbs)
2. Mashed sweet potatoes (25g carbs)
''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diabetes Type 1 Meal Plan'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('meal_plan');
              await prefs.remove('foods_to_cut');
              setState(() {
                _ageController.clear();
                _weightController.clear();
                _heightController.clear();
                _a1cController.clear();
                _avgBloodSugarController.clear();
                _insulinDoseController.clear();
                _gender = null;
                _activityLevel = null;
                _exerciseRoutine = null;
                _dietaryGoal = null;
                _carbCountingKnowledge = null;
                _carbIntake = null;
                _medication = null;
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
              TextFormField(
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
                    ))
                    .toList(),
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
                    ))
                    .toList(),
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
              DropdownButtonFormField<String>(
                value: _medication,
                decoration: InputDecoration(labelText: 'Medications'),
                items: [
                  'None',
                  'Insulin',
                  'Metformin'
                ].map((label) => DropdownMenuItem(
                      child: Text(label),
                      value: label,
                    ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _medication = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your medications';
                  }
                  return null;
                },
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
                    ))
                    .toList(),
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
                    ))
                    .toList(),
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
                    ))
                    .toList(),
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