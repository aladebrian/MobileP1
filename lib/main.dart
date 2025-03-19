import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:recipe_planner/recipe_page.dart';
import 'package:recipe_planner/recipes.dart';
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


// - Chage 
class _MyHomePageState extends State<MyHomePage> {
  // Cart to hold added recipes
  List<Recipe> cartRecipes = [];

  List<Recipe> recipes = [
    Recipe(
      name: "Recipe 1",
      steps: ["do this", 'then this', 'finally this'],
      ingredients: {
        "a little bit of this": Amount(number: 1, unit: 'quart'),
        'a little bit of that': Amount(number: 0.5),
      },
      tags: HashSet.from([Tag.favorited, Tag.vegan]),
    ),
    Recipe(
      name: "Recipe 2",
      steps: ["do this again", 'then this', 'unfortunately this'],
      ingredients: {
        "a lot of this": Amount(number: 20, unit: 'cups'),
        'a little bit of that': Amount(number: 5),
      },
      tags: HashSet.from([Tag.saved, Tag.vegetarian]),
    ),
  ];

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
        ],
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SavedRecipesPage(recipes: recipes),
                ),
              );
            },
            icon: Icon(Icons.favorite),
          ),
        ],
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          return homeScreenRecipeTile(index);
        },
      ),
    );
  }

  GestureDetector homeScreenRecipeTile(index) {
    // The tile used for each recipe.
    // Clicking sends the user into a webpage with that recipe's info
    // The header has the title and trailing action buttons
    //
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipePage(recipe: recipes[index]),
          ),
        );
      },
      child: Padding(
        // the padding each tile has to each other
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 120,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.purple[200],
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            children: [recipeHomeHeader(index), recipeHomeImage(index)],
          ),
        ),
      ),
    );
  }

  Expanded recipeHomeImage(index) {
    return Expanded(
      child: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          clipBehavior: Clip.hardEdge,
          child: Image(image: recipes[index].image),
        ),
      ),
    );
  }

  void toggleTag(int index, Tag tag) {
    setState(() {
      recipes[index].tags.contains(tag)
          ? recipes[index].tags.remove(tag)
          : recipes[index].tags.add(tag);
    });
  }

  Color tagColor(int index, Tag tag) {
    return recipes[index].tags.contains(tag) ? tag.color : Tag.defaultColor;
  }

  List<IconButton> recipeHomeHeaderIconButtons(int index) {
    const List<Tag> tagsUsed = [Tag.favorited, Tag.saved];
    List<IconButton> resultingIconButtons = [];
    for (Tag tagUsed in tagsUsed) {
      resultingIconButtons.add(
        IconButton(
          onPressed: () => toggleTag(index, tagUsed),
          icon: Icon(tagUsed.icon, color: tagColor(index, tagUsed)),
        ),
      );
    }
    return resultingIconButtons;
  }

  SizedBox recipeHomeHeader(int index) {
    // Used in homeScreenRecipeTile.
    // contains title and trailing icon buttons
    // TODO:
    //  - Use FittedBox for header responsiveness on different screen sizes.
    //  - Fix alignment of row's icons
    //  - make the icons closer to each other.

    return SizedBox(
      // color: Colors.blue[50],
      height: 30,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Align(alignment: Alignment.center, child: Text(recipes[index].name)),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: recipeHomeHeaderIconButtons(index),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
