import 'package:flutter/material.dart';
import 'package:recipe_planner/recipes.dart';

class RecipeModel extends ChangeNotifier {
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

  bool addToCart(Recipe recipe) {
    // Returns true if successfully added to cart. returns false if not (already in cart)
    // the boolean statemetn is for the popup that appears when the item is added to cart or not
    bool returnStatement = false;
    if (!_cartRecipes.contains(recipe)) {
      _cartRecipes.add(recipe);
      returnStatement = true;
      notifyListeners();
    }
    return returnStatement;
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
