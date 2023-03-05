import 'package:PickyPal/product.dart';
import 'package:PickyPal/userSettings.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:PickyPal/FoodPreference.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class ProductViewClass extends StatelessWidget {
  final String barcode;

  const ProductViewClass({
    required Key key,
    required this.barcode,
  }) :super(key: key);
  @override
  Widget build(BuildContext context) {
    return ProductView(barcode: barcode);
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



  @override
  Widget build(BuildContext context) {

    UserPreferences userPreferences = Provider.of<UserPreferences>(context);
    late Future<Widget> widget = PieChartProducts(userPreferences, barcode);
    return Scaffold(
        body: FutureBuilder<Widget>(
            future: widget,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return snapshot.data;
              } else if (snapshot.hasError) {
                return productNotFound(context);
              }

              // By default, show a loading spinner.
              return const Center(child: CircularProgressIndicator());
            },
          )
    );
  }
  Widget productNotFound(BuildContext context){
    return Stack(
        children: [
          Align(
              child:
              Stack(
                alignment: Alignment.center,
                children:[
                    Container(
                        height: MediaQuery.of(context).size.width / 2.5,
                        width: MediaQuery.of(context).size.width / 2.5,
                        decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black
                            ),
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child:  Container(
                              height: MediaQuery.of(context).size.width / 2.5,
                              width: MediaQuery.of(context).size.width / 2.5,
                              decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: getColorForYesMaybeNo(YESMAYBENO.maybe)
                              ),
                              child: const Center(
                                    child: Icon(
                                      Icons.question_mark,
                                      size: 40
                                    )
                              )

                          ),
                        ),
                    )
                ],
              )
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).size.height * 0.2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.noProductFound,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    const url = 'https://world.openfoodfacts.org/cgi/product.pl';
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context)!.addProduct,
                    style: const TextStyle(
                      fontSize: 18,
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          )
        ]
    );
  }

  Future<Widget> PieChartProducts(UserPreferences userPreferences, String barcode) async {
    Product product = await getResult(barcode);
    List<FoodPreference> foodPrefs = await checkAll(userPreferences, product);
    YESMAYBENO suitable = isSuitable(foodPrefs);
    List<PieChartSectionData> piechartsections =  List.empty(growable: true);
    for (var foodPref in foodPrefs) {
      piechartsections.add(PieChartSectionData(
          color: foodPref.color(),
          badgeWidget: Icon(foodPref.icon)
      ));

    }
    if (foodPrefs.isEmpty){
      return Stack(
          children: [
            Align(
                child:
                Stack(
                  alignment: Alignment.center,
                  children:[
                    MiddleWidget(suitable)
                  ],
                )
            ),
            ProductText(product.title)
          ]
      );
    }
    else if(foodPrefs.length == 1){
       return Stack(
          children: [
             Align(
              child:
                 Stack(
                 alignment: Alignment.center,
                   children:[
                     MiddleWidget(foodPrefs[0].suitable)
                   ],
                 )
             ),
            ProductText(product.title)
            ]
          );

    }
    return Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  MiddleWidget(suitable),
                  PieChart(
                    PieChartData(sections: piechartsections, centerSpaceRadius: MediaQuery.of(context).size.width / 5),
                    swapAnimationDuration: const Duration(milliseconds: 150),
                  ),
                ],
              ),
            ),
            ProductText(product.title)
          ]
    );
  }
  Container MiddleWidget(YESMAYBENO suitable){
    return Container(
      height: MediaQuery.of(context).size.width / 2.5,
      width: MediaQuery.of(context).size.width / 2.5,
      decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
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
    );
  }
  Positioned ProductText(String text){
    return  Positioned(
        left: 0,
        right: 0,
        bottom: MediaQuery.of(context).size.height * 0.2,
        child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20)),
    );
  }
  YESMAYBENO isSuitable(List<FoodPreference> foodPrefs){
    //If one of the foodPrefs is no, the product is not suitable
    for (FoodPreference foodPref in foodPrefs) {
      if (foodPref.suitable == YESMAYBENO.no) {
        return YESMAYBENO.no;
      }
    }
    //If one of the foodPrefs is maybe, the product is maybe suitable
    for (FoodPreference foodPref in foodPrefs) {
      if (foodPref.suitable == YESMAYBENO.maybe) {
        return YESMAYBENO.maybe;
      }
    }
    //If all of the foodPrefs are yes, the product is suitable
    return YESMAYBENO.yes;
  }
  Future<List<FoodPreference>> checkAll(UserPreferences userPreferences, Product product) async {
    List<FoodPreference> foodPrefs = List.empty(growable: true);
    if(userPreferences.glutenFree){
      foodPrefs.add(FoodPreference.glutenfree(context: context, suitable: isGlutenFree(product)));
    }
    if(userPreferences.lactoseFree){
      foodPrefs.add(FoodPreference.dairyFree(context: context,suitable: isLactoseFree(product)));
    }
    if(userPreferences.nutFree){
      foodPrefs.add(FoodPreference.nutsFree(context: context,suitable: isNutFree(product))) ;
    }
    if(userPreferences.vegetarian){
      foodPrefs.add(FoodPreference.vegetarian(context: context,suitable: isVegetarian(product))) ;
    }
    if(userPreferences.vegan){
      foodPrefs.add(FoodPreference.vegan(context: context,suitable: isVegan(product)));
    }
    if(userPreferences.palmOilFree){
      foodPrefs.add(FoodPreference.palmOilFree(context: context, suitable: isPalmOilFree(product)));
    }
    if(userPreferences.soyFree){
      foodPrefs.add(FoodPreference.soyFree(context: context, suitable: isSoyFree(product)));
    }
    if(userPreferences.glutamateFree){
      foodPrefs.add(FoodPreference.glutamateFree(context: context, suitable: isGlutamateFree(product)));
    }
    if(userPreferences.carbohydrates){
      foodPrefs.add(FoodPreference.carbohydrates(context: context, suitable:  isLessCarboHydrates(product, userPreferences)));
    }
    return foodPrefs;
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
  YESMAYBENO isSoyFree(Product product){
    return product.soyfree ? YESMAYBENO.yes : YESMAYBENO.no;
  }
  YESMAYBENO isGlutamateFree(Product product){
    return product.glutamatefree ? YESMAYBENO.yes : YESMAYBENO.no;
  }
  YESMAYBENO isLessCarboHydrates(Product product, UserPreferences userPreferences){
    return product.carbohydrates_100g < userPreferences.carbohydrateslimit? YESMAYBENO.yes: YESMAYBENO.no;
  }
}