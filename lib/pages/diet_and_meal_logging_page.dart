import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FoodItem {
  final String name;
  final double carbs;
  final double sugars;
  final double fiber;
  final double proteins;
  final double fats;
  final double sodium;
  final double cholesterol;
  final double calories;

  FoodItem({
    required this.name,
    required this.carbs,
    required this.sugars,
    required this.fiber,
    required this.proteins,
    required this.fats,
    required this.sodium,
    required this.cholesterol,
    required this.calories,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      name: json['name'],
      carbs: (json['carbs'] as num).toDouble(),
      sugars: (json['sugars'] as num).toDouble(),
      fiber: (json['fiber'] as num).toDouble(),
      proteins: (json['proteins'] as num).toDouble(),
      fats: (json['fats'] as num).toDouble(),
      sodium: (json['sodium'] as num).toDouble(),
      cholesterol: (json['cholesterol'] as num).toDouble(),
      calories: (json['calories'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'carbs': carbs,
      'sugars': sugars,
      'fiber': fiber,
      'proteins': proteins,
      'fats': fats,
      'sodium': sodium,
      'cholesterol': cholesterol,
      'calories': calories,
    };
  }
}

class DietAndMealLoggingPage extends StatefulWidget {
  @override
  _DietAndMealLoggingPageState createState() => _DietAndMealLoggingPageState();
}

class _DietAndMealLoggingPageState extends State<DietAndMealLoggingPage> {
  final TextEditingController _foodNameController = TextEditingController();
  final TextEditingController _foodWeightController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<FoodItem> _entries = [];
  double totalCarbs = 0;
  double totalSugars = 0;
  double totalFiber = 0;
  double totalProteins = 0;
  double totalFats = 0;
  double totalSodium = 0;
  double totalCholesterol = 0;
  double totalCalories = 0;

  String? _diabetesType;
  int? _age;
  double? _weight;
  double? _height;
  String? _gender;
  String? _activityLevel;

  double dailyCarbs = 300;
  double dailySugars = 50;
  double dailyFiber = 30;
  double dailyProteins = 56;
  double dailyFats = 70;
  double dailySodium = 2300;
  double dailyCholesterol = 300;
  double dailyCalories = 2000;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  void _loadEntries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? entriesString = prefs.getString('food_entries');
    if (entriesString != null) {
      List<dynamic> entriesJson = jsonDecode(entriesString);
      setState(() {
        _entries = entriesJson.map((e) => FoodItem.fromJson(e)).toList();
      });
      _calculateTotals();
    }
  }

  void _saveEntries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('food_entries', jsonEncode(_entries));
  }

  Future<FoodItem> _fetchFoodData(String foodName) async {
    final response = await http.get(Uri.parse('https://api.nal.usda.gov/fdc/v1/foods/search?query=$foodName&api_key=DoZISLoamcumFpqaESr9BSB5Z5SMVMTh32cvo9Vq'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['foods'].isEmpty) {
        throw Exception('No food data found');
      }

      final foodNutrients = data['foods'][0]['foodNutrients'];

      double carbs = 0, sugars = 0, fiber = 0, proteins = 0, fats = 0, sodium = 0, cholesterol = 0, calories = 0;
      for (var nutrient in foodNutrients) {
        switch (nutrient['nutrientName']) {
          case 'Carbohydrate, by difference':
            carbs = (nutrient['value'] as num).toDouble();
            break;
          case 'Sugars, total including NLEA':
            sugars = (nutrient['value'] as num).toDouble();
            break;
          case 'Fiber, total dietary':
            fiber = (nutrient['value'] as num).toDouble();
            break;
          case 'Protein':
            proteins = (nutrient['value'] as num).toDouble();
            break;
          case 'Total lipid (fat)':
            fats = (nutrient['value'] as num).toDouble();
            break;
          case 'Sodium, Na':
            sodium = (nutrient['value'] as num).toDouble();
            break;
          case 'Cholesterol':
            cholesterol = (nutrient['value'] as num).toDouble();
            break;
          case 'Energy':
            calories = (nutrient['value'] as num).toDouble();
            break;
          default:
            break;
        }
      }

      return FoodItem(
        name: foodName,
        carbs: carbs,
        sugars: sugars,
        fiber: fiber,
        proteins: proteins,
        fats: fats,
        sodium: sodium,
        cholesterol: cholesterol,
        calories: calories,
      );
    } else {
      throw Exception('Failed to fetch food data');
    }
  }

  void _addEntry() async {
    final String foodName = _foodNameController.text.trim();
    final double? foodWeight = double.tryParse(_foodWeightController.text);
    if (foodWeight == null || foodWeight <= 0) {
      // Show error if the food weight is not valid
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid food weight.')),
      );
      return;
    }

    try {
      final FoodItem foodItem = await _fetchFoodData(foodName);
      final double factor = foodWeight / 100.0;

      setState(() {
        _entries.add(FoodItem(
          name: foodItem.name,
          carbs: foodItem.carbs * factor,
          sugars: foodItem.sugars * factor,
          fiber: foodItem.fiber * factor,
          proteins: foodItem.proteins * factor,
          fats: foodItem.fats * factor,
          sodium: foodItem.sodium * factor,
          cholesterol: foodItem.cholesterol * factor,
          calories: foodItem.calories * factor,
        ));
        _foodNameController.clear();
        _foodWeightController.clear();
      });
      _calculateTotals();
      _saveEntries();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch food data. Please try again later.')),
      );
    }
  }

  void _removeEntry(int index) {
    setState(() {
      _entries.removeAt(index);
    });
    _calculateTotals();
    _saveEntries();
  }

  void _calculateTotals() {
    totalCarbs = 0;
    totalSugars = 0;
    totalFiber = 0;
    totalProteins = 0;
    totalFats = 0;
    totalSodium = 0;
    totalCholesterol = 0;
    totalCalories = 0;

    for (final entry in _entries) {
      totalCarbs += entry.carbs;
      totalSugars += entry.sugars;
      totalFiber += entry.fiber;
      totalProteins += entry.proteins;
      totalFats += entry.fats;
      totalSodium += entry.sodium;
      totalCholesterol += entry.cholesterol;
      totalCalories += entry.calories;
    }
  }

  void _submitQuiz() {
    setState(() {
      dailyCarbs = _calculateDailyCarbs();
      dailySugars = _calculateDailySugars();
      dailyFiber = _calculateDailyFiber();
      dailyProteins = _calculateDailyProteins();
      dailyFats = _calculateDailyFats();
      dailySodium = _calculateDailySodium();
      dailyCholesterol = _calculateDailyCholesterol();
      dailyCalories = _calculateDailyCalories();
    });
  }

  double _calculateDailyCarbs() {
    if (_diabetesType == 'Type 1') {
      return (_weight! * 3);
    } else {
      return (_weight! * 2.5);
    }
  }

  double _calculateDailySugars() {
    if (_diabetesType == 'Type 1') {
      return 45;
    } else {
      return 50;
    }
  }

  double _calculateDailyFiber() {
    return 30;
  }
    double _calculateDailyProteins() {
    return (_weight! * 0.8);
  }

  double _calculateDailyFats() {
    return (_weight! * 0.35);
  }

  double _calculateDailySodium() {
    return 2300;
  }

  double _calculateDailyCholesterol() {
    return 300;
  }

  double _calculateDailyCalories() {
    if (_activityLevel == 'Sedentary') {
      return (_weight! * 24);
    } else if (_activityLevel == 'Lightly Active') {
      return (_weight! * 26);
    } else if (_activityLevel == 'Moderately Active') {
      return (_weight! * 28);
    } else {
      return (_weight! * 30);
    }
  }

  Widget _buildQuiz() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            value: _diabetesType,
            decoration: InputDecoration(
              labelText: 'Diabetes Type',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            items: ['Type 1', 'Type 2'].map((label) => DropdownMenuItem(
              child: Text(label),
              value: label,
            )).toList(),
            onChanged: (value) {
              setState(() {
                _diabetesType = value;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Please select your diabetes type';
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Age',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              _age = int.tryParse(value);
            },
            validator: (value) {
              if (value == null || int.tryParse(value) == null) {
                return 'Please enter a valid age';
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Weight (kg)',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              _weight = double.tryParse(value);
            },
            validator: (value) {
              if (value == null || double.tryParse(value) == null) {
                return 'Please enter a valid weight';
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Height (cm)',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              _height = double.tryParse(value);
            },
            validator: (value) {
              if (value == null || double.tryParse(value) == null) {
                return 'Please enter a valid height';
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _gender,
            decoration: InputDecoration(
              labelText: 'Gender',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            items: ['Male', 'Female'].map((label) => DropdownMenuItem(
              child: Text(label),
              value: label,
            )).toList(),
            onChanged: (value) {
              setState(() {
                _gender = value;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Please select your gender';
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _activityLevel,
            decoration: InputDecoration(
              labelText: 'Activity Level',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            items: ['Sedentary', 'Lightly Active', 'Moderately Active', 'Very Active'].map((label) => DropdownMenuItem(
              child: Text(label),
              value: label,
            )).toList(),
            onChanged: (value) {
              setState(() {
                _activityLevel = value;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Please select your activity level';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _submitQuiz();
              }
            },
            child: Text('Submit'),
            style: ElevatedButton.styleFrom(
              primary: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientRow(String nutrient, double total, double daily) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(nutrient, style: TextStyle(fontSize: 16, color: Colors.deepPurple)),
        Text('${total.toStringAsFixed(1)} / ${daily.toStringAsFixed(1)}', style: TextStyle(fontSize: 16, color: Colors.deepPurple)),
      ],
    );
  }

  void _restartLogging() {
    setState(() {
      _entries.clear();
    });
    _calculateTotals();
    _saveEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diet and Meal Logging'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _restartLogging,
          ),
        ],
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xFFF3E5F5),
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nutrition Goals Quiz',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
              ),
              SizedBox(height: 20),
              _buildQuiz(),
              SizedBox(height: 20),
              TextField(
                controller: _foodNameController,
                decoration: InputDecoration(
                  labelText: 'Food Name',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _foodWeightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Weight (g)',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _addEntry,
                child: Text('Add Entry'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Daily Nutritional Summary',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
              ),
              Divider(color: Colors.deepPurple),
              _buildNutrientRow('Carbohydrates', totalCarbs, dailyCarbs),
              _buildNutrientRow('Sugars', totalSugars, dailySugars),
              _buildNutrientRow('Fiber', totalFiber, dailyFiber),
              _buildNutrientRow('Proteins', totalProteins, dailyProteins),
              _buildNutrientRow('Fats', totalFats, dailyFats),
              _buildNutrientRow('Sodium', totalSodium, dailySodium),
              _buildNutrientRow('Cholesterol', totalCholesterol, dailyCholesterol),
              _buildNutrientRow('Calories', totalCalories, dailyCalories),
              Divider(color: Colors.deepPurple),
              Text(
                'Meal Entries',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _entries.length,
                itemBuilder: (context, index) {
                  final entry = _entries[index];
                  return ListTile(
                    title: Text(entry.name, style: TextStyle(color: Colors.deepPurple)),
                    subtitle: Text(
                                            'Carbs: ${entry.carbs.toStringAsFixed(1)}g, Sugars: ${entry.sugars.toStringAsFixed(1)}g, Fiber: ${entry.fiber.toStringAsFixed(1)}g, Proteins: ${entry.proteins.toStringAsFixed(1)}g, Fats: ${entry.fats.toStringAsFixed(1)}g, Sodium: ${entry.sodium.toStringAsFixed(1)}mg, Cholesterol: ${entry.cholesterol.toStringAsFixed(1)}mg, Calories: ${entry.calories.toStringAsFixed(1)}kcal',
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeEntry(index),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DietAndMealLoggingPage(),
  ));
}

 