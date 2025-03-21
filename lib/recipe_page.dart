import 'package:recipe_planner/recipes.dart';
import 'package:flutter/material.dart';

class RecipePage extends StatelessWidget {
  final Recipe recipe;
  const RecipePage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe.name)),
      body: ListView.builder(
        itemCount: recipe.ingredients.length,
        itemBuilder: (context, index) {
          String key = recipe.ingredients.keys.elementAt(index);
          return ListTile(title: Text("$key:${recipe.ingredients[key]}"));
        },
      ),
    );
  }
}
