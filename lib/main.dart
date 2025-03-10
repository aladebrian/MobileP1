import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:recipe_planner/recipe_page.dart';
import 'package:recipe_planner/recipes.dart';

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
      ingredients: {"a little bit of this": 1, 'a little bit of that': 2},
      tags: HashSet.from(["favorite"]),
    ),
    Recipe(
      name: "Recipe 2",
      steps: ["do this again", 'then this', 'unfortunately this'],
      ingredients: {"a lot of this": 10, 'a little bit of that': 20},
      tags: HashSet.from(["saved"]),
    ),
  ];
  GestureDetector recipeToGridTile(index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipePage(recipe: recipes[index]),
          ),
        );
      },
      child: GridTile(
        header: Text(recipes[index].name),
        child: Image(image: recipes[index].image),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          return recipeToGridTile(index);
        },
      ),
    );
  }
}
