import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:recipe_planner/main.dart';
import 'package:recipe_planner/recipe_model.dart';

class SavedRecipesPage extends StatelessWidget {
  const SavedRecipesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: MasonryGridView.builder(
          gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: context.read<RecipeModel>().favorites.length,
          itemBuilder: (context, index) {
            return RecipeTile(
              recipe: context.read<RecipeModel>().favorites.toList()[index],
              showIcons: false,
            );
          },
        ),
      ),
    );
  }
}
