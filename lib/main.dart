import 'dart:ui';

import 'package:PickyPal/userSettings.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:PickyPal/ScannerScreen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';

final globalNavigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  return runApp(

      FutureProvider<UserPreferences>(
          initialData: UserPreferences.empty(),
          create: (context) => PreferencesFromStorage(),
          child: const MyApp()
      ));
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(primaryColor: Colors.white),
      darkTheme: ThemeData.dark().copyWith(primaryColor: Colors.black26),
      themeMode: ThemeMode.system,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomeScreen(),
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

  late String scanresult;
  bool calledScreenAlready = false;
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
    return
      Scaffold(
         body: Stack(
           children: [
             const CamScanner(),
             Positioned(
               bottom: 50.0,
               right: 20.0,
               child: Container(
                   decoration: const BoxDecoration(
                         shape: BoxShape.circle,
                         color: Colors.blue,
                    ),
                   child:IconButton(
                         icon: const Icon(Icons.settings),
                         onPressed: () {
                           Navigator.push(context,
                               MaterialPageRoute(builder: (context) =>const SettingsPage()));

                         },
                   )
               ),
             )
           ],
         )
         ,
      );

  }
}

