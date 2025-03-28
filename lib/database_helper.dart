import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:recipe_planner/recipes.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'recipe_planner.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cart_recipes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        recipe_data TEXT UNIQUE
      )
    ''');
    await db.execute('''
      CREATE TABLE favorite_recipes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        recipe_data TEXT UNIQUE
      )
    ''');
  }

  Future<bool> addToCart(Recipe recipe) async {
    final db = await database;

    try {
      String recipeJson = jsonEncode({
        'name': recipe.name,
        'steps': recipe.steps,
        'ingredients': recipe.ingredients.map(
          (key, value) =>
              MapEntry(key, {'number': value.number, 'unit': value.unit}),
        ),
        'tags': recipe.tags.map((tag) => tag.toString()).toList(),
        'image': recipe.image.toString(),
      });

      await db.insert('cart_recipes', {
        'recipe_data': recipeJson,
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
      return true;
    } catch (e) {
      print('Error adding to cart: $e');
      return false;
    }
  }

  Future<bool> addToFavorites(Recipe recipe) async {
    final db = await database;

    try {
      String recipeJson = jsonEncode({
        'name': recipe.name,
        'steps': recipe.steps,
        'ingredients': recipe.ingredients.map(
          (key, value) =>
              MapEntry(key, {'number': value.number, 'unit': value.unit}),
        ),
        'tags': recipe.tags.map((tag) => tag.toString()).toList(),
        'image': recipe.image.toString(),
      });

      await db.insert('favorite_recipes', {
        'recipe_data': recipeJson,
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
      return true;
    } catch (e) {
      // ignore_for_file: avoid_print
      print('Error adding to favorites: $e');
      return false;
    }
  }

  Future<Set<Recipe>> getCartRecipes() async {
    final db = await database;

    try {
      final recipes = await db.query('cart_recipes');

      return recipes.map((recipeMap) {
        final Map<String, dynamic> decodedMap = jsonDecode(
          recipeMap['recipe_data'] as String,
        );

        Map<String, Amount> ingredients = {};
        (decodedMap['ingredients'] as Map).forEach((key, value) {
          ingredients[key] = Amount(
            number: value['number'],
            unit: value['unit'],
          );
        });

        Set<Tag> tags =
            (decodedMap['tags'] as List)
                .map(
                  (tagString) => Tag.values.firstWhere(
                    (tag) => tag.toString() == tagString,
                  ),
                )
                .toSet();

        return Recipe(
          name: decodedMap['name'],
          steps: List<String>.from(decodedMap['steps']),
          ingredients: ingredients,
          tags: tags,
        );
      }).toSet();
    } catch (e) {
      print('Error retrieving cart recipes: $e');
      return {};
    }
  }

  Future<Set<Recipe>> getFavoriteRecipes() async {
    final db = await database;

    try {
      final recipes = await db.query('favorite_recipes');

      return recipes.map((recipeMap) {
        final Map<String, dynamic> decodedMap = jsonDecode(
          recipeMap['recipe_data'] as String,
        );

        Map<String, Amount> ingredients = {};
        (decodedMap['ingredients'] as Map).forEach((key, value) {
          ingredients[key] = Amount(
            number: value['number'],
            unit: value['unit'],
          );
        });

        Set<Tag> tags =
            (decodedMap['tags'] as List)
                .map(
                  (tagString) => Tag.values.firstWhere(
                    (tag) => tag.toString() == tagString,
                  ),
                )
                .toSet();

        return Recipe(
          name: decodedMap['name'],
          steps: List<String>.from(decodedMap['steps']),
          ingredients: ingredients,
          tags: tags,
        );
      }).toSet();
    } catch (e) {
      print('Error retrieving favorite recipes: $e');
      return {};
    }
  }

  Future<bool> deleteFromCart(Recipe recipe) async {
    final db = await database;

    try {
      String recipeJson = jsonEncode({
        'name': recipe.name,
        'steps': recipe.steps,
        'ingredients': recipe.ingredients.map(
          (key, value) =>
              MapEntry(key, {'number': value.number, 'unit': value.unit}),
        ),
        'tags': recipe.tags.map((tag) => tag.toString()).toList(),
        'image': recipe.image.toString(),
      });

      int deletedCount = await db.delete(
        'cart_recipes',
        where: 'recipe_data = ?',
        whereArgs: [recipeJson],
      );

      return deletedCount > 0;
    } catch (e) {
      print('Error deleting from cart: $e');
      return false;
    }
  }

  Future<bool> deleteFromFavorites(Recipe recipe) async {
    final db = await database;

    try {
      String recipeJson = jsonEncode({
        'name': recipe.name,
        'steps': recipe.steps,
        'ingredients': recipe.ingredients.map(
          (key, value) =>
              MapEntry(key, {'number': value.number, 'unit': value.unit}),
        ),
        'tags': recipe.tags.map((tag) => tag.toString()).toList(),
        'image': recipe.image.toString(),
      });

      int deletedCount = await db.delete(
        'favorite_recipes',
        where: 'recipe_data = ?',
        whereArgs: [recipeJson],
      );

      return deletedCount > 0;
    } catch (e) {
      print('Error deleting from favorites: $e');
      return false;
    }
  }
}
