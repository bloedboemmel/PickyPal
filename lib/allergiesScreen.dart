/*
import 'package:flutter/material.dart';

import 'package:flutter_barcode_3/product.dart';
import 'package:flutter_barcode_3/userSettings.dart';

import 'package:shared_preferences/shared_preferences.dart';
class TrafficLightsScreen extends StatelessWidget {
  final Set<String> userAllergies;
  final Set<String> productAllergies;

  TrafficLightsScreen({
    required this.userAllergies,
    required this.productAllergies,
  });

  @override
  Widget build(BuildContext context) {
    Color lightColor;
    IconData lightIcon;
    String text;

    // Check if any of the user's allergies match the product's allergies
    YESMAYBENO isSafeForAllergies = compareProduct(product) as YESMAYBENO;

    // Determine which color and icon to use based on whether the product is safe
    if (isSafeForAllergies == YESMAYBENO.yes) {
      lightColor = Colors.green;
      lightIcon = Icons.check;
      text = 'Safe for allergies';
    } else if (isSafeForAllergies == YESMAYBENO.no) {
      lightColor = Colors.red;
      lightIcon = Icons.warning;
      text = 'Not safe for allergies';
    }
    else {
      lightColor = Colors.orange;
      lightIcon = Icons.question_mark;
      text = 'Not sure';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              lightIcon,
              color: lightColor,
              size: 150,
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
Future<YESMAYBENO> compareProduct (Product product) async {
  bool _glutenFree = false;
  bool _lactoseFree = false;
  bool _nutFree = false;
  bool _vegetarian = false;
  bool _vegan = false;
  bool _palmOilFree = false;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  _glutenFree = prefs.getBool('glutenFree') ?? false;
  _lactoseFree = prefs.getBool('lactoseFree') ?? false;
  _nutFree = prefs.getBool('nutFree') ?? false;
  _vegetarian = prefs.getBool('vegetarian') ?? false;
  _vegan = prefs.getBool('vegan') ?? false;
  _palmOilFree = prefs.getBool('palmOilFree') ?? false;
  if (_glutenFree && !product.glutenfree){
    return YESMAYBENO.no;
  }
  if (_vegan && !(product.vegeterian == YESMAYBENO.no) && !(product.vegan == YESMAYBENO.no)){
    return YESMAYBENO.no;

  }
  if (_vegetarian && !(product.vegeterian == YESMAYBENO.no)){
    return YESMAYBENO.no;
  }
  if (_vegan && !(product.vegeterian == YESMAYBENO.maybe) && !(product.vegan == YESMAYBENO.maybe)){
    return YESMAYBENO.maybe;

  }
  if (_lactoseFree && !product.lactosefree){
    return YESMAYBENO.no;
  }
  if (_palmOilFree && !(product.palmoilfree == YESMAYBENO.yes)){
    return product.palmoilfree;
  }
  if (_nutFree && !product.nutfree){
    return YESMAYBENO.no;
  }
  return YESMAYBENO.yes;
}
*/
