import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_planner/recipe_model.dart';
import 'package:recipe_planner/recipes.dart';

class MealPlannerScreen extends StatefulWidget {
  const MealPlannerScreen({super.key});

  @override
  State<MealPlannerScreen> createState() => _MealPlannerScreenState();
}

class _MealPlannerScreenState extends State<MealPlannerScreen> {
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
              itemCount: context.watch<RecipeModel>().cart.length,
              itemBuilder: (context, index) {
                final recipe =
                    context.watch<RecipeModel>().cart.toList()[index];
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
                  onAcceptWithDetails: (details) {
                    context.read<RecipeModel>().addRecipeToDay(
                      day,
                      details.data,
                    );
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
                            Expanded(
                              child: ListView.builder(
                                itemCount:
                                    context
                                        .watch<RecipeModel>()
                                        .weeklyMeals[day]
                                        ?.length ??
                                    0,
                                itemBuilder: (context, recipeIndex) {
                                  final recipe =
                                      context
                                          .watch<RecipeModel>()
                                          .weeklyMeals[day]![recipeIndex];
                                  return Stack(
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
                                            // Call the method from RecipeModel
                                            context
                                                .read<RecipeModel>()
                                                .removeRecipeFromDay(
                                                  day,
                                                  recipe,
                                                );
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                },
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
