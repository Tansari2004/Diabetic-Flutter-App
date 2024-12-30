import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'diet_plans_page.dart'; // Ensure this import is present

class MealPlanPage extends StatefulWidget {
  final String mealPlan;
  final String foodsToCut;

  MealPlanPage({required this.mealPlan, required this.foodsToCut});

  @override
  _MealPlanPageState createState() => _MealPlanPageState();
}

class _MealPlanPageState extends State<MealPlanPage> {
  late String mealPlan;
  late String foodsToCut;

  @override
  void initState() {
    super.initState();
    mealPlan = widget.mealPlan;
    foodsToCut = widget.foodsToCut;
  }

  void _refreshMealPlan() async {
    // Logic to refresh meal plan can be added here
    setState(() {
      mealPlan = 'New refreshed meal plan will be generated here...';
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('meal_plan', mealPlan);
    await prefs.setBool('showMealPlan', true);
  }

  void _clearMealPlan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showMealPlan', false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DietPlansPage()), // Use the correct class name
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Weekly Meal Plan'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshMealPlan,
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: _clearMealPlan,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Foods to Cut:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            SizedBox(height: 10),
            Text(
              foodsToCut,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Meal Plan:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            SizedBox(height: 10),
            Text(
              mealPlan,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
