
import 'package:flutter/material.dart';
import 'package:flutter_barcode_3/ProductView.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:flutter_barcode_3/userSettings.dart';
//put this line manually

void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: CamScanner(),
    );
  }
}

//apply this class on home: attribute at MaterialApp()
class CamScanner extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _CamScanner(); //create state
  }
}

class _CamScanner extends State<CamScanner>{
  late String scanresult; //varaible for scan result text
  bool calledScreenAlready = false;
  int _selectedIndex = 0;
  @override
  void initState() {
    scanresult = "";
    calledScreenAlready = false;
    super.initState();
  }
  @override
  void dispose() {
    calledScreenAlready = true;
    super.dispose();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      calledScreenAlready = false;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:Text("QR or Bar code Scanner"),
          backgroundColor: Colors.redAccent
      ),
      body: _selectedIndex == 0 ? scanner(): SettingsPage(),
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
    );
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  Container scanner(){

    return Container(
        alignment: Alignment.topCenter, //inner widget alignment to center
        padding: EdgeInsets.all(20),
        child:Column(
          children:[
            Container(
                margin: EdgeInsets.only(top:30),
                child: SizedBox(
                  width: 300.0,
                  height: 600.0,
                  child: QrCamera(
                    qrCodeCallback: (code) {
                      print(code);
                      scanresult = code!;
                      if (!calledScreenAlready) {
                        calledScreenAlready = true;
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                ProductView(barcode: code))).then((value) => setState((){calledScreenAlready = false;}));
                      }
                    },
                    formats: [BarcodeFormats.EAN_13, BarcodeFormats.EAN_8],



                  ),
                )
            )

          ],
        )
    );
  }

}

