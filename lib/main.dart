import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:recipe_planner/recipe_page.dart';
import 'package:recipe_planner/recipes.dart';
import 'package:recipe_planner/saved_recipes_page.dart';

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

  void changeTag(int index, Tag tag) {
    setState(() {
      recipes[index].tags.contains(tag)
          ? recipes[index].tags.remove(tag)
          : recipes[index].tags.add(tag);
    });
  }

  // Color hasTag(int index, String tag, Color yes, Color no) {
  //   return recipes[index].tags.contains(tag) ? yes : no;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
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
                    onPressed: () => changeTag(index, Tag.favorited),
                    icon: Icon(
                      Tag.favorited.icon,
                      color:
                          recipes[index].tags.contains(Tag.favorited)
                              ? Tag.favorited.color
                              : Tag.defaultColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () => changeTag(index, Tag.saved),
                    icon: Icon(
                      Tag.saved.icon,
                      color:
                          recipes[index].tags.contains(Tag.saved)
                              ? Tag.saved.color
                              : Tag.defaultColor,
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
