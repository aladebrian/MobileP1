import 'package:flutter/material.dart';
import 'recipes.dart';

class MealPlannerScreen extends StatefulWidget {
  final List<Recipe> cartRecipes;
  const MealPlannerScreen({super.key, required this.cartRecipes});

  @override
  State<MealPlannerScreen> createState() => _MealPlannerScreenState();
}

class _MealPlannerScreenState extends State<MealPlannerScreen> {
  Map<String, List<Recipe>> weeklyMeals = {
    'Monday': [],
    'Tuesday': [],
    'Wednesday': [],
    'Thursday': [],
    'Friday': [],
    'Saturday': [],
    'Sunday': [],
  };

  void addRecipeToDay(String day, Recipe recipe) {
    setState(() {
      weeklyMeals[day]?.add(recipe);
    });
  }

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
            Navigator.pop(context);
          },
        ),
      ),
      body: Row(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: widget.cartRecipes.length,
              itemBuilder: (context, index) {
                final recipe = widget.cartRecipes[index];
                return GestureDetector(
                  onTap: () {},
                  child: Draggable<Recipe>(
                    data: recipe,
                    feedback: Material(
                      color: Colors.transparent,
                      child: Container(
                        width: 100,
                        height: 100,
                        color: Colors.purpleAccent,
                        child: Center(
                          child: Text(
                            recipe.name,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    childWhenDragging: Container(),
                    child: Card(
                      color: Colors.deepPurple,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Image(image: recipe.image),
                            Text(
                              recipe.name,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
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

                return DragTarget<Recipe>(
                  onAcceptWithDetails: (recipe) {
                    addRecipeToDay(day, recipe as Recipe);
                  },
                  builder: (context, candidateData, rejectedData) {
                    return Card(
                      color: Colors.deepPurple,
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
                                    leading: Image(image: recipe.image),
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
                                        removeRecipeFromDay(day, recipe);
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
