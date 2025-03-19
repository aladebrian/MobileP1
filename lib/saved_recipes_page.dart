import 'package:flutter/material.dart';
import 'package:recipe_planner/recipe_page.dart';
import 'package:recipe_planner/recipes.dart';

class SavedRecipesPage extends StatefulWidget {
  const SavedRecipesPage({super.key, required this.recipes});
  final List<Recipe> recipes;
  @override
  State<SavedRecipesPage> createState() => _SavedRecipesPageState();
}

class _SavedRecipesPageState extends State<SavedRecipesPage> {
  late List<Recipe> savedRecipes =
      widget.recipes
          .where(
            (recipe) =>
                recipe.tags.contains(Tag.saved) ||
                recipe.tags.contains(Tag.favorited),
          )
          .toList();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemCount: savedRecipes.length,
        itemBuilder: (context, index) => Placeholder(),
      ),
    );
  }
}