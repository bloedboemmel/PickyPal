import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_camera.dart';

import 'ProductView.dart';

//apply this class on home: attribute at MaterialApp()
class CamScanner extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _CamScanner(); //create state
  }
}

class _CamScanner extends State<CamScanner>{
  late String scanresult;
  bool calledScreenAlready = false;
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
