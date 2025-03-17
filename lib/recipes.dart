import 'dart:collection';
import 'package:flutter/material.dart';

class Recipe {
  String name;
  List<String> steps;
  // Amount was created for easy conversion between units.
  // Some recipes will use different units for the same item, so converting it to one unit when combining ingredients is important
  Map<String, Amount> ingredients;
  // Acceptable tags include: vegetarian, vegan, pescetarian, saved and favorited,
  HashSet<Tag> tags;
  AssetImage image;

  Recipe({
    required this.name,
    required this.steps,
    required this.ingredients,
    HashSet<Tag>? tags,
    this.image = const AssetImage("assets/placeholder.jpg"),
  }) : tags = tags ?? HashSet<Tag>.from([]);
}

class Amount {
  double number;
  String type;
  String unit;

  Amount({required this.number, this.type = "solid", this.unit = "whole"});

  // TODO: Methods for conversion between liquid units (tbsp, tsp, cup, pint, quart, gallon, to whole)
}

enum Tag {
  saved(Color.fromRGBO(251, 192, 45, 1), Icons.star),
  favorited(Color.fromRGBO(229, 57, 53, 1), Icons.favorite),
  vegetarian(Color.fromRGBO(22, 201, 43, 1), Icons.eco),
  vegan(Color.fromRGBO(5, 115, 47, 1), Icons.compost),
  pescetarian(Color.fromRGBO(34, 124, 213, 1), Icons.set_meal);

  final Color color;
  final IconData icon;
  const Tag(this.color, this.icon);
  static Color get defaultColor => const Color.fromRGBO(158, 158, 158, 1);
}
