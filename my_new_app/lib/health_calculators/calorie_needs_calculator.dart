import 'package:flutter/material.dart';

class CalorieNeedsCalculator extends StatefulWidget {
  @override
  _CalorieNeedsCalculatorState createState() => _CalorieNeedsCalculatorState();
}

class _CalorieNeedsCalculatorState extends State<CalorieNeedsCalculator> {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  String _gender = 'Male';
  String _activityLevel = 'Sedentary';
  String _calorieNeedsResult = '';
  String _foodSuggestions = '';

  void _calculateCalorieNeeds() {
    final double weight = double.parse(_weightController.text);
    final double height = double.parse(_heightController.text);
    final int age = int.parse(_ageController.text);
    final double bmr;

    if (_gender == 'Male') {
      bmr = 10 * weight + 6.25 * height - 5 * age + 5;
    } else {
      bmr = 10 * weight + 6.25 * height - 5 * age - 161;
    }

    final double calorieNeeds = bmr * _getActivityMultiplier();

    setState(() {
      _calorieNeedsResult = calorieNeeds.toStringAsFixed(0);
      _foodSuggestions = _generateFoodSuggestions(calorieNeeds);
    });
  }

  double _getActivityMultiplier() {
    switch (_activityLevel) {
      case 'Sedentary':
        return 1.2;
      case 'Lightly active':
        return 1.375;
      case 'Moderately active':
        return 1.55;
      case 'Very active':
        return 1.725;
      case 'Extra active':
        return 1.9;
      default:
        return 1.2;
    }
  }

  String _generateFoodSuggestions(double calorieNeeds) {
    if (calorieNeeds < 1800) {
      return 'Your calorie needs are relatively low ($calorieNeeds calories). Consider eating:\n'
          '- Fruits and Vegetables:\n'
          '  - Apples (95 calories each), Bananas (105 calories each), Berries (85 calories per cup), Carrots (25 calories each), Spinach (7 calories per cup), Kale (33 calories per cup)\n'
          '- Lean Proteins:\n'
          '  - Chicken Breast (165 calories per 100g), Turkey (135 calories per 100g), Tofu (76 calories per 100g), Fish (206 calories per 100g for salmon), Eggs (78 calories each)\n'
          '- Whole Grains:\n'
          '  - Brown Rice (123 calories per 100g), Quinoa (120 calories per 100g), Whole Wheat Bread (80 calories per slice), Oats (154 calories per cup cooked)\n'
          '- Healthy Fats:\n'
          '  - Avocados (234 calories each), Nuts (160-200 calories per 30g), Seeds (150-170 calories per 30g), Olive Oil (119 calories per tablespoon)\n'
          '- Low-fat Dairy:\n'
          '  - Skim Milk (83 calories per cup), Low-fat Yogurt (154 calories per cup), Cottage Cheese (98 calories per 100g)\n'
          '- Legumes:\n'
          '  - Lentils (116 calories per 100g), Beans (127 calories per 100g), Chickpeas (164 calories per 100g)\n'
          '\nFocus on nutrient-dense foods to meet your nutritional needs without consuming too many calories.';
    } else if (calorieNeeds > 2500) {
      return 'Your calorie needs are relatively high ($calorieNeeds calories). Consider eating:\n'
          '- High-Calorie Fruits:\n'
          '  - Bananas (105 calories each), Avocados (234 calories each), Dried Fruits (Dates - 282 calories per 100g, Raisins - 299 calories per 100g, Apricots - 241 calories per 100g)\n'
          '- Lean Meats:\n'
          '  - Chicken (165 calories per 100g), Turkey (135 calories per 100g), Lean Beef (250 calories per 100g), Pork (242 calories per 100g)\n'
          '- Starchy Vegetables:\n'
          '  - Potatoes (77 calories per 100g), Sweet Potatoes (86 calories per 100g), Corn (96 calories per 100g), Peas (81 calories per 100g)\n'
          '- Whole Grains:\n'
          '  - Oatmeal (154 calories per cup cooked), Brown Rice (123 calories per 100g), Whole Wheat Pasta (124 calories per 100g), Barley (354 calories per 100g)\n'
          '- Nuts and Seeds:\n'
          '  - Almonds (160 calories per 30g), Walnuts (185 calories per 30g), Sunflower Seeds (164 calories per 30g), Peanut Butter (190 calories per 2 tablespoons)\n'
          '- Healthy Oils:\n'
          '  - Olive Oil (119 calories per tablespoon), Coconut Oil (117 calories per tablespoon), Flaxseed Oil (120 calories per tablespoon)\n'
          '- Dairy Products:\n'
          '  - Whole Milk (149 calories per cup), Cheese (113 calories per 30g), Full-fat Yogurt (149 calories per cup)\n'
          '- Protein-rich Snacks:\n'
          '  - Protein Bars (200-300 calories each), Greek Yogurt (100-150 calories per cup), Smoothies with Protein Powder (200-300 calories per serving)\n'
          '\nFocus on calorie-dense foods to ensure you are meeting your energy needs while maintaining a balanced diet.';
    } else {
      return 'Your calorie needs are moderate ($calorieNeeds calories). Consider eating a balanced diet that includes:\n'
          '- Fruits and Vegetables:\n'
          '  - Apples (95 calories each), Berries (85 calories per cup), Spinach (7 calories per cup), Kale (33 calories per cup), Carrots (25 calories each), Bell Peppers (24 calories each)\n'
          '- Lean Proteins:\n'
          '  - Chicken (165 calories per 100g), Fish (206 calories per 100g for salmon), Beans (127 calories per 100g), Lentils (116 calories per 100g), Eggs (78 calories each)\n'
          '- Whole Grains:\n'
          '  - Quinoa (120 calories per 100g), Brown Rice (123 calories per 100g), Oats (154 calories per cup cooked), Whole Wheat Bread (80 calories per slice)\n'
          '- Healthy Fats:\n'
          '  - Nuts (160-200 calories per 30g), Seeds (150-170 calories per 30g), Olive Oil (119 calories per tablespoon), Avocados (234 calories each)\n'
          '- Low-fat Dairy:\n'
          '  - Milk (83 calories per cup), Yogurt (154 calories per cup), Cheese (113 calories per 30g)\n'
          '- Plenty of Water\n'
          '- Occasional Treats:\n'
          '  - Dark Chocolate (155 calories per 30g), Smoothies (200-300 calories per serving), Homemade Baked Goods (200-300 calories each)\n'
          '\nMaintain a variety of foods in your diet to ensure you get all the essential nutrients.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calorie Needs Calculator'),
      ),
      body: Container(
        color: Color(0xFFE0F7FA),
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: [
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Age',
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
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Height (cm)',
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
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _activityLevel,
              items: <String>[
                'Sedentary',
                'Lightly active',
                'Moderately active',
                'Very active',
                'Extra active'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _activityLevel = newValue!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Activity Level',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateCalorieNeeds,
              child: Text('Calculate Calorie Needs'),
            ),
            SizedBox(height: 20),
            if (_calorieNeedsResult.isNotEmpty)
              Column(
                children: [
                  Text(
                    'Your daily calorie needs are:',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    _calorieNeedsResult,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Food Suggestions:',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    _foodSuggestions,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

