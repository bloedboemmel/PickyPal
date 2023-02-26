import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_camera.dart';

import 'ProductView.dart';

//apply this class on home: attribute at MaterialApp()
class CamScanner extends StatefulWidget{
  const CamScanner({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CamScanner(); //create state
  }
}

class _CamScanner extends State<CamScanner> {
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


  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      calledScreenAlready = false;
    }
  }


  @override
  Widget build(BuildContext context) {
    final squareSize = MediaQuery.of(context).size.width * 0.7;
    return Stack(
        children: [
        QrCamera(
        qrCodeCallback: (code) {
          scanresult = code!;
          if (!calledScreenAlready) {
            calledScreenAlready = true;
            Navigator.push(context, MaterialPageRoute(
                builder: (context) =>
                    ProductView(barcode: code))).then((value) =>
                setState(() {
                  calledScreenAlready = false;
                }));
          }
        },
        formats: const [BarcodeFormats.EAN_13, BarcodeFormats.EAN_8],
        ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: 2,
                width:  squareSize,
                color: Colors.red,
              ),
            ),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height -squareSize/2) / 2 ,
            left: (MediaQuery.of(context).size.width - squareSize) / 2,
            child: ClipRect(
              child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.transparent,
                  ),
                  height: squareSize/2,
                  width: squareSize,
                ),

            ),
          ),
        ],
    );
  }
}
