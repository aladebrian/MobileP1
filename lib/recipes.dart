import 'package:flutter/material.dart';

class Recipe {
  String name;
  List<String> steps;
  // Amount was created for easy conversion between units.
  // Some recipes will use different units for the same item, so converting it to one unit when combining ingredients is important
  Map<String, Amount> ingredients;
  // Acceptable tags include: vegetarian, vegan, pescetarian, saved and favorited,
  Set<Tag> tags;
  AssetImage image;

  Recipe({
    required this.name,
    required this.steps,
    required this.ingredients,
    Set<Tag>? tags,
    this.image = const AssetImage("assets/placeholder.avif"),
  }) : tags = tags ?? {};

}

class Amount {
  double number;
  String type;
  String unit;

  Amount({required this.number, this.type = "solid", this.unit = "whole"});

  // TODO: Methods for conversion between liquid units (tbsp, tsp, cup, pint, quart, gallon, to whole)
}

enum Tag {
  carted(Color.fromRGBO(251, 192, 45, 1), Icons.shopping_cart),
  favorited(Color.fromRGBO(229, 57, 53, 1), Icons.favorite),
  vegetarian(Color.fromRGBO(22, 201, 43, 1), Icons.eco),
  vegan(Color.fromRGBO(5, 115, 47, 1), Icons.compost),
  pescetarian(Color.fromRGBO(34, 124, 213, 1), Icons.set_meal);

  static Set<Tag> _specialTags = {Tag.carted, Tag.favorited};

  final Color color;
  final IconData icon;
  const Tag(this.color, this.icon);
  
  static Color get defaultColor => const Color.fromRGBO(158, 158, 158, 1);
  static List<Tag> get getValues =>
      Tag.values
          .where((Tag tag) => !_specialTags.contains(tag))
          .toList();
}
