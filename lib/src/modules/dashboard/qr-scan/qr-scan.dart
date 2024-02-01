import 'dart:convert';
import 'dart:io';

import 'package:fifty_one_cash/msg-data.dart';
import 'package:fifty_one_cash/src/models/QrData.dart';
import 'package:fifty_one_cash/src/modules/dashboard/payment/send-payment.dart';
import 'package:fifty_one_cash/src/services/toast-msg.dart';
import 'package:fifty_one_cash/src/widgets/AnimatedBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:scan/scan.dart';

class QrScan extends StatefulWidget {
  const QrScan({super.key});

  @override
  State<QrScan> createState() => _QrScanState();
}

class _QrScanState extends State<QrScan> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QrData? _qrData;
  QRViewController? controller;
  bool isOn = false;
  bool isCamera = false;
  String? userName;
  final ImagePicker picker = ImagePicker();

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

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
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SizedBox(
            height: height,
            width: width,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              formatsAllowed: const [BarcodeFormat.qrcode],
              overlay: QrScannerOverlayShape(
                  borderColor: Colors.white,
                  borderRadius: 5,
                  borderLength: 50,
                  borderWidth: 10,
                  cutOutSize: 300),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
                height: 300 - 10,
                width: 300 - 10,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: const AnimatedBar()),
          ),
          Positioned(
            bottom: height * 0.1,
            child: SizedBox(
              width: width,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () async {
                        await controller?.toggleFlash();
                        setState(() {
                          isOn ? isOn = false : isOn = true;
                        });
                      },
                      child: CircleAvatar(
                        backgroundColor:
                            isOn ? Colors.white : Colors.white.withOpacity(0.1),
                        radius: 30,
                        child: Icon(
                          Icons.light_mode,
                          color: isOn ? Colors.black : Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await controller?.flipCamera();

                        setState(() {
                          isCamera ? isCamera = false : isCamera = true;
                        });
                      },
                      child: CircleAvatar(
                        backgroundColor: isCamera
                            ? Colors.white
                            : Colors.white.withOpacity(0.1),
                        radius: 30,
                        child: Icon(
                          Icons.flip_camera_android,
                          color: isCamera ? Colors.black : Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await qrFromStorage();
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.1),
                        radius: 30,
                        child: const Icon(
                          Icons.image,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) {
      var data = scanData.code;
      try {
        Map<String, dynamic> jsonMap = json.decode(data!);
        QrData qrData = QrData.fromJson(jsonMap);
        setState(() {
          _qrData = qrData;
        });
      } catch (e) {
        ToastMsg().sendErrorMsg(MsgData.wrongTypeQr);
      }
      if (_qrData != null && _qrData!.company == "51Cash" && mounted) {
        HapticFeedback.heavyImpact();
        if (Platform.isAndroid) {
          controller.pauseCamera();
        } else if (Platform.isIOS) {
          controller.stopCamera();
        }
        controller.dispose();

        pushNewScreen(
          context,
          screen: SendPayment(
              name: _qrData!.name,
              userId: _qrData!.userId.toString(),
              userName: _qrData!.userName),
          withNavBar: false, // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
        _qrData = null;
      }
    });
  }

  qrFromStorage() async {
    final XFile? images = await picker.pickImage(source: ImageSource.gallery);
    if (images != null) {
      String? str = await Scan.parse(images.path);
      if (str != null) {
        var data = str;
        try {
          Map<String, dynamic> jsonMap = json.decode(data);
          QrData qrData = QrData.fromJson(jsonMap);
          setState(() {
            _qrData = qrData;
          });
        } catch (e) {
          HapticFeedback.heavyImpact();
          ToastMsg().sendErrorMsg(MsgData.wrongTypeQr);
        }
        if (_qrData != null && _qrData!.company == "51Cash" && mounted) {
          HapticFeedback.heavyImpact();
          pushNewScreen(
            context,
            screen: SendPayment(
                name: _qrData!.name,
                userId: _qrData!.userId.toString(),
                userName: _qrData!.userName),
            withNavBar: false, // OPTIONAL VALUE. True by default.
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
          _qrData = null;
        } else {
          HapticFeedback.heavyImpact();
          ToastMsg().sendErrorMsg(MsgData.wrongTypeQr);
        }
      } else {
        HapticFeedback.heavyImpact();
        ToastMsg().sendErrorMsg(MsgData.noQrCodeFound);
      }
    }
  }
}
