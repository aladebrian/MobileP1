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
      body: ListView(
        children: [
          Text("Ingredients", style: boldStyle),
          for (Ingredient ingredient in recipe.ingredients)
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(text: "• ", style: TextStyle(color: Colors.orange)),
                  TextSpan(
                    text:
                        "${ingredient.value.toString()} ${ingredient.unit.name} ${ingredient.name}",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          Divider(),
          Text("Steps", style: boldStyle),
          for (final (index, step) in recipe.steps.indexed)
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "${index + 1} ",
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: step, style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
