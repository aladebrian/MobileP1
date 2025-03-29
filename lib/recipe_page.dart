import 'package:recipe_planner/recipes.dart';
import 'package:flutter/material.dart';

class RecipePage extends StatelessWidget {
  final Recipe recipe;
  const RecipePage({super.key, required this.recipe});

  static TextStyle boldStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe.name)),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Ingredients", style: boldStyle),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  for (Ingredient ingredient in recipe.ingredients)
                    IngredientTile(ingredient: ingredient),
                ],
              ),
            ),

            Text("Steps", style: boldStyle),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  for (final (index, step) in recipe.steps.indexed)
                    StepTile(stepNumber: index + 1, step: step),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IngredientTile extends StatelessWidget {
  const IngredientTile({super.key, required this.ingredient});

  final Ingredient ingredient;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(ingredient.name, style: TextStyle(color: Colors.black)),
            Text(
              ingredient.unitString,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Divider(),
      ],
    );
  }
}

class StepTile extends StatelessWidget {
  const StepTile({super.key, required this.stepNumber, required this.step});

  final int stepNumber;
  final String step;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Container(
          padding: EdgeInsets.all(15),
          color: Colors.grey[400],
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stepNumber.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 8),
              Expanded(child: Text(step)),
            ],
          ),
        ),
      ),
    );
  }
}
