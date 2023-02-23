import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_3/ProductChecker.dart';
import 'package:flutter_barcode_3/product.dart';
import 'package:http/http.dart' as http;
import 'package:pie_chart/pie_chart.dart';
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
    late Future<Widget> widget = PieChartProducts(barcode);
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

  Future<Widget> PieChartProducts(String barcode) async {
    Product product = await getResult(barcode);
    List<Allergy> allergies = await checkAll(product);
    YESMAYBENO suitable = isSuitable(allergies);
    Map<String, Color> colorMap = {};
    Map<String, double> dataMap = {};
    for (var allergy in allergies) {
      colorMap[allergy.name] = allergy.color();
      dataMap[allergy.name] = 1.0;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PieChart(
          dataMap: dataMap,
          colorList: colorMap.values.toList(),
          chartType: ChartType.disc,
          chartRadius: MediaQuery
              .of(context)
              .size
              .width / 3,
          centerText: suitable == YESMAYBENO.yes ? 'Suitable' : 'Not Suitable',
          legendOptions: LegendOptions(
            showLegendsInRow: false,
            legendPosition: LegendPosition.right,
            showLegends: true,
            legendTextStyle: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          chartValuesOptions: ChartValuesOptions(
            showChartValueBackground: false,
            showChartValues: false,
          ),
          initialAngleInDegree: 0,
          animationDuration: Duration(milliseconds: 800),
        ),
        SizedBox(height: 16.0),
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
}