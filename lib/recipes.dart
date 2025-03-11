import 'dart:collection';
import 'package:flutter/widgets.dart';

class Recipe {
  String name;
  List<String> steps;
  // Amount was created for easy conversion between units. 
  // Some recipes will use different units for the same item, so converting it to one unit when combining ingredients is important
  Map<String, Amount> ingredients; 
  // Acceptable tags include: vegetarian, vegan, pescetarian, saved and favorite,
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

class Amount {
  double number;
  String type;
  String unit;

  Amount({
    required this.number,
    this.type = "solid",
    this.unit = "whole",

  });

  // TODO: Methods for conversion between liquid units (tbsp, tsp, cup, pint, quart, gallon, to whole)
}