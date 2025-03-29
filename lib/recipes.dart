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
    this.unit = IngredientUnit.other,
  });

  String get unitString {
    String finalString = "$value $unit";
    if (value == 0) {
      finalString = "";
    } else if (value > 1 && unit.toString() != "") {
      finalString += "s";
    }
    return finalString.trim();
  }

  @override
  String toString() => name;

  // The ternary ensures that only liquid units can be converted to liquid units, and solid to solid
  bool _isConvertible(IngredientUnit unit2) {
    return unit.isSolid() == unit2.isSolid() &&
        unit.ratio != -1 &&
        unit2.ratio != -1;
  }

  double convert(IngredientUnit finalUnit) {
    return _isConvertible(finalUnit)
        ? (value * unit.ratio) / finalUnit.ratio
        : 0;
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

enum IngredientUnit {
  teaspoon(1),
  tablespoon(3),
  fluidOunce(6),
  cup(48),
  pint(96),
  quart(192),
  gallon(768),

  ounce(1),
  pound(16),

  other(-1);

  static List<IngredientUnit> get solidUnits => [ounce, pound];
  static List<IngredientUnit> get liquidUnits => [
    teaspoon,
    tablespoon,
    fluidOunce,
    cup,
    pint,
    quart,
    gallon,
    other,
  ];
  bool isSolid() => solidUnits.contains(this);
  @override
  String toString() => this == other ? "" : name;
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
