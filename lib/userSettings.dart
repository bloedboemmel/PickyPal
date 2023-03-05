
import 'package:PickyPal/FoodPreference.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    // String language = "English";
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
                title:  Text(AppLocalizations.of(context)!.common),
                tiles: [
                  SettingsTile.switchTile(
                      initialValue: userPreferences.glutenFree,
                      onToggle: (value) {
                                setState(() {
                                  userPreferences.glutenFree = value;
                                  userPreferences._saveFoodPrefs();
                                });},
                      title: Text(FoodPreference.glutenfree(context: context).name),
                      leading: Icon(FoodPreference.glutenfree(context: context).icon)
                  ),
                  SettingsTile.switchTile(
                      initialValue: userPreferences.lactoseFree,
                      onToggle: (value) {
                                setState(() {
                                  userPreferences.lactoseFree = value;
                                  userPreferences._saveFoodPrefs();
                                });},
                      title: Text(FoodPreference.dairyFree(context: context).name),
                      leading: Icon(FoodPreference.dairyFree(context: context).icon)
                  ),
                  SettingsTile.switchTile(
                      initialValue: userPreferences.nutFree,
                      onToggle: (value) {
                                setState(() {
                                  userPreferences.nutFree = value;
                                  userPreferences._saveFoodPrefs();
                                });},
                      title: Text(FoodPreference.nutsFree(context: context).name),
                      leading: Icon(FoodPreference.nutsFree(context: context).icon)
                  ),
                  SettingsTile.switchTile(
                      initialValue: userPreferences.vegetarian,
                      onToggle: (value) {
                                setState(() {
                                  userPreferences.vegetarian = value;
                                  userPreferences._saveFoodPrefs();
                                });},
                      title: Text(FoodPreference.vegetarian(context: context).name),
                      leading: Icon(FoodPreference.vegetarian(context: context).icon)
                  ),
                  SettingsTile.switchTile(
                      initialValue: userPreferences.vegan,
                      onToggle: (value) {
                                setState(() {
                                  userPreferences.vegan = value;
                                  userPreferences._saveFoodPrefs();
                                });},
                      title: Text(FoodPreference.vegan(context: context).name),
                      leading: Icon(FoodPreference.vegan(context: context).icon)
                  ),
                  SettingsTile.switchTile(
                      initialValue: userPreferences.palmOilFree,
                      onToggle: (value) {
                                setState(() {
                                  userPreferences.palmOilFree = value;
                                  userPreferences._saveFoodPrefs();
                                });},
                      title: Text(FoodPreference.palmOilFree(context: context).name),
                      leading: Icon(FoodPreference.palmOilFree(context: context).icon)
                  ),
                  SettingsTile.switchTile(
                      initialValue: userPreferences.soyFree,
                      onToggle: (value) {
                        setState(() {
                          userPreferences.soyFree = value;
                          userPreferences._saveFoodPrefs();
                        });},
                      title: Text(FoodPreference.soyFree(context: context).name),
                      leading: Icon(FoodPreference.soyFree(context: context).icon)
                  ),
                  SettingsTile.switchTile(
                      initialValue: userPreferences.glutamateFree,
                      onToggle: (value) {
                        setState(() {
                          userPreferences.glutamateFree = value;
                          userPreferences._saveFoodPrefs();
                        });},
                      title: Text(FoodPreference.glutamateFree(context: context).name),
                      leading: Icon(FoodPreference.glutamateFree(context: context).icon)
                  )
                 ],

              ),
              SettingsSection(
                  title: Text(AppLocalizations.of(context)!.funding),
                  tiles: [
                    SettingsTile(
                          title:  Text(AppLocalizations.of(context)!.pleaseFund),
                            onPressed: (BuildContext context) {
                                const url = 'https://ko-fi.com/bloedboemmel';
                                launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);

                            },
                          leading: const Icon(Icons.coffee),
                          )
                    ],
              )



            ],
          )
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
  bool soyFree;
  bool glutamateFree;
  ThemeMode themeMode;
  UserPreferences({required this.glutenFree,
    required this.lactoseFree,
    required this.nutFree,
    required this.vegan,
    required this.palmOilFree,
    required this.vegetarian,
    required this.soyFree,
    required this.glutamateFree,
    required this.themeMode});
  factory UserPreferences.empty(){
    return UserPreferences(glutenFree: false, lactoseFree: false, nutFree: false,
        vegan: false, palmOilFree: false, vegetarian: false, soyFree: false,
        glutamateFree: false,themeMode:ThemeMode.system);
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


