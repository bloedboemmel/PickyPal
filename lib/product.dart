import 'dart:convert';
import 'package:http/http.dart' as http;

enum YESMAYBENO{
  yes,
  maybe,
  no

}
YESMAYBENO suitableFor(List<dynamic> list, String str){
  if (list.contains("en:maybe-$str") || list.contains("en:$str-status-unknown")){
    return YESMAYBENO.maybe;
  }
  if (list.contains("en:$str")){
    return YESMAYBENO.yes;
  }
  if (list.contains("en:non-$str")){
    return YESMAYBENO.no;
  }
  return YESMAYBENO.maybe;

}
YESMAYBENO ispalmoilfree(List<dynamic> list){
  if(list.contains("en:palm-oil-free")){
    return YESMAYBENO.yes;
  }
  if(list.contains("en:palm-oil")){
    return YESMAYBENO.no;
  }
  return YESMAYBENO.maybe;
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
  // https://world.openfoodfacts.org/api/v2/product/4008452027602?fields=allergens,generic_name,labels,ingredients_analysis_tags
  String tags = "?fields=allergens,ingredients_analysis_tags,generic_name,labels,code,product_name,allergens_from_ingredients";
  final response = await http
      .get(Uri.parse(uri + barcode + tags));

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
class Product {
  String title = "";
  String barcode = "";
  bool glutenfree = false;
  bool lactosefree = false;
  bool nutfree = false;
  YESMAYBENO vegan = YESMAYBENO.maybe;
  YESMAYBENO vegeterian =   YESMAYBENO.maybe;
  YESMAYBENO palmoilfree = YESMAYBENO.maybe;
  Product({required this.title, required this.barcode, required this.glutenfree,
    required this.lactosefree, required this.nutfree, required this.vegan, required this.vegeterian, required this.palmoilfree
  });
  bool isAllFree(){
    return nutfree && glutenfree && lactosefree;

  }
  factory Product.fromJson(Map<String, dynamic> json) {
    String allergens = json['product']['allergens'] + ', ' + json['product']['allergens_from_ingredients'];
    List<dynamic> list = json['product']["ingredients_analysis_tags"];

    return Product(
      title: json['product']['product_name'],
      barcode: json['code'],
      glutenfree: !allergens.contains('gluten'),
      nutfree: !allergens.contains('peanuts'),
      lactosefree: !allergens.contains('milk'),
      vegan: suitableFor(list, "vegan"),
      vegeterian: suitableFor(list, "vegetarian"),
      palmoilfree: ispalmoilfree(list)


    );
  }
}
