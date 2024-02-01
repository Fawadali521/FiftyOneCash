import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ChatQrScan extends StatefulWidget {
  const ChatQrScan({super.key});

  @override
  State<ChatQrScan> createState() => _ChatQrScanState();
}

class _ChatQrScanState extends State<ChatQrScan> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double c2 = 200;
    double c3 = 300;
    Color trans = Colors.black.withOpacity(0.5);
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      // body: Column(
      //   children: <Widget>[
      //     Expanded(
      //       flex: 5,
      //       child: QRView(
      //         key: qrKey,
      //         onQRViewCreated: _onQRViewCreated,
      //       ),
      //     ),
      //     Expanded(
      //       flex: 1,
      //       child: Center(
      //         child: (result != null)
      //             ? Text(
      //                 'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
      //             : Text('Scan a code'),
      //       ),
      //     )
      //   ],
      // ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            height: height,
            width: width,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/vector/qr-bg.png"),
                    fit: BoxFit.cover,
                    alignment: Alignment.center)),
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Container(
            height: height,
            width: width,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/vector/qr-bg.png"),
                    fit: BoxFit.cover,
                    alignment: Alignment.center)),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white.withOpacity(0.1),
                child: Center(
                  child: Transform.rotate(
                    angle: pi / 4,
                    child: const Icon(
                      Icons.add,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
