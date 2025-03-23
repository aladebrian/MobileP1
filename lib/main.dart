import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:recipe_planner/recipe_model.dart';
import 'package:recipe_planner/recipe_page.dart';
import 'package:recipe_planner/recipes.dart';
import 'package:recipe_planner/saved_recipes_page.dart';
import 'mealplanner_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider was placed above the MaterialApp so other routes can access RecipeModel
    return ChangeNotifierProvider(
      create: (context) => RecipeModel(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  // Navigate to Meal Planner screen and pass the carted recipes
  void navigateToMealPlanner(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MealPlannerScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Home Page"),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart_checkout),
            onPressed: () => navigateToMealPlanner(context),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SavedRecipesPage()),
              );
            },
            icon: Icon(Icons.favorite),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            FilterButtons(),
            Expanded(
              child: MasonryGridView.builder(
                padding: EdgeInsets.all(8.0),
                gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: context.watch<RecipeModel>().filteredRecipes.length,
                itemBuilder: (context, index) {
                  Recipe recipe =
                      context.watch<RecipeModel>().filteredRecipes[index];
                  return RecipeTile(recipe: recipe, showIcons: true);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeTile extends StatelessWidget {
  const RecipeTile({super.key, required this.recipe, this.showIcons = true});
  final Recipe recipe;
  final bool showIcons;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RecipePage(recipe: recipe)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RecipeImage(recipe: recipe, showIcons: showIcons),
            RecipeText(recipe: recipe),
          ],
        ),
      ),
    );
  }
}

class RecipeText extends StatelessWidget {
  //TODO: Have an ellipses overflow when the recipe name extends past 2 lines.
  // - Consider adding a dialog when the user hovers/taps on the tag? saying tag.name

  const RecipeText({super.key, required this.recipe});
  final Recipe recipe;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          direction: Axis.horizontal,
          children: [
            for (Tag tag in recipe.tags) Icon(tag.icon, color: tag.color),
          ],
        ),
        Text(recipe.name),
      ],
    );
  }
}

class RecipeImage extends StatelessWidget {
  const RecipeImage({super.key, required this.recipe, required this.showIcons});
  final Recipe recipe;
  final bool showIcons;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image(image: recipe.image, fit: BoxFit.cover),
            if (showIcons) RecipeImageIcons(recipe: recipe),
          ],
        ),
      ),
    );
  }
}

class RecipeImageIcons extends StatelessWidget {
  const RecipeImageIcons({super.key, required this.recipe});
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton.filled(
            onPressed: () {
              context.read<RecipeModel>().favoriteRecipe(recipe);
            },
            icon: Icon(
              Tag.favorited.icon,
              color: context.watch<RecipeModel>().iconColor(
                recipe,
                Tag.favorited,
              ),
            ),
          ),
          IconButton.filled(
            onPressed: () {
              context.read<RecipeModel>().addToCart(recipe);
            },
            icon: Icon(
              Tag.carted.icon,
              color: context.watch<RecipeModel>().iconColor(recipe, Tag.carted),
            ),
          ),
        ],
      ),
    );
  }
}

class FilterButtons extends StatelessWidget {
  const FilterButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children:
          Tag.getValues.map((Tag tag) {
            return FilterChip(
              label: Text(tag.name),
              selected: context.read<RecipeModel>().filters.contains(tag),
              onSelected:
                  (bool selected) =>
                      context.read<RecipeModel>().changeFilter(tag, selected),
            );
          }).toList(),
    );
  }
}
