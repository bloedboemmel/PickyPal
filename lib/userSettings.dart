
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _glutenFree = false;
  bool _lactoseFree = false;
  bool _nutFree = false;
  bool _vegetarian = false;
  bool _vegan = false;
  bool _palmOilFree = false;

  @override
  void initState() {
    super.initState();
    _loadAllergies();
  }

  void _loadAllergies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _glutenFree = prefs.getBool('glutenFree') ?? false;
      _lactoseFree = prefs.getBool('lactoseFree') ?? false;
      _nutFree = prefs.getBool('nutFree') ?? false;
      _vegetarian = prefs.getBool('vegetarian') ?? false;
      _vegan = prefs.getBool('vegan') ?? false;
      _palmOilFree = prefs.getBool('palmOilFree') ?? false;
    });
  }

  void _saveAllergies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('glutenFree', _glutenFree);
    await prefs.setBool('lactoseFree', _lactoseFree);
    await prefs.setBool('nutFree', _nutFree);
    await prefs.setBool('vegetarian', _vegetarian);
    await prefs.setBool('vegan', _vegan);
    await prefs.setBool('palmOilFree', _palmOilFree);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children: [
      CheckboxListTile(
      title: Text('Gluten-free'),
      value: _glutenFree,
      onChanged: (value) {
        setState(() {
          _glutenFree = value!;
          _saveAllergies();
        });
      },
    ),
    CheckboxListTile(
    title: Text('Lactose-free'),
    value: _lactoseFree,
    onChanged: (value) {
    setState(() {
    _lactoseFree = value!;
    _saveAllergies();
    });
    },
    ),
    CheckboxListTile(
    title: Text('Nut-free'),
    value: _nutFree,
    onChanged: (value) {
    setState(() {
    _nutFree = value!;
    _saveAllergies();
    });
    },
    ),
    CheckboxListTile(
    title: Text('Vegetarian'),
    value: _vegetarian,
    onChanged: (value) {
    setState(() {
    _vegetarian = value!;
    _saveAllergies();
    });
    },
    ),
    CheckboxListTile(
    title: Text('Vegan'),
    value: _vegan,
    onChanged: (value) {
    setState(() {
    _vegan = value!;
    _saveAllergies();
    });
    },
    ),
    CheckboxListTile(
    title: Text('Palm oil Free'),
      value: _palmOilFree,
      onChanged: (value) {
        setState(() {
          _palmOilFree = value!;
          _saveAllergies();
        });
      },
    ),
          ],
      ),
    );
  }

  Widget settings(BuildContext context) {
    return  Column(
        children: [
          CheckboxListTile(
            title: Text('Gluten-free'),
            value: _glutenFree,
            onChanged: (value) {
              setState(() {
                _glutenFree = value!;
                _saveAllergies();
              });
            },
          ),
          CheckboxListTile(
            title: Text('Lactose-free'),
            value: _lactoseFree,
            onChanged: (value) {
              setState(() {
                _lactoseFree = value!;
                _saveAllergies();
              });
            },
          ),
          CheckboxListTile(
            title: Text('Nut-free'),
            value: _nutFree,
            onChanged: (value) {
              setState(() {
                _nutFree = value!;
                _saveAllergies();
              });
            },
          ),
          CheckboxListTile(
            title: Text('Vegetarian'),
            value: _vegetarian,
            onChanged: (value) {
              setState(() {
                _vegetarian = value!;
                _saveAllergies();
              });
            },
          ),
          CheckboxListTile(
            title: Text('Vegan'),
            value: _vegan,
            onChanged: (value) {
              setState(() {
                _vegan = value!;
                _saveAllergies();
              });
            },
          ),
          CheckboxListTile(
            title: Text('Palm oil Free'),
            value: _palmOilFree,
            onChanged: (value) {
              setState(() {
                _palmOilFree = value!;
                _saveAllergies();
              });
            },
          ),
        ],
      );
  }
}
