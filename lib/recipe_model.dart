import 'package:flutter/material.dart';
import 'package:recipe_planner/recipes.dart';

class RecipeModel extends ChangeNotifier {
  // Recipes
  static final List<Recipe> _allRecipes = [
    Recipe(
      name: "PB & J",
      steps: [
        "Spread the peanut butter on one piece of bread",
        'Spread the jelly on the other side',
        'Put the two pieces of bread together to form a sandwich',
      ],
      ingredients: {
        Ingredient(name: "Slices of Sandwich Bread", value: 2),
        Ingredient(name: "Peanut Butter", value: 2, unit: IngredientUnit.tablespoon),
        Ingredient(name: "Grape Jelly", value: 2, unit: IngredientUnit.teaspoon),
      },
      tags: {Tag.vegan, Tag.vegetarian},
      image: AssetImage("assets/food.avif"),
    ),
    Recipe(
      name: "Mushroom Alfredo Pasta",
      steps: [
        "Add the garlic and mushrooms to a large pan with the butter",
        'Sauté the mushrooms for about 10-15 minutes',
        'Add the cream and simmer over a low heat',
        'Cook the fettucine in a large pot according to the package directions',
        'Drain it and then the pasta to the pan',
        'Add mushroom sauce to the hot fettuccine and mix it',
        'Add parmesan cheese and season with salt',
        'Now serve it on a plate and enjoy!',
      ],
      ingredients: {
        Ingredient(name: "Butter", value: 1 / 2, unit: IngredientUnit.cup),
        Ingredient(name: "Garlic", value: 2, unit: IngredientUnit.tablespoon),
        Ingredient(name: "Mushrooms", value: 16, unit: IngredientUnit.ounce),
        Ingredient(name: "Heavy Whipping Cream", value: 1, unit: IngredientUnit.cup),
        Ingredient(name: "Fettucine Pasta", value: 1, unit: IngredientUnit.pound),
        Ingredient(name: "Parmesan Cheese", value: 1 / 2, unit: IngredientUnit.cup),
        Ingredient(name: "Salt", value: 1, unit: IngredientUnit.teaspoon),
      },
      tags: {Tag.vegetarian},
      image: AssetImage("assets/food2.webp"),
    ),
    Recipe(
      name: "Grilled Shrimp",
      steps: [
        "Mix the creole seasoning in with the shrimp",
        'Put the butter into a hot pan',
        'Once butter has melted, drop seasoning shrimp into the hot pan',
        'Let the shrimp cook for 5-7 minutes while flippig it on both sides',
        'Remove shrimp from pan and place on a plate',
      ],
      ingredients: {
        Ingredient(name: "Shrimp", value: 1, unit: IngredientUnit.pound),
        Ingredient(name: "Creole Seasoning", value: 2, unit: IngredientUnit.tablespoon),
        Ingredient(name: "Butter", value: 2, unit: IngredientUnit.tablespoon),
      },
      tags: {Tag.pescetarian},
      image: AssetImage("assets/food.avif"),
    ),
    Recipe(
      name:
          "Recipe 4",
      steps: ["do this again", 'then this', 'unfortunately this'],
      ingredients: {
        Ingredient(name: "a lot of this", value: 20, unit: IngredientUnit.cup),
        Ingredient(name: "a little bit of that", value: 10, unit: IngredientUnit.cup)
      },
      tags: {Tag.vegetarian},
      image: AssetImage("assets/food3.png"),
    ),
  ];
  static List<Recipe> get recipes => _allRecipes;

  // Filters
  final Set<Tag> _filters = {};
  Set<Tag> get filters => _filters;
  List<Recipe> get filteredRecipes =>
      _allRecipes.where((recipe) => recipe.tags.containsAll(_filters)).toList();

  void changeFilter(Tag filter, bool selected) {
    selected ? _filters.add(filter) : _filters.remove(filter);
    notifyListeners();
  }

  // It seems counterintuitive to have a set of _cartRecipes and a set of _favoriteRecipes when we already had tags for them, but
  // we need a list of the values when printing them in the cart page and favorites page (otherwise we'd have to iterate through every
  // recipe every time), and we need a way to store this list for local storage with sqlite. The tags are still beneficial because
  // they allow for easy access of the correct icon and icon color.
  // Cart
  final Set<Recipe> _cartRecipes = {};
  Set<Recipe> get cart => _cartRecipes;

  void addToCart(Recipe recipe) {
    _cartRecipes.contains(recipe)
        ? _cartRecipes.remove(recipe)
        : _cartRecipes.add(recipe);
    notifyListeners();
  }

  final Map<String, List<Recipe>> _weeklyMeals = {
    'Monday': [],
    'Tuesday': [],
    'Wednesday': [],
    'Thursday': [],
    'Friday': [],
    'Saturday': [],
    'Sunday': [],
  };

  // Getter for the weekly meals
  Map<String, List<Recipe>> get weeklyMeals => _weeklyMeals;

  // Add a recipe to a specific day
  void addRecipeToDay(String day, Recipe recipe) {
    _weeklyMeals[day]?.add(recipe);
    notifyListeners();
  }

  // Remove a recipe from a specific day
  void removeRecipeFromDay(String day, Recipe recipe) {
    _weeklyMeals[day]?.remove(recipe);
    notifyListeners();
  }

  // Favorites
  final Set<Recipe> _favoriteRecipes = {};
  Set<Recipe> get favorites => _favoriteRecipes;

  void favoriteRecipe(Recipe recipe) {
    _favoriteRecipes.contains(recipe)
        ? _favoriteRecipes.remove(recipe)
        : _favoriteRecipes.add(recipe);

    notifyListeners();
  }

  Color iconColor(Recipe recipe, Tag tag) {
    final Set<Recipe> set;
    tag == Tag.favorited ? set = _favoriteRecipes : set = _cartRecipes;
    return set.contains(recipe) ? tag.color : Tag.defaultColor;
  }
}
