import 'package:flutter/material.dart';
import 'package:flutter_barcode_3/product.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Allergy{
  YESMAYBENO suitable;
  String name;
  Allergy({required this.name, required this.suitable});
  MaterialColor color() {
    if (suitable == YESMAYBENO.yes) {
      return Colors.green;
    }
    if (suitable == YESMAYBENO.maybe) {
      return Colors.orange;
    }
    return Colors.red;
  }
}

YESMAYBENO isSuitable(List<Allergy> allergies){
  //If one of the allergies is no, the product is not suitable
  for (Allergy allergy in allergies) {
    if (allergy.suitable == YESMAYBENO.no) {
      return YESMAYBENO.no;
    }
  }
  //If one of the allergies is maybe, the product is maybe suitable
  for (Allergy allergy in allergies) {
    if (allergy.suitable == YESMAYBENO.maybe) {
      return YESMAYBENO.maybe;
    }
  }
  //If all of the allergies are yes, the product is suitable
  return YESMAYBENO.yes;
}
Future<List<Allergy>> checkAll(Product product) async {
  List<Allergy> allergies = List.empty(growable: true);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool _glutenFree = prefs.getBool('glutenFree') ?? false;
  bool _lactoseFree = prefs.getBool('lactoseFree') ?? false;
  bool _nutFree = prefs.getBool('nutFree') ?? false;
  bool _vegetarian = prefs.getBool('vegetarian') ?? false;
  bool _vegan = prefs.getBool('vegan') ?? false;
  bool _palmOilFree = prefs.getBool('palmOilFree') ?? false;
  if(_glutenFree){
    allergies.add(Allergy(name: "Glutenfree", suitable: isGlutenFree(product))) ;
  }
  if(_lactoseFree){
    allergies.add(Allergy(name: "Lactosefree", suitable: isLactoseFree(product))) ;
  }
  if(_nutFree){
    allergies.add(Allergy(name: "Nutfree", suitable: isNutFree(product))) ;
  }
  if(_vegetarian){
    allergies.add(Allergy(name: "Vegetarian", suitable: isVegetarian(product))) ;
  }
  if(_vegan){
    allergies.add(Allergy(name: "Vegan", suitable: isVegan(product))) ;
  }
  if(_palmOilFree){
    allergies.add(Allergy(name: "PalmOilFree", suitable: isPalmOilFree(product))) ;
  }
  return allergies;
}
YESMAYBENO isGlutenFree(Product product) {
  return product.glutenfree ? YESMAYBENO.yes : YESMAYBENO.no;
}
YESMAYBENO isLactoseFree(Product product) {
  return product.lactosefree ? YESMAYBENO.yes : YESMAYBENO.no;
}
YESMAYBENO isNutFree(Product product) {
  return product.nutfree ? YESMAYBENO.yes : YESMAYBENO.no;
}
YESMAYBENO isVegetarian(Product product) {
  return product.vegeterian;
}
YESMAYBENO isVegan(Product product) {
  if (product.vegeterian == YESMAYBENO.no || product.vegan == YESMAYBENO.no){
    return YESMAYBENO.no;
  }
  if (product.vegeterian == YESMAYBENO.maybe || product.vegan == YESMAYBENO.maybe){
    return YESMAYBENO.maybe;
  }
  return YESMAYBENO.yes;
}
YESMAYBENO isPalmOilFree(Product product) {
  return product.palmoilfree;
}