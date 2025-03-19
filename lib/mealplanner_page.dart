import 'package:flutter/material.dart';
import 'recipes.dart'; // Importing the Recipe class from recipes.dart

class MealPlannerScreen extends StatefulWidget {
  final List<Recipe> cartRecipes; // Pass the selected recipes from Home Screen
  const MealPlannerScreen({super.key, required this.cartRecipes});

  @override
  State<MealPlannerScreen> createState() => _MealPlannerScreenState();
}

class _MealPlannerScreenState extends State<MealPlannerScreen> {
  // This will store recipes for each day of the week
  Map<String, List<Recipe>> weeklyMeals = {
    'Monday': [],
    'Tuesday': [],
    'Wednesday': [],
    'Thursday': [],
    'Friday': [],
    'Saturday': [],
    'Sunday': [],
  };

  // Function to add recipe to a specific day
  void addRecipeToDay(String day, Recipe recipe) {
    setState(() {
      weeklyMeals[day]?.add(recipe);
    });
  }

  // Function to remove recipe from a specific day
  void removeRecipeFromDay(String day, Recipe recipe) {
    setState(() {
      weeklyMeals[day]?.remove(recipe);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Placeholder();
  }
}
