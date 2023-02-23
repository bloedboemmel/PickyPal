import 'package:flutter/material.dart';
import 'package:flutter_barcode_3/product.dart';
class Allergy{
  YESMAYBENO suitable;
  String name;
  IconData icon;
  Allergy({required this.name, required this.suitable, this.icon = Icons.snowing});
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

