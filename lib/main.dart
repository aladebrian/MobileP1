import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// TODO:
//  - Change ui and logic to fit best practices according to
//  https://blog.codemagic.io/how-to-improve-the-performance-of-your-flutter-app.
//  (Specifically the Don't Split Your Widgets Into Methods section)
//  - Rewrite the tiles to be more visually appealing. Similar to the tiles on the tasty app.
//  - The favorites are going to have favorites only. "saved" is no longer going to be a tag.
//  any recipe added to cart will be put into a list.
class _MyHomePageState extends State<MyHomePage> {
  // Cart to hold added recipes
  List<Recipe> cartRecipes = [];
  List<Recipe> allRecipes = [
    Recipe(
      name: "Recipe 1",
      steps: ["do this", 'then this', 'finally this'],
      ingredients: {
        "a little bit of this": Amount(number: 1, unit: 'quart'),
        'a little bit of that': Amount(number: 0.5),
      },
      tags: HashSet.from([Tag.favorited, Tag.vegan]),
      image: AssetImage("assets/food.avif"),
    ),
    Recipe(
      name: "Recipe 2 this is an extremely long recipe name unfortunately, its quite weird how long this is",
      steps: ["do this again", 'then this', 'unfortunately this'],
      ingredients: {
        "a lot of this": Amount(number: 20, unit: 'cups'),
        'a little bit of that': Amount(number: 5),
      },
      tags: HashSet.from([Tag.saved, Tag.vegetarian]),
      image: AssetImage("assets/food2.webp"),
    ),
    Recipe(
      name: "Recipe 3",
      steps: ["do this again", 'then this', 'unfortunately this'],
      ingredients: {
        "a lot of this": Amount(number: 20, unit: 'cups'),
        'a little bit of that': Amount(number: 5),
      },
      tags: HashSet.from([Tag.saved, Tag.vegetarian]),
    ),
    Recipe(
      name: "Recipe 4",
      steps: ["do this again", 'then this', 'unfortunately this'],
      ingredients: {
        "a lot of this": Amount(number: 20, unit: 'cups'),
        'a little bit of that': Amount(number: 5),
      },
      tags: HashSet.from([Tag.saved, Tag.vegetarian]),
      image: AssetImage("assets/food3.png"),
    ),
  ];
  late List<Recipe> filteredRecipes = allRecipes.toList();
  // late List<Recipe> filteredRecipes =
  //     allRecipes
  //         .where((recipe) => recipe.tags.containsAll(_selection))
  //         .toList();
  // Navigate to Meal Planner screen and pass the carted recipes
  void navigateToMealPlanner() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealPlannerScreen(cartRecipes: cartRecipes),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart_checkout),
            onPressed: navigateToMealPlanner,
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SavedRecipesPage(recipes: allRecipes),
                ),
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
                itemCount: filteredRecipes.length,
                itemBuilder: (context, index) {
                  Recipe recipe = filteredRecipes[index];
                  return RecipeTile(recipe: recipe);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  // TODO: EVERYTHING COMMENTED OUT BELOW NEEDS TO BE REFACTORED.
  // GestureDetector homeScreenRecipeTile(Recipe recipe) {
  //   // The tile used for each recipe.
  //   // Clicking sends the user into a webpage with that recipe's info
  //   // The header has the title and trailing action buttons
  //   //
  //   return GestureDetector(
  //     onTap: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => RecipePage(recipe: recipe)),
  //       );
  //     },

  //     child: Padding(
  //       // the padding each tile has to each other
  //       padding: const EdgeInsets.all(8.0),
  //       child: Container(
  //         height: 120,
  //         width: 100,
  //         decoration: BoxDecoration(
  //           color: Colors.purple[200],
  //           borderRadius: BorderRadius.all(Radius.circular(20)),
  //         ),
  //         child: Column(
  //           children: [
  //             recipeHomeHeader(recipe),
  //             RecipeImage(image: recipe.image),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // void toggleTag(Recipe recipe, Tag tag) {
  //   setState(() {
  //     recipe.tags.contains(tag)
  //         ? recipe.tags.remove(tag)
  //         : recipe.tags.add(tag);
  //   });
  // }

  // Color tagColor(Recipe recipe, Tag tag) {
  //   return recipe.tags.contains(tag) ? tag.color : Tag.defaultColor;
  // }

  // List<IconButton> recipeHomeHeaderIconButtons(Recipe recipe) {
  //   const List<Tag> tagsUsed = [Tag.favorited, Tag.saved];
  //   List<IconButton> resultingIconButtons = [];
  //   for (Tag tagUsed in tagsUsed) {
  //     resultingIconButtons.add(
  //       IconButton(
  //         padding: EdgeInsets.all(0),
  //         onPressed: () => toggleTag(recipe, tagUsed),
  //         icon: Icon(tagUsed.icon, color: tagColor(recipe, tagUsed)),
  //       ),
  //     );
  //   }
  //   return resultingIconButtons;
  // }

  // List<Icon> recipeTags(Recipe recipe) {
  //   List<Icon> recipeIcons = [];
  //   for (Tag tag in Tag.values) {
  //     if (recipe.tags.contains(tag)) {
  //       recipeIcons.add(Icon(tag.icon));
  //     }
  //   }
  //   return recipeIcons;
  // }

  // SizedBox recipeHomeHeader(Recipe recipe) {
  //   // Used in homeScreenRecipeTile.
  //   // contains title and trailing icon buttons
  //   // TODO:
  //   //  - Use FittedBox for header responsiveness on different screen sizes.
  //   //  - Fix alignment of row's icons
  //   //  - make the icons closer to each other.

  //   return SizedBox(
  //     height: 30,
  //     child: Stack(
  //       fit: StackFit.expand,
  //       children: [
  //         Align(
  //           alignment: Alignment.centerLeft,
  //           child: SizedBox(
  //             child: Row(
  //               mainAxisSize: MainAxisSize.min,
  //               children: recipeTags(recipe),
  //             ),
  //           ),
  //         ),
  //         Align(alignment: Alignment.center, child: Text(recipe.name)),
  //         Align(
  //           alignment: Alignment.centerRight,
  //           child: SizedBox(
  //             child: Row(
  //               mainAxisSize: MainAxisSize.min,
  //               children: recipeHomeHeaderIconButtons(recipe),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

class RecipeTile extends StatelessWidget {
  const RecipeTile({super.key, required this.recipe});
  final Recipe recipe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RecipeImage(image: recipe.image),
          RecipeText(recipe: recipe),
        ],
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
        Text(recipe.name),
        Wrap(
          direction: Axis.horizontal,
          children: [
            for (Tag tag in recipe.tags) Icon(tag.icon, color: tag.color, ),
          ],
        ),
      ],
    );
  }
}

class RecipeImage extends StatelessWidget {
  // TODO: make iconbuttons actually do stuff in the main build. 
  //  - change the color maybe
  const RecipeImage({super.key, required this.image});
  final AssetImage image;
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image(image: image, fit: BoxFit.cover),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton.filled(
                onPressed: () {},
                icon: Icon(Icons.favorite),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: IconButton.filled(
                onPressed: () {},
                icon: Icon(Icons.shopping_cart),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterButtons extends StatefulWidget {
  const FilterButtons({super.key});

  @override
  State<FilterButtons> createState() => _FilterButtonsState();
}

class _FilterButtonsState extends State<FilterButtons> {
  // TODO: make _selected change the actual filter in the main build.
  Set<Tag> _selected = {};

  void updateSelected(Set<Tag> newSelection) {
    setState(() {
      _selected = newSelection;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      multiSelectionEnabled: true,
      emptySelectionAllowed: true,
      segments: <ButtonSegment<Tag>>[
        ButtonSegment(value: Tag.vegan, label: Text(Tag.vegan.name)),
        ButtonSegment(value: Tag.vegetarian, label: Text(Tag.vegetarian.name)),
        ButtonSegment(
          value: Tag.pescetarian,
          label: Text(Tag.pescetarian.name),
        ),
        ButtonSegment(value: Tag.favorited, label: Text(Tag.favorited.name)),
      ],
      selected: _selected,
      onSelectionChanged: updateSelected,
    );
  }
}
