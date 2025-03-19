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
      tags: HashSet.from(["favorite", "vegan"]),
    ),
    Recipe(
      name: "Recipe 2",
      steps: ["do this again", 'then this', 'unfortunately this'],
      ingredients: {
        "a lot of this": Amount(number: 20, unit: 'cups'),
        'a little bit of that': Amount(number: 5),
      },
      tags: HashSet.from(["saved", "vegetarian"]),
    ),
  ];

  void tagNullCheck(index) {
    // Needed because an empty hashset cannot be the default object for tags,
    // as an empty hashset cannot be constant
    recipes[index].tags ??= HashSet.from([]);
  }

  void changeTag(int index, String tag) {
    tagNullCheck(index);
    setState(() {
      recipes[index].tags!.contains(tag)
          ? recipes[index].tags!.remove(tag)
          : recipes[index].tags!.add(tag);
    });
  }

  Color hasTag(int index, String tag, Color yes, Color no) {
    tagNullCheck(index);
    return recipes[index].tags!.contains(tag) ? yes : no;
  }

  // Add a recipe to the cart
  void addToCart(Recipe recipe) {
    setState(() {
      cartRecipes.add(recipe);
    });
  }

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

  SizedBox recipeHomeHeader(int index) {
    // Used in homeScreenRecipeTile.
    // contains title and trailing icon buttons
    // TODO:
    //  - Use FittedBox for header responsiveness on different screen sizes.
    //  - Fix alignment of row's icons
    //  - make the icons closer to each other. remove the black background

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
                children: [
                  IconButton(
                    onPressed: () => changeTag(index, "favorite"),
                    icon: Icon(
                      Icons.favorite,
                      color: hasTag(
                        index,
                        "favorite",
                        const Color.fromRGBO(229, 57, 53, 1),
                        const Color.fromRGBO(158, 158, 158, 1),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => changeTag(index, "saved"),
                    icon: Icon(
                      Icons.star,
                      color: hasTag(
                        index,
                        "saved",
                        const Color.fromRGBO(251, 192, 45, 1),
                        const Color.fromRGBO(158, 158, 158, 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
