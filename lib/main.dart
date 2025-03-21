import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
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
      home: ChangeNotifierProvider(
        create: (context) => RecipeModel(),
        child: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
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
//  https://blog.codemagic.io/how-to-improve-the-performance-of-your-flutter-app and
//  https://www.youtube.com/watch?v=IOyq-eTRhvo
//  (Specifically the Don't Split Your Widgets Into Methods section)
//  - Rewrite the tiles to be more visually appealing. Similar to the tiles on the tasty app.
//  - The favorites are going to have favorites only. "saved" is no longer going to be a tag.
//  any recipe added to cart will be put into a list (Tentative idea)
class _MyHomePageState extends State<MyHomePage> {
  // Cart to hold added recipes
  List<Recipe> cartRecipes = [];

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
    return Consumer<RecipeModel>(
      builder:
          (context, value, child) => Scaffold(
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
                        builder:
                            (context) =>
                                SavedRecipesPage(recipes: RecipeModel.recipes),
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
                      gridDelegate:
                          SliverSimpleGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                      itemCount: value.filteredRecipes.length,
                      itemBuilder: (context, index) {
                        Recipe recipe = value.filteredRecipes[index];
                        return RecipeTile(recipe: recipe, showIcons: true);
                      },
                    ),
                  ),
                ],
              ),
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

class RecipeModel extends ChangeNotifier {
  static final List<Recipe> _allRecipes = [
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
      name:
          "Recipe 2 this is an extremely long recipe name unfortunately, its quite weird how long this is",
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
      tags: HashSet.from([Tag.pescetarian]),
    ),
    Recipe(
      name: "Recipe 4",
      steps: ["do this again", 'then this', 'unfortunately this'],
      ingredients: {
        "a lot of this": Amount(number: 20, unit: 'cups'),
        'a little bit of that': Amount(number: 5),
      },
      tags: HashSet.from([]),
      image: AssetImage("assets/food3.png"),
    ),
  ];

  final Set<Tag> _filters = {};
  static List<Recipe> get recipes => _allRecipes;
  Set<Tag> get filters => _filters;
  List<Recipe> get filteredRecipes =>
      _allRecipes.where((recipe) => recipe.tags.containsAll(_filters)).toList();
  void changeFilter(Tag filter, bool selected) {
    selected ? 
    _filters.add(filter) :
    _filters.remove(filter);
    notifyListeners();
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
            RecipeImage(image: recipe.image, showIcons: showIcons),
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
  // TODO: make iconbuttons actually do stuff in the main build.
  //  - change the color maybe
  const RecipeImage({super.key, required this.image, required this.showIcons});
  final AssetImage image;
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
            Image(image: image, fit: BoxFit.cover),
            if (showIcons) ...[
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
          ],
        ),
      ),
    );
  }
}

class FilterButtons extends StatelessWidget {
  const FilterButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeModel>(
      builder:
          (context, value, child) => Wrap(
            children:
                Tag.values.map((Tag tag) {
                  return FilterChip(
                    label: Text(tag.name),
                    selected: value.filters.contains(tag),
                    onSelected: (bool selected) {
                      final recipes = context.read<RecipeModel>();
                      recipes.changeFilter(tag, selected);
                    },
                  );
                }).toList(),
          ),
    );
  }
}
