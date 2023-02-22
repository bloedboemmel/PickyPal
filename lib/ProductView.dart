import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_3/product.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
class ProductViewClass extends StatelessWidget {
  final String barcode;
  const ProductViewClass({
    required Key key,
    required this.barcode,
  }) :super(key: key);
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: ProductView(barcode: barcode),
    );
  }
}
//apply this class on home: attribute at MaterialApp()
class ProductView extends StatefulWidget{
  final String barcode;
  const ProductView({super.key, required this.barcode});
  @override
  State<StatefulWidget> createState() {
    return _Product(barcode: barcode); //create state
  }
}

class _Product extends State<ProductView>{
  final String barcode;
  _Product({required this.barcode});
  late String scanresult;

  @override
  void initState() {
    scanresult = "none"; //innical value of scan result is "none"
    super.initState();
  }

  Future<Product> getResult(String barcode)async {
    if (barcode == ""){
      return Product(title: "title", barcode: barcode);
    }
    String uri = "https://world.openfoodfacts.org/api/v2/product/";
    final response = await http
        .get(Uri.parse(uri + barcode));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Product.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

    return Product(title: "title",
        barcode: "barcode",
        glutenfree: true,
        lactosefree: true,
        nutfree: true);
  }
  @override
  Widget build(BuildContext context) {
    late Future<Product> futureProduct;
    late Future<Widget> widget;
    Product normalProduct;
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Widget>(
            future: widget =  ShowText(barcode),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return snapshot.data;
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
  Future<Widget> ShowText(String barcode) async{
    Product product = await getResult(barcode);
    Color lightColor;
    IconData lightIcon;
    String text;

    // Check if any of the user's allergies match the product's allergies
    YESMAYBENO isSafeForAllergies = await compareProduct(product);

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
    return Column(
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
                  fontWeight: FontWeight.bold)
          )
        ]
    );
  }
  Future<YESMAYBENO> compareProduct (product)async {
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

}
