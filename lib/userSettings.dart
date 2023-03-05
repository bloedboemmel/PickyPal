
// ignore_for_file: non_constant_identifier_names, file_names

import 'package:PickyPal/FoodPreference.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
//import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:numberpicker/numberpicker.dart';
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late UserPreferences userPreferences;
  late Text carbohydrateNumberText;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userPreferences = Provider.of<UserPreferences>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.settings),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SettingsList(
          sections: [
            SettingsSection(
              title: Text(AppLocalizations.of(context)!.common),
              tiles: [
                SettingsTile.switchTile(
                    initialValue: userPreferences.glutenFree,
                    onToggle: (value) {
                      setState(() {
                        userPreferences.glutenFree = value;
                        userPreferences._saveFoodPrefs();
                      });
                    },
                    title: Text(FoodPreference
                        .glutenfree(context: context)
                        .name),
                    leading: Icon(FoodPreference
                        .glutenfree(context: context)
                        .icon)
                ),
                SettingsTile.switchTile(
                    initialValue: userPreferences.lactoseFree,
                    onToggle: (value) {
                      setState(() {
                        userPreferences.lactoseFree = value;
                        userPreferences._saveFoodPrefs();
                      });
                    },
                    title: Text(FoodPreference
                        .dairyFree(context: context)
                        .name),
                    leading: Icon(FoodPreference
                        .dairyFree(context: context)
                        .icon)
                ),
                SettingsTile.switchTile(
                    initialValue: userPreferences.nutFree,
                    onToggle: (value) {
                      setState(() {
                        userPreferences.nutFree = value;
                        userPreferences._saveFoodPrefs();
                      });
                    },
                    title: Text(FoodPreference
                        .nutsFree(context: context)
                        .name),
                    leading: Icon(FoodPreference
                        .nutsFree(context: context)
                        .icon)
                ),
                SettingsTile.switchTile(
                    initialValue: userPreferences.vegetarian,
                    onToggle: (value) {
                      setState(() {
                        userPreferences.vegetarian = value;
                        userPreferences._saveFoodPrefs();
                      });
                    },
                    title: Text(FoodPreference
                        .vegetarian(context: context)
                        .name),
                    leading: Icon(FoodPreference
                        .vegetarian(context: context)
                        .icon)
                ),
                SettingsTile.switchTile(
                    initialValue: userPreferences.vegan,
                    onToggle: (value) {
                      setState(() {
                        userPreferences.vegan = value;
                        userPreferences._saveFoodPrefs();
                      });
                    },
                    title: Text(FoodPreference
                        .vegan(context: context)
                        .name),
                    leading: Icon(FoodPreference
                        .vegan(context: context)
                        .icon)
                ),
                SettingsTile.switchTile(
                    initialValue: userPreferences.palmOilFree,
                    onToggle: (value) {
                      setState(() {
                        userPreferences.palmOilFree = value;
                        userPreferences._saveFoodPrefs();
                      });
                    },
                    title: Text(FoodPreference
                        .palmOilFree(context: context)
                        .name),
                    leading: Icon(FoodPreference
                        .palmOilFree(context: context)
                        .icon)
                ),
                SettingsTile.switchTile(
                    initialValue: userPreferences.soyFree,
                    onToggle: (value) {
                      setState(() {
                        userPreferences.soyFree = value;
                        userPreferences._saveFoodPrefs();
                      });
                    },
                    title: Text(FoodPreference
                        .soyFree(context: context)
                        .name),
                    leading: Icon(FoodPreference
                        .soyFree(context: context)
                        .icon)
                ),
                SettingsTile.switchTile(
                    initialValue: userPreferences.glutamateFree,
                    onToggle: (value) {
                      setState(() {
                        userPreferences.glutamateFree = value;
                        userPreferences._saveFoodPrefs();
                      });
                    },
                    title: Text(FoodPreference
                        .glutamateFree(context: context)
                        .name),
                    leading: Icon(FoodPreference
                        .glutamateFree(context: context)
                        .icon)
                ),
                SettingsTile.switchTile(
                    initialValue: userPreferences.carbohydrates,
                    onToggle: (value) {
                      setState(() {
                        userPreferences.carbohydrates = value;
                        userPreferences._saveFoodPrefs();
                      });
                    },
                    title: Text(FoodPreference
                        .carbohydrates(context: context)
                        .name),
                    leading: Icon(FoodPreference
                        .carbohydrates(context: context)
                        .icon),
                ),

                SettingsTile(title: Text(AppLocalizations.of(context)!.carbohydrateslimit),
                    enabled: userPreferences.carbohydrates,
                    onPressed:  (context) => carbonPicker(context),
                    leading: const Icon(Icons.numbers),
                    trailing: Text("${userPreferences.carbohydrates?userPreferences.carbohydrateslimit:''}"),
                )
              ],

            ),
            /*SettingsSection(
              title: Text(AppLocalizations.of(context)!.funding),
              tiles: [
                SettingsTile(
                  title: Text(AppLocalizations.of(context)!.pleaseFund),
                  onPressed: (BuildContext context) {
                    const url = 'https://ko-fi.com/bloedboemmel';
                    launchUrl(
                        Uri.parse(url), mode: LaunchMode.externalApplication);
                  },
                  leading: const Icon(Icons.coffee),
                )
              ],
            )
            */


          ],
        )
    );
  }

  Future carbonPicker(BuildContext context) async{
    int tempValue = userPreferences.carbohydrateslimit;

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
                 return AlertDialog(
                   title: Text(AppLocalizations.of(context)!.carbohydrateslimit),
                    content:NumberPicker(
                              minValue: 0,
                              maxValue: 100,
                              value: tempValue,
                              infiniteLoop: true,
                              step: 10,
                              onChanged: (value) =>
                                  setState(() =>
                                  tempValue = value),
                            ),
                      actions:[
                      TextButton(
                        child: Text(AppLocalizations.of(context)!.cancel),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text(AppLocalizations.of(context)!.ok),
                        onPressed: () {
                          userPreferences.carbohydrateslimit = tempValue;
                          userPreferences._saveFoodPrefs();
                          Navigator.of(context).pop();
                        },
                      ),
                    ]
                );
              }
          );
        }
        );
    setState(() {
      userPreferences = userPreferences;
    });
  }
}



class UserPreferences{

  bool glutenFree;
  bool lactoseFree;
  bool nutFree;
  bool vegetarian;
  bool vegan;
  bool palmOilFree;
  bool soyFree;
  bool glutamateFree;
  bool carbohydrates;
  int carbohydrateslimit;
  ThemeMode themeMode;
  UserPreferences({required this.glutenFree,
    required this.lactoseFree,
    required this.nutFree,
    required this.vegan,
    required this.palmOilFree,
    required this.vegetarian,
    required this.soyFree,
    required this.glutamateFree,
    required this.themeMode,
    required this.carbohydrates,
    required this.carbohydrateslimit});
  factory UserPreferences.empty(){
    return UserPreferences(glutenFree: false, lactoseFree: false, nutFree: false,
        vegan: false, palmOilFree: false, vegetarian: false, soyFree: false,
        glutamateFree: false, carbohydrates: false, carbohydrateslimit: 10, themeMode:ThemeMode.system);
  }
  void _saveFoodPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('glutenFree', glutenFree);
    await prefs.setBool('lactoseFree', lactoseFree);
    await prefs.setBool('nutFree', nutFree);
    await prefs.setBool('vegetarian', vegetarian);
    await prefs.setBool('vegan', vegan);
    await prefs.setBool('palmOilFree', palmOilFree);
    await prefs.setBool('soyFree', soyFree);
    await prefs.setBool('glutamateFree', glutamateFree);
    await prefs.setBool('carbohydrates', carbohydrates);
    await prefs.setInt('carbohydrateslimit', carbohydrateslimit);
    await prefs.setString('appMode', themeModeToString(themeMode));
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
      vegetarian: prefs.getBool('vegetarian') ?? false,
      soyFree: prefs.getBool('soyFree') ?? false,
      glutamateFree: prefs.getBool('glutamateFree') ?? false,
      carbohydrates: prefs.getBool('carbohydrates') ?? false,
      carbohydrateslimit: prefs.getInt('carbohydrateslimit') ?? 10,
      themeMode: stringToThemeMode(prefs.getString('themeMode')));
}
ThemeMode stringToThemeMode(String? theme){
  if (theme == null){
    return ThemeMode.system;
  }
  if (theme == "dark"){
    return ThemeMode.dark;
  }
  if (theme == "light"){
    return ThemeMode.light;
  }
  return ThemeMode.system;
}
String themeModeToString(ThemeMode? theme){
  if (theme == null){
    return "system";
  }
  if (theme == ThemeMode.dark){
    return "dark";
  }
  if (theme == ThemeMode.light){
    return "light" ;
  }
  return "system";
}


