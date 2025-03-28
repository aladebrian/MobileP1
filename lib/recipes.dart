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

  @override
  String toString() => name;

  // The ternary ensures that only liquid units can be converted to liquid units, and solid to solid
  double convert(IngredientUnit finalUnit) {
    return unit.isSolid() != finalUnit.isSolid()
        ? -1
        : (value * unit.ratio) / finalUnit.ratio;
  }

  Ingredient operator +(Ingredient other) {
    double otherValue = other.convert(unit);
    return Ingredient(name: name, value: value + otherValue, unit: unit);
  }

  Ingredient operator -(Ingredient other) {
    double otherValue = other.convert(unit);
    return Ingredient(name: name, value: value - otherValue, unit: unit);
  }
}
// [1, 2, 4, 8]
// TODO add solid units ounces and pounds

enum IngredientUnit {
  teaspoon(1),
  tablespoon(3),
  fluidOunce(6),
  cup(48),
  pint(96),
  quart(192),
  gallon(768),
  whole(-1),

  ounce(1),
  pound(16);

  static List<IngredientUnit> get solidUnits => [ounce, pound];
  static List<IngredientUnit> get liquidUnits => [
    teaspoon,
    tablespoon,
    fluidOunce,
    cup,
    pint,
    quart,
    gallon,
    whole,
  ];
  bool isSolid() => solidUnits.contains(this);
  @override
  String toString() => name;
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
