import 'package:flutter/material.dart';
import 'package:recipe_planner/recipes.dart';
import 'database_helper.dart';

class RecipeModel extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  // Recipes
  static final List<Recipe> _allRecipes = [
    Recipe(
      name: "Recipe 1",
      steps: ["do this", 'then this', 'finally this'],
      ingredients: {
        "a little bit of this": Amount(number: 1, unit: 'quart'),
        'a little bit of that': Amount(number: 0.5),
      },
      tags: {Tag.vegan, Tag.vegetarian},
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
      tags: {Tag.vegetarian},
      image: AssetImage("assets/food2.webp"),
    ),
    Recipe(
      name: "Recipe 3",
      steps: ["do this again", 'then this', 'unfortunately this'],
      ingredients: {
        "a lot of this": Amount(number: 20, unit: 'cups'),
        'a little bit of that': Amount(number: 5),
      },
      tags: {Tag.pescetarian},
    ),
    Recipe(
      name: "Recipe 4",
      steps: ["do this again", 'then this', 'unfortunately this'],
      ingredients: {
        "a lot of this": Amount(number: 20, unit: 'cups'),
        'a little bit of that': Amount(number: 5),
      },
      tags: {},
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

  void addToCart(Recipe recipe) async {
    if (_cartRecipes.contains(recipe)) {
      _cartRecipes.remove(recipe);
      await _dbHelper.deleteFromCart(recipe);
    } else {
      _cartRecipes.add(recipe);
      await _dbHelper.addToCart(recipe);
    }
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

  void favoriteRecipe(Recipe recipe) async {
    if (_favoriteRecipes.contains(recipe)) {
      _favoriteRecipes.remove(recipe);
      await _dbHelper.deleteFromFavorites(recipe); // Remove from DB
    } else {
      _favoriteRecipes.add(recipe);
      await _dbHelper.addToFavorites(recipe); // Add to DB
    }
    notifyListeners();
  }

  void loadSavedRecipes() async {
    Set<Recipe> savedCart = await _dbHelper.getCartRecipes();
    Set<Recipe> savedFavorites = await _dbHelper.getFavoriteRecipes();

    _cartRecipes.addAll(savedCart);
    _favoriteRecipes.addAll(savedFavorites);

    notifyListeners();
  }

  Color iconColor(Recipe recipe, Tag tag) {
    final Set<Recipe> set;
    tag == Tag.favorited ? set = _favoriteRecipes : set = _cartRecipes;
    return set.contains(recipe) ? tag.color : Tag.defaultColor;
  }
}
