import 'package:PickyPal/userSettings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:PickyPal/ScannerScreen.dart';
final globalNavigatorKey = GlobalKey<NavigatorState>();
void main() => runApp(

    FutureProvider<UserPreferences>(
        initialData: UserPreferences.empty(),
        create: (context) => PreferencesFromStorage(),
        child: const MyApp()
    ));
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      home: HomeScreen(),
    );
  }
}

//apply this class on home: attribute at MaterialApp()
class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {

    return _HomeScreen(); //create state
  }
}

class _HomeScreen extends State<HomeScreen>{
  late String scanresult; //varaible for scan result text
  bool calledScreenAlready = false;
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
                    appBar: AppBar(
                        title:const Text("Is it ok?"),
                        backgroundColor: Colors.redAccent
                    ),
                    body: _selectedIndex == 0 ? const CamScanner(): SettingsPage(),
                    bottomNavigationBar: BottomNavigationBar(
                      items: const <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          icon: Icon(Icons.camera),
                          label: 'Camera',

                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.settings),
                          label: 'Settings',
                        ),
                      ],
                      currentIndex: _selectedIndex, //New
                      onTap: _onItemTapped,
                    ),
                  ),
        onWillPop: ()async{
          if(_selectedIndex == 0){
            return true;
          }
          else{
            setState(() {
              _selectedIndex = 0;
            });

            return false;
          }
          }
        );
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

