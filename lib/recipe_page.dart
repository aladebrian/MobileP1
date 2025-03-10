import 'package:recipe_planner/recipes.dart';
import 'package:flutter/material.dart';

class RecipePage extends StatefulWidget {
  final Recipe recipe;
  const RecipePage({super.key, required this.recipe});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.recipe.name)),
      body: ListView.builder(
        itemCount: widget.recipe.ingredients.length,
        itemBuilder: (context, index) {
          String key = widget.recipe.ingredients.keys.elementAt(index);
          return ListTile(title: Text("$key:${widget.recipe.ingredients[key]}"));
        },
      ),
    );
  }
}
