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
        Ingredient(
          name: "Peanut Butter",
          value: 2,
          unit: IngredientUnit.tablespoon,
        ),
        Ingredient(
          name: "Grape Jelly",
          value: 2,
          unit: IngredientUnit.teaspoon,
        ),
      },
      tags: {Tag.vegan, Tag.vegetarian},
      image: AssetImage("assets/pbj.webp"),
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
        Ingredient(
          name: "Heavy Whipping Cream",
          value: 1,
          unit: IngredientUnit.cup,
        ),
        Ingredient(
          name: "Fettucine Pasta",
          value: 1,
          unit: IngredientUnit.pound,
        ),
        Ingredient(
          name: "Parmesan Cheese",
          value: 1 / 2,
          unit: IngredientUnit.cup,
        ),
        Ingredient(name: "Salt", value: 1, unit: IngredientUnit.teaspoon),
      },
      tags: {Tag.vegetarian},
      image: AssetImage("assets/mushroom_alfredo.webp"),
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
        Ingredient(
          name: "Creole Seasoning",
          value: 2,
          unit: IngredientUnit.tablespoon,
        ),
        Ingredient(name: "Butter", value: 2, unit: IngredientUnit.tablespoon),
      },
      tags: {Tag.pescetarian},
      image: AssetImage("assets/grilled_shrimp.webp"),
    ),
    Recipe(
      name: "One Pot Salmon and Rice",
      steps: [
        "Season the salmon with salt, pepper and paprika",
        'In a medium pot, add in oil and pan fry the salmon for 2 min on each side, or until crust forms.'
            'Remove and set aside.',
        'In the same pan, add in butter and butter. Saute for 2-3 min.',
        'Add in the rice, mix well making sure the rice soaks up all the oil.',
        'Pour in the vegetable stock',
        'Add back in the salmon, place it on top of the rice.',
        'Once simmering, put the lid on. Cover and cook on low heat for 18-20 min. Keep an eye out to prevent burning.',
        'Turn the heat off and let it sit for another 5 min with the lid on and enjoy!',
      ],
      ingredients: {
        Ingredient(
          name: "Salmon Fillet",
          value: 16,
          unit: IngredientUnit.ounce,
        ),
        Ingredient(name: "Mushroom", value: 1, unit: IngredientUnit.cup),
        Ingredient(name: "Rice", value: 2, unit: IngredientUnit.cup),
        Ingredient(
          name: "Vegetable Stock",
          value: 2.5,
          unit: IngredientUnit.cup,
        ),
        Ingredient(name: "Butter", value: 2, unit: IngredientUnit.tablespoon),
        Ingredient(name: "Salt", value: 1, unit: IngredientUnit.teaspoon),
        Ingredient(name: "Pepper", value: 1, unit: IngredientUnit.teaspoon),
        Ingredient(
          name: "Paprika",
          value: 0.5,
          unit: IngredientUnit.tablespoon,
        ),
      },
      tags: {Tag.pescetarian},
      image: AssetImage("assets/salmon_rice.webp"),
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
    addRecipeToGroceries(recipe);
    notifyListeners();
  }

  // Remove a recipe from a specific day
  void removeRecipeFromDay(String day, Recipe recipe) {
    _weeklyMeals[day]?.remove(recipe);
    removeRecipeFromGroceries(recipe);
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

  //
  // Change the hashcode and equals operator for ingredients
  // to match the ingredient name instead of the object
  final Map<String, Ingredient> _groceries = {};
  List<dynamic> get groceries => _groceries.values.toList();

  void addRecipeToGroceries(Recipe recipe) {
    for (Ingredient ingredient in recipe.ingredients) {
      if (_groceries.containsKey(ingredient.name)) {
        _groceries[ingredient.name] = _groceries[ingredient.name]! + ingredient;
      } else {
        _groceries[ingredient.name] = ingredient;
      }
    }
    notifyListeners();
  }

  void removeRecipeFromGroceries(Recipe recipe) {
    for (Ingredient ingredient in recipe.ingredients) {
      _groceries[ingredient.name] = _groceries[ingredient.name]! - ingredient;
      if (_groceries[ingredient.name]!.value == 0) {
        _groceries.remove(ingredient.name);
      }
    }
    notifyListeners();
  }
}
