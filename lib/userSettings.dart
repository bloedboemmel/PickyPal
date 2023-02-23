
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late UserPreferences userPreferences;

  @override
  void initState() {
    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    userPreferences = Provider.of<UserPreferences>(context);
    return Scaffold(
      body: Column(
          children: [
      CheckboxListTile(
      title: Text('Gluten-free'),
      value: userPreferences.glutenFree,
      onChanged: (value) {
        setState(() {
          userPreferences.glutenFree = value!;
          userPreferences._saveAllergies();
        });
      },
    ),
    CheckboxListTile(
    title: Text('Lactose-free'),
    value: userPreferences.lactoseFree,
    onChanged: (value) {
    setState(() {
    userPreferences.lactoseFree = value!;
    userPreferences._saveAllergies();
    });
    },
    ),
    CheckboxListTile(
    title: Text('Nut-free'),
    value: userPreferences.nutFree,
    onChanged: (value) {
    setState(() {
    userPreferences.nutFree = value!;
    userPreferences._saveAllergies();
    });
    },
    ),
    CheckboxListTile(
    title: Text('Vegetarian'),
    value: userPreferences.vegetarian,
    onChanged: (value) {
    setState(() {
      userPreferences.vegetarian = value!;
      userPreferences._saveAllergies();
    });
    },
    ),
    CheckboxListTile(
    title: Text('Vegan'),
    value: userPreferences.vegan,
    onChanged: (value) {
    setState(() {
      userPreferences.vegan = value!;
      userPreferences._saveAllergies();
    });
    },
    ),
    CheckboxListTile(
    title: Text('Palm oil Free'),
      value: userPreferences.palmOilFree,
      onChanged: (value) {
        setState(() {
          userPreferences.palmOilFree = value!;
          userPreferences._saveAllergies();
        });
      },
    ),
          ],
      ),
    );
  }
}
class UserPreferences{

  bool glutenFree;
  bool lactoseFree;
  bool nutFree;
  bool vegetarian;
  bool vegan;
  bool palmOilFree;
  UserPreferences({required this.glutenFree,
    required this.lactoseFree,
    required this.nutFree,
    required this.vegan,
    required this.palmOilFree,
    required this.vegetarian});
  factory UserPreferences.empty(){
    return UserPreferences(glutenFree: false, lactoseFree: false, nutFree: false, vegan: false, palmOilFree: false, vegetarian: false);
  }
  void _saveAllergies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('glutenFree', glutenFree);
    await prefs.setBool('lactoseFree', lactoseFree);
    await prefs.setBool('nutFree', nutFree);
    await prefs.setBool('vegetarian', vegetarian);
    await prefs.setBool('vegan', vegan);
    await prefs.setBool('palmOilFree', palmOilFree);
  }


}

Future<UserPreferences> PreferencesFromStorage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return UserPreferences(
      glutenFree: prefs.getBool('glutenFree') ?? false,
      lactoseFree: prefs.getBool('lactoseFree') ?? false,
      nutFree: prefs.getBool('nutFree') ?? false,
      vegan: prefs.getBool('vegan') ?? false,
      palmOilFree: prefs.getBool('palmOilFree') ?? false,
      vegetarian: prefs.getBool('vegetarian') ?? false);
}


