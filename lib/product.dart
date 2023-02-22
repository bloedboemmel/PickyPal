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
    String allergens = json['product']['allergens'];
    List<dynamic> list = json['product']["ingredients_analysis_tags"];

    return Product(
      title: json['product']['product_name'],
      barcode: json['code'],
      glutenfree: !allergens.contains('gluten'),
      nutfree: !allergens.contains('nut'),
      lactosefree: !allergens.contains('lactose'),
      vegan: suitableFor(list, "vegan"),
      vegeterian: suitableFor(list, "vegeterian"),
      palmoilfree: suitableFor(list, "palm-oil-free")


    );
  }
}
