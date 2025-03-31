import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_planner/recipe_model.dart';
import 'package:recipe_planner/recipe_page.dart';
import 'package:recipe_planner/recipes.dart';

class GroceryListScreen extends StatelessWidget {
  const GroceryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Groceries")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (Ingredient ingredient in context.watch<RecipeModel>().groceries)
              IngredientTile(ingredient: ingredient),
          ],
        ),
      ),
    );
  }
}
