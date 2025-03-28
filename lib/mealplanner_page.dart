import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_planner/recipe_model.dart';
import 'package:recipe_planner/recipes.dart';

class MealPlannerScreen extends StatelessWidget {
  const MealPlannerScreen({super.key});
  static const List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meal Planner')),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                    itemCount: context.watch<RecipeModel>().cart.length,
                    itemBuilder: (context, index) {
                      final recipe =
                          context.watch<RecipeModel>().cart.toList()[index];
                      return MealPlannerTile(recipe: recipe);
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GroceryListScreen(),
                        ),
                      ),
                  child: Text("View your grocery list!"),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: days.length,
              itemBuilder: (context, index) {
                String day = days[index];
                return DayTile(day: day);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MealPlannerTile extends StatelessWidget {
  const MealPlannerTile({super.key, required this.recipe});
  final Recipe recipe;
  @override
  Widget build(BuildContext context) {
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
            child: Image(image: recipe.image),
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
                Text(recipe.name, style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DayTile extends StatelessWidget {
  const DayTile({super.key, required this.day});
  final String day;
  @override
  Widget build(BuildContext context) {
    return DragTarget<Recipe>(
      onAcceptWithDetails: (details) {
        context.read<RecipeModel>().addRecipeToDay(day, details.data);
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
                        context.watch<RecipeModel>().weeklyMeals[day]?.length ??
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
                              style: const TextStyle(color: Colors.white),
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
                                context.read<RecipeModel>().removeRecipeFromDay(
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
                  const Text("Drop here!", style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class GroceryListScreen extends StatelessWidget {
  const GroceryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text("Groceries"),
          ...context.read<RecipeModel>().groceries.map(
            (ingredient) => Text(
              "${ingredient.name} ${ingredient.value} ${ingredient.unit}",
            ),
          ),
        ],
      ),
    );
  }
}
