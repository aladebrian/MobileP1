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

  // Function to add a recipe to a specific day
  void addRecipeToDay(String day, Recipe recipe) {
    setState(() {
      weeklyMeals[day]?.add(recipe);
    });
  }

  // Function to remove a recipe from a specific day
  void removeRecipeFromDay(String day, Recipe recipe) {
    setState(() {
      weeklyMeals[day]?.remove(recipe);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Planner'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Go back to Home Screen when back button is pressed
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // Calendar layout for each day of the week
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two columns for the days of the week
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 7,
              itemBuilder: (context, index) {
                String day =
                    [
                      'Monday',
                      'Tuesday',
                      'Wednesday',
                      'Thursday',
                      'Friday',
                      'Saturday',
                      'Sunday',
                    ][index];
                return GestureDetector(
                  onTap: () {
                    // Handle onTap to show more details or open recipe selection menu
                  },
                  child: DragTarget<Recipe>(
                    onAcceptWithDetails: (recipe) {
                      setState(() {
                        weeklyMeals[day]?.add(
                          recipe as Recipe,
                        ); // Add recipe to the respective day
                      });
                    },
                    builder: (context, candidateData, rejectedData) {
                      return Card(
                        color: Colors.blueAccent,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                day,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              ...weeklyMeals[day]!.map(
                                (recipe) => Stack(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        recipe.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      leading: Image(
                                        image: recipe.image,
                                      ), // Show recipe image
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.remove_circle,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          removeRecipeFromDay(
                                            day,
                                            recipe,
                                          ); // Remove recipe from the day
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (candidateData.isNotEmpty)
                                const Text(
                                  "Drop here!",
                                  style: TextStyle(color: Colors.red),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
