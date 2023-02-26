import 'package:PickyPal/product.dart';
import 'package:flutter/material.dart';
class Allergy{
  YESMAYBENO suitable;
  String name;
  IconData icon;
  Allergy({required this.name, required this.suitable, this.icon = Icons.snowing});
  factory Allergy.glutenfree({YESMAYBENO suitable= YESMAYBENO.no}){
    return Allergy(name: "GlutenFree", suitable: suitable, icon: Icons.local_pizza);
  }
  factory Allergy.vegan({YESMAYBENO suitable= YESMAYBENO.no}){
    return Allergy(name: "Vegan", suitable: suitable, icon: Icons.grass_outlined);
  }
  factory Allergy.vegetarian({YESMAYBENO suitable= YESMAYBENO.no}){
    return Allergy(name: "Vegetarian", suitable: suitable, icon: Icons.eco);
  }
  factory Allergy.nutsFree({YESMAYBENO suitable= YESMAYBENO.no}){
    return Allergy(name: "Nuts Free", suitable: suitable, icon: Icons.emoji_food_beverage);
  }
  factory Allergy.dairyFree({YESMAYBENO suitable= YESMAYBENO.no}){
    return Allergy(name: "Dairy Free", suitable: suitable, icon: Icons.local_drink);
  }
  factory Allergy.palmOilFree({YESMAYBENO suitable= YESMAYBENO.no}){
    return Allergy(name: "Palm Oil Free", suitable: suitable, icon: Icons.not_interested);
  }
  
  color()=> getColorForYesMaybeNo(suitable);
}
MaterialColor getColorForYesMaybeNo(YESMAYBENO yesmaybeno) {
  if (yesmaybeno == YESMAYBENO.yes) {
    return Colors.green;
  }
  if (yesmaybeno == YESMAYBENO.maybe) {
    return Colors.orange;
  }
  return Colors.red;
}
IconData getIconForYesMaybeNo(YESMAYBENO yesmaybeno){
  if (yesmaybeno == YESMAYBENO.yes) {
    return Icons.check;
  }
  if (yesmaybeno == YESMAYBENO.maybe) {
    return Icons.warning;
  }
  return Icons.no_food;
}

