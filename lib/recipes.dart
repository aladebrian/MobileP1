import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
class Recipe {
  final int? id;
  String name;
  List<String> steps;
  // Ingredient was created for easy conversion between units.
  // Some recipes will use different units for the same item, so converting it to one unit when combining ingredients is important
  Set<Ingredient> ingredients;
  // Acceptable tags include: vegetarian, vegan, pescetarian, saved and favorited,
  Set<Tag> tags;
  AssetImage image;

  Recipe({
    this.id,
    required this.name,
    required this.steps,
    required this.ingredients,
    Set<Tag>? tags,
    this.image = const AssetImage("assets/placeholder.avif"),
  }) : tags = tags ?? {};

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'steps': steps,
      'ingredients': ingredients.map(
        (key, value) =>
            MapEntry(key, {'number': value.number, 'unit': value.unit}),
      ),
      'tags': tags.map((tag) => tag.toString()).toList(),
      'image': image.toString(),
    };
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    Map<String, Amount> ingredients = {};
    (json['ingredients'] as Map).forEach((key, value) {
      ingredients[key] = Amount(number: value['number'], unit: value['unit']);
    });

    Set<Tag> tags =
        (json['tags'] as List)
            .map(
              (tagString) =>
                  Tag.values.firstWhere((tag) => tag.toString() == tagString),
            )
            .toSet();

    return Recipe(
      id: json['id'],
      name: json['name'],
      steps: List<String>.from(json['steps']),
      ingredients: ingredients,
      tags: tags,
      image: AssetImage(json['image']),
    );
  }
}

class Ingredient {
  String name;
  double value;
  IngredientUnit unit;

  Ingredient({
    required this.name,
    required this.value,
    this.unit = IngredientUnit.whole,
  });

  // TODO: Methods for conversion between units (tsp, -> tbsp, cup, pint, quart, gallon,)
  // Liquid includes powder measurements.
  @override
  String toString() => name;
  double convert(IngredientUnit finalUnit) {
    return (value * unit.ratio) / finalUnit.ratio; 
  }
}
// [1, 2, 4, 8]

enum IngredientUnit {
  teaspoon(1),
  tablespoon(3),
  fluidOunce(6),
  cup(48),
  pint(96),
  quart(192),
  gallon(768),
  whole(-1);
  final int ratio;
  const IngredientUnit(this.ratio);
  // to convert units, multiply by the ratio and divide by the next number
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
      Tag.values.where((Tag tag) => !_specialTags.contains(tag)).toList();
}
