import 'package:PickyPal/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:PickyPal/allergies_icons.dart';
class Allergy{
  YESMAYBENO suitable;
  String name;
  IconData icon;
  Allergy({required this.name, required this.suitable, this.icon = Allergies.gluten});
  factory Allergy.glutenfree({required BuildContext context, YESMAYBENO suitable= YESMAYBENO.no}){
    return Allergy(name: AppLocalizations.of(context)!.glutenFree, suitable: suitable, icon: Allergies.gluten);
  }
  factory Allergy.vegan({required BuildContext context, YESMAYBENO suitable= YESMAYBENO.no}){
    return Allergy(name: AppLocalizations.of(context)!.vegan, suitable: suitable, icon: Allergies.vegan);
  }
  factory Allergy.vegetarian({required BuildContext context, YESMAYBENO suitable= YESMAYBENO.no}){
    return Allergy(name: AppLocalizations.of(context)!.vegetarian, suitable: suitable, icon: Allergies.vegeterian);
  }
  factory Allergy.nutsFree({required BuildContext context, YESMAYBENO suitable= YESMAYBENO.no}){
    return Allergy(name: AppLocalizations.of(context)!.nutFree, suitable: suitable, icon: Allergies.nut);
  }
  factory Allergy.dairyFree({required BuildContext context, YESMAYBENO suitable= YESMAYBENO.no}){
    return Allergy(name: AppLocalizations.of(context)!.dairyFree, suitable: suitable, icon: Allergies.milk);
  }
  factory Allergy.palmOilFree({required BuildContext context, YESMAYBENO suitable= YESMAYBENO.no}){
    return Allergy(name: AppLocalizations.of(context)!.palmOilFree, suitable: suitable, icon: Allergies.palm);
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

