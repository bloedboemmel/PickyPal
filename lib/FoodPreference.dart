// ignore_for_file: file_names

import 'package:PickyPal/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:PickyPal/food_icons.dart';
class FoodPreference{
  YESMAYBENO suitable;
  String name;
  IconData icon;
  FoodPreference({required this.name, required this.suitable, this.icon = FoodIcons.gluten});
  factory FoodPreference.glutenfree({required BuildContext context, YESMAYBENO suitable= YESMAYBENO.no}){
    return FoodPreference(name: AppLocalizations.of(context)!.glutenFree, suitable: suitable, icon: FoodIcons.gluten);
  }
  factory FoodPreference.vegan({required BuildContext context, YESMAYBENO suitable= YESMAYBENO.no}){
    return FoodPreference(name: AppLocalizations.of(context)!.vegan, suitable: suitable, icon: FoodIcons.vegan);
  }
  factory FoodPreference.vegetarian({required BuildContext context, YESMAYBENO suitable= YESMAYBENO.no}){
    return FoodPreference(name: AppLocalizations.of(context)!.vegetarian, suitable: suitable, icon: FoodIcons.vegeterian);
  }
  factory FoodPreference.nutsFree({required BuildContext context, YESMAYBENO suitable= YESMAYBENO.no}){
    return FoodPreference(name: AppLocalizations.of(context)!.nutFree, suitable: suitable, icon: FoodIcons.nut);
  }
  factory FoodPreference.dairyFree({required BuildContext context, YESMAYBENO suitable= YESMAYBENO.no}){
    return FoodPreference(name: AppLocalizations.of(context)!.dairyFree, suitable: suitable, icon: FoodIcons.milk);
  }
  factory FoodPreference.palmOilFree({required BuildContext context, YESMAYBENO suitable= YESMAYBENO.no}){
    return FoodPreference(name: AppLocalizations.of(context)!.palmOilFree, suitable: suitable, icon: FoodIcons.palm);
  }
  factory FoodPreference.soyFree({required BuildContext context, YESMAYBENO suitable= YESMAYBENO.no}){
    return FoodPreference(name: AppLocalizations.of(context)!.soyFree, suitable: suitable, icon: FoodIcons.soy);
  }
  factory FoodPreference.glutamateFree({required BuildContext context, YESMAYBENO suitable= YESMAYBENO.no}){
    return FoodPreference(name: AppLocalizations.of(context)!.glutamateFree, suitable: suitable, icon: FoodIcons.glutamate);
  }
  factory FoodPreference.carbohydrates({required BuildContext context, YESMAYBENO suitable= YESMAYBENO.no}){
    return FoodPreference(name: AppLocalizations.of(context)!.carbohydrates, suitable: suitable, icon: FoodIcons.kcal);
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

