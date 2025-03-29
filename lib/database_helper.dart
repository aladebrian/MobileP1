import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'recipes.dart';

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
      CREATE TABLE recipes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        image TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE steps (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        recipe_id INTEGER NOT NULL,
        step_number INTEGER NOT NULL,
        description TEXT NOT NULL,
        FOREIGN KEY (recipe_id) REFERENCES recipes(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE ingredients (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        recipe_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        quantity REAL NOT NULL,
        unit TEXT NOT NULL,
        FOREIGN KEY (recipe_id) REFERENCES recipes(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE tags (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        recipe_id INTEGER NOT NULL,
        tag TEXT NOT NULL,
        FOREIGN KEY (recipe_id) REFERENCES recipes(id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> insertRecipe(Recipe recipe) async {
    final db = await database;

    int recipeId = await db.insert('recipes', {'name': recipe.name});

    for (var ingredient in recipe.ingredients) {
      await db.insert('ingredients', {
        'recipe_id': recipeId,
        'name': ingredient.name,
        'quantity': ingredient.value,
        'unit': ingredient.unit.toString().split('.').last,
      });
    }

    for (var tag in recipe.tags) {
      await db.insert('tags', {
        'recipe_id': recipeId,
        'tag': tag.toString().split('.').last,
      });
    }

    for (int i = 0; i < recipe.steps.length; i++) {
      await db.insert('steps', {
        'recipe_id': recipeId,
        'step_number': i + 1,
        'description': recipe.steps[i],
      });
    }
  }

  Future<List<Recipe>> getRecipes() async {
    final db = await database;
    final List<Map<String, dynamic>> recipesData = await db.query('recipes');

    List<Recipe> recipes = [];

    for (var recipeData in recipesData) {
      int recipeId = recipeData['id'];

      final ingredientsData = await db.query(
        'ingredients',
        where: 'recipe_id = ?',
        whereArgs: [recipeId],
      );
      Set<Ingredient> ingredients =
          ingredientsData.map((i) {
            String name = i['name'] as String;

            double quantity =
                i['quantity'] != null ? (i['quantity'] as num).toDouble() : 0.0;

            IngredientUnit unit = IngredientUnit.values.firstWhere(
              (e) => e.toString().split('.').last == (i['unit'] as String?),
              orElse: () => IngredientUnit.other,
            );

            return Ingredient(name: name, value: quantity, unit: unit);
          }).toSet();

      final stepsData = await db.query(
        'steps',
        where: 'recipe_id = ?',
        whereArgs: [recipeId],
      );
      List<String> steps =
          stepsData.map((s) => s['description'] as String).toList();

      final tagsData = await db.query(
        'tags',
        where: 'recipe_id = ?',
        whereArgs: [recipeId],
      );
      Set<Tag> tags =
          tagsData.map((t) {
            String tagString = t['tag'] as String;
            return Tag.values.firstWhere(
              (e) => e.toString().split('.').last == tagString,
            );
          }).toSet();

      recipes.add(
        Recipe(
          id: recipeId,
          name: recipeData['name'],
          steps: steps,
          ingredients: ingredients,
          tags: tags,
        ),
      );
    }

    return recipes;
  }

  Future<int> deleteRecipe(int id) async {
    final db = await database;
    await db.delete('steps', where: 'recipe_id = ?', whereArgs: [id]);
    await db.delete('ingredients', where: 'recipe_id = ?', whereArgs: [id]);
    await db.delete('tags', where: 'recipe_id = ?', whereArgs: [id]);
    return await db.delete('recipes', where: 'id = ?', whereArgs: [id]);
  }
}
