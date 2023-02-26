
import 'package:PickyPal/Allergy.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

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
  Widget build(BuildContext context){
    userPreferences = Provider.of<UserPreferences>(context);
    return Scaffold(
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text("Common"),
            tiles: [
              SettingsTile.switchTile(
                  initialValue: userPreferences.glutenFree,
                  onToggle: (value) {
                            setState(() {
                              userPreferences.glutenFree = value;
                              userPreferences._saveAllergies();
                            });},
                  title: Text(Allergy.glutenfree().name),
                  leading: Icon(Allergy.glutenfree().icon)
              ),
              SettingsTile.switchTile(
                  initialValue: userPreferences.lactoseFree,
                  onToggle: (value) {
                            setState(() {
                              userPreferences.lactoseFree = value;
                              userPreferences._saveAllergies();
                            });},
                  title: Text(Allergy.dairyFree().name),
                  leading: Icon(Allergy.dairyFree().icon)
              ),
              SettingsTile.switchTile(
                  initialValue: userPreferences.nutFree,
                  onToggle: (value) {
                            setState(() {
                              userPreferences.nutFree = value;
                              userPreferences._saveAllergies();
                            });},
                  title: Text(Allergy.nutsFree().name),
                  leading: Icon(Allergy.nutsFree().icon)
              ),
              SettingsTile.switchTile(
                  initialValue: userPreferences.vegetarian,
                  onToggle: (value) {
                            setState(() {
                              userPreferences.vegetarian = value;
                              userPreferences._saveAllergies();
                            });},
                  title: Text(Allergy.vegetarian().name),
                  leading: Icon(Allergy.vegetarian().icon)
              ),
              SettingsTile.switchTile(
                  initialValue: userPreferences.vegan,
                  onToggle: (value) {
                            setState(() {
                              userPreferences.vegan = value;
                              userPreferences._saveAllergies();
                            });},
                  title: Text(Allergy.vegan().name),
                  leading: Icon(Allergy.vegan().icon)
              ),
              SettingsTile.switchTile(
                  initialValue: userPreferences.palmOilFree,
                  onToggle: (value) {
                            setState(() {
                              userPreferences.palmOilFree = value;
                              userPreferences._saveAllergies();
                            });},
                  title: Text(Allergy.palmOilFree().name),
                  leading: Icon(Allergy.palmOilFree().icon)
              )
             ],

          ),
          SettingsSection(
              title: const Text("Funding"),
              tiles: [
                SettingsTile(
                      title: const Text('Please fund me'),
                        onPressed: (context) =>() {
                          const url = 'https://ko-fi.com/bloedboemmel';
                          launchUrl(Uri.parse(url));
                        },
                      leading: const Icon(Icons.coffee),
                      )
                ],
          )


          
        ],
      ),
    );
  }


  Widget build21(BuildContext context) {
    userPreferences = Provider.of<UserPreferences>(context);
    return Scaffold(
      body: Column(
          children: [
      CheckboxListTile(
      title: const Text('Gluten-free'),
      value: userPreferences.glutenFree,
      onChanged: (value) {
        setState(() {
          userPreferences.glutenFree = value!;
          userPreferences._saveAllergies();
        });
      },
    ),
    CheckboxListTile(
    title: const Text('Lactose-free'),
    value: userPreferences.lactoseFree,
    onChanged: (value) {
    setState(() {
    userPreferences.lactoseFree = value!;
    userPreferences._saveAllergies();
    });
    },
    ),
    CheckboxListTile(
    title: const Text('Nut-free'),
    value: userPreferences.nutFree,
    onChanged: (value) {
    setState(() {
    userPreferences.nutFree = value!;
    userPreferences._saveAllergies();
    });
    },
    ),
    CheckboxListTile(
    title: const Text('Vegetarian'),
    value: userPreferences.vegetarian,
    onChanged: (value) {
    setState(() {
      userPreferences.vegetarian = value!;
      userPreferences._saveAllergies();
    });
    },
    ),
    CheckboxListTile(
    title: const Text('Vegan'),
    value: userPreferences.vegan,
    onChanged: (value) {
    setState(() {
      userPreferences.vegan = value!;
      userPreferences._saveAllergies();
    });
    },
    ),
    CheckboxListTile(
    title: const Text('Palm oil Free'),
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


