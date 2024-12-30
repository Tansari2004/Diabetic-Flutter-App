import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'diet_plans_type1.dart';
import 'diet_plans_type2.dart';
import 'meal_plan_page.dart';

class DietPlansPage extends StatefulWidget {
  @override
  _DietPlansPageState createState() => _DietPlansPageState();
}

class _DietPlansPageState extends State<DietPlansPage> {
  bool _showMealPlan = false;
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
      _showMealPlan = prefs.getBool('showMealPlan') ?? false;
      _mealPlan = prefs.getString('meal_plan') ?? '';
      _foodsToCut = prefs.getString('foods_to_cut') ?? '';
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diet Plans'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DietPlansType1()),
                  );
                },
                child: Text(
                  'Diabetes Type 1',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DietPlansType2()),
                  );
                },
                child: Text(
                  'Diabetes Type 2',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}





