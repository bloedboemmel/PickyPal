import 'dart:convert';
import 'package:PickyPal/product.dart';
import 'package:PickyPal/userSettings.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'ProductChecker.dart';
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

class _Product extends State<ProductView> {
  final String barcode;

  _Product({required this.barcode});

  late String scanresult;

  @override
  void initState() {
    scanresult = "none"; //innical value of scan result is "none"
    super.initState();
  }

  Future<Product> getResult(String barcode) async {
    YESMAYBENO maybe = YESMAYBENO.maybe;
    if (barcode == "") {
      return Product(title: "title",
          barcode: "barcode",
          glutenfree: false,
          lactosefree: false,
          nutfree: false,
          vegan: maybe,
          vegeterian: maybe,
          palmoilfree: maybe);
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
      throw Exception('Failed to load product');
    }
  }

  @override
  Widget build(BuildContext context) {

    UserPreferences userPreferences = Provider.of<UserPreferences>(context);
    late Future<Widget> widget = PieChartProducts(userPreferences, barcode);
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Result'),
        ),
        body: Center(
          child: FutureBuilder<Widget>(
            future: widget,
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

  Future<Widget> PieChartProducts(UserPreferences userPreferences, String barcode) async {
    Product product = await getResult(barcode);
    List<Allergy> allergies = await checkAll(userPreferences, product);
    YESMAYBENO suitable = isSuitable(allergies);
    Map<String, Color> colorMap = {};
    Map<String, double> dataMap = {};
    List<PieChartSectionData> piechartsections =  List.empty(growable: true);
    for (var allergy in allergies) {
      colorMap[allergy.name] = allergy.color();
      dataMap[allergy.name] = 1.0;
      piechartsections.add(PieChartSectionData(
          color: allergy.color(),
          badgeWidget: Icon(allergy.icon)
      ));

    }
    return Stack(
      children: [
        PieChart(
          PieChartData(sections: piechartsections),
          swapAnimationDuration: Duration(milliseconds: 150), // Optional
          swapAnimationCurve: Curves.linear, // Optional
        ),
        Center(
          child: Container(
            height: MediaQuery.of(context).size.width / 2.5,
            width: MediaQuery.of(context).size.width / 2.5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black
            ),
            child: Padding(
              padding: EdgeInsets.all(2),
              child:  Container(
                height: MediaQuery.of(context).size.width / 2.5,
                width: MediaQuery.of(context).size.width / 2.5,
                decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: getColorForYesMaybeNo(suitable)
                ),
                child: Center(
                    child: Icon(
                      getIconForYesMaybeNo(suitable),
                      size: 40
                    )
                )

              ),
            ),
          ),
        ),
        /*Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem(Icons.nature, 'Gluten Free', allergies['gluten']!),
            SizedBox(width: 16.0),
            _buildLegendItem(Icons.spa, 'Vegan', allergies['vegan']!),
            SizedBox(width: 16.0),
            _buildLegendItem(Icons.local_dining, 'Dairy Free', allergies['dairy']!),
          ],
        ),*/
      ],
    );
  }
  YESMAYBENO isSuitable(List<Allergy> allergies){
    //If one of the allergies is no, the product is not suitable
    for (Allergy allergy in allergies) {
      if (allergy.suitable == YESMAYBENO.no) {
        return YESMAYBENO.no;
      }
    }
    //If one of the allergies is maybe, the product is maybe suitable
    for (Allergy allergy in allergies) {
      if (allergy.suitable == YESMAYBENO.maybe) {
        return YESMAYBENO.maybe;
      }
    }
    //If all of the allergies are yes, the product is suitable
    return YESMAYBENO.yes;
  }
  Future<List<Allergy>> checkAll(UserPreferences userPreferences, Product product) async {
    List<Allergy> allergies = List.empty(growable: true);
    if(userPreferences.glutenFree){
      allergies.add(Allergy(name: "Glutenfree", suitable: isGlutenFree(product), icon: Icons.local_pizza)) ;
    }
    if(userPreferences.lactoseFree){
      allergies.add(Allergy(name: "Lactosefree", suitable: isLactoseFree(product), icon:Icons.local_drink )) ;
    }
    if(userPreferences.nutFree){
      allergies.add(Allergy(name: "Nutfree", suitable: isNutFree(product), icon: Icons.do_not_disturb_on)) ;
    }
    if(userPreferences.vegetarian){
      allergies.add(Allergy(name: "Vegetarian", suitable: isVegetarian(product), icon: Icons.eco)) ;
    }
    if(userPreferences.vegan){
      allergies.add(Allergy(name: "Vegan", suitable: isVegan(product), icon: Icons.grass_outlined)) ;
    }
    if(userPreferences.palmOilFree){
      allergies.add(Allergy(name: "PalmOilFree", suitable: isPalmOilFree(product), icon: Icons.not_interested)) ;
    }
    return allergies;
  }
  YESMAYBENO isGlutenFree(Product product) {
    return product.glutenfree ? YESMAYBENO.yes : YESMAYBENO.no;
  }
  YESMAYBENO isLactoseFree(Product product) {
    return product.lactosefree ? YESMAYBENO.yes : YESMAYBENO.no;
  }
  YESMAYBENO isNutFree(Product product) {
    return product.nutfree ? YESMAYBENO.yes : YESMAYBENO.no;
  }
  YESMAYBENO isVegetarian(Product product) {
    return product.vegeterian;
  }
  YESMAYBENO isVegan(Product product) {
    if (product.vegeterian == YESMAYBENO.no || product.vegan == YESMAYBENO.no){
      return YESMAYBENO.no;
    }
    if (product.vegeterian == YESMAYBENO.maybe || product.vegan == YESMAYBENO.maybe){
      return YESMAYBENO.maybe;
    }
    return YESMAYBENO.yes;
  }
  YESMAYBENO isPalmOilFree(Product product) {
    return product.palmoilfree;
  }
}