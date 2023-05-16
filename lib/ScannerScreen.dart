// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'ProductView.dart';
import 'package:visibility_detector/visibility_detector.dart';

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
  List<String> barcodes = List.empty(growable: true);
  bool _isVisible = false;

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
      barcodes.clear();
    }
    print(AppLifecycleState);
  }


  @override
  Widget build(BuildContext context) {
    final squareSize = MediaQuery.of(context).size.width * 0.7;
    return
      VisibilityDetector(
        key: Key('camera'),
        onVisibilityChanged: (visibilityInfo) {_isVisible = visibilityInfo.visibleFraction > 0;},
          child: Stack(
            children: [
            QrCamera(
            qrCodeCallback: (code) {
              scanresult = code!;
              if(barcodes.length == 2){
                if(barcodes[0] == scanresult && barcodes[1]==scanresult){
                  if (!calledScreenAlready && _isVisible) {
                    calledScreenAlready = true;
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) =>
                            ProductView(barcode: code))).then((value) =>
                        setState(() {
                          calledScreenAlready = false;
                        }));
                  }
                }
                else{
                  barcodes.removeAt(0);
                  barcodes.add(scanresult);
                }
              }
              else{
                barcodes.add(scanresult);
              }


            },
            formats: const [BarcodeFormats.EAN_13, BarcodeFormats.EAN_8],
            onError: (BuildContext context, Object? error){
              return Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                    widthFactor: 0.8, // Set the width of the column to 80% of the screen width
                    heightFactor: 0.3, //
                    child: Column(
                          children: [
                            const Icon(Icons.no_flash, size: 40),
                            Container(height: 20),
                            Text(AppLocalizations.of(context)!.cameraNotWorking)
                          ])
                ),
              );
            },
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
        )
      );
  }
}
