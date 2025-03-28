import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:recipe_planner/recipes.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'recipe_planner.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create recipes table
    await db.execute('''
      CREATE TABLE recipes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        steps TEXT,
        ingredients TEXT,
        tags TEXT,
        imagePath TEXT
      )
    ''');
  }

  Future<int> insertRecipe(Recipe recipe) async {
    final db = await database;
    return await db.insert(
      'recipes',
      _recipeToMap(recipe),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Recipe>> getAllRecipes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('recipes');

    return List.generate(maps.length, (i) {
      return _mapToRecipe(maps[i]);
    });
  }

  Future<int> updateRecipe(Recipe recipe) async {
    final db = await database;
    return await db.update(
      'recipes',
      _recipeToMap(recipe),
      where: 'id = ?',
      whereArgs: [recipe.id],
    );
  }

  Future<int> deleteRecipe(int id) async {
    final db = await database;
    return await db.delete('recipes', where: 'id = ?', whereArgs: [id]);
  }

  Map<String, dynamic> _recipeToMap(Recipe recipe) {
    return {
      'name': recipe.name,
      'steps': recipe.steps.join('|'), // Store steps as pipe-separated string
      'ingredients': _ingredientsToString(recipe.ingredients),
      'tags': recipe.tags.map((tag) => tag.toString()).join('|'),
      'imagePath': recipe.image.toString(),
    };
  }

  Recipe _mapToRecipe(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      name: map['name'],
      steps: (map['steps'] as String).split('|'),
      ingredients: _stringToIngredients(map['ingredients']),
      tags: _stringToTags(map['tags']),
    );
  }

  String _ingredientsToString(Map<String, Amount> ingredients) {
    return ingredients.entries
        .map(
          (entry) => '${entry.key}:${entry.value.number}:${entry.value.unit}',
        )
        .join('|');
  }

  Map<String, Amount> _stringToIngredients(String ingredientsString) {
    return Map.fromEntries(
      ingredientsString.split('|').map((ingredientStr) {
        var parts = ingredientStr.split(':');
        return MapEntry(parts[0], Amount(number: double.parse(parts[1])));
      }),
    );
  }

  Set<Tag> _stringToTags(String tagsString) {
    return tagsString
        .split('|')
        .where((tagStr) => tagStr.isNotEmpty)
        .map(
          (tagStr) => Tag.values.firstWhere((tag) => tag.toString() == tagStr),
        )
        .toSet();
  }
}
