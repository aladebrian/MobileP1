import 'dart:collection';

import 'package:flutter/widgets.dart';

class Recipe {
  String name;
  List<String> steps;
  Map<String, int> ingredients;
  HashSet<String>? tags;
  AssetImage image;

  Recipe({
    required this.name,
    required this.steps,
    required this.ingredients,
    this.tags,
    this.image = const AssetImage("assets/placeholder.jpg"),
  });
}
