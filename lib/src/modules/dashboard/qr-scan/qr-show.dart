import 'dart:convert';
import 'dart:typed_data';

import 'package:fifty_one_cash/src/services/ApiService.dart';
import 'package:fifty_one_cash/src/services/SharedData.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QrShow extends StatefulWidget {
  const QrShow({super.key});

  @override
  State<QrShow> createState() => _QrShowState();
}

class _QrShowState extends State<QrShow> {
  String? firstName;
  String? lastName;
  String? userName;
  String? profilePictureUrl;

  Uint8List? imageData;

  var image = Image.asset(
    'assets/logo/51-cash-logo-qr.png',
  );
  var myData;

  String? getFirstAndLastName() {
    if (firstName != null && lastName != null) {
      return "${firstName![0].toUpperCase()}${firstName!.substring(1)} "
          "${lastName![0].toUpperCase()}${lastName!.substring(1)}";
    } else if (firstName != null && lastName == null) {
      return "${firstName![0].toUpperCase()}${firstName!.substring(1)}";
    } else if (firstName == null && lastName != null) {
      return "${lastName![0].toUpperCase()}${lastName!.substring(1)}";
    }
    return null;
  }

  getStoredUserProfile() async {
    firstName = await SharedData.getFirstName();
    lastName = await SharedData.getLastName();
    userName = await SharedData.getUserName();
    profilePictureUrl = await SharedData.getProfilePicture();

    if (profilePictureUrl != null) {
      imageData = await ApiService().getProfileImage(profilePictureUrl!);
    }
    myData = {
      "company": "51Cash",
      "userName": userName,
      "name": getFirstAndLastName(),
      "user_id": 859465258
    };
    setState(() {});
  }

  @override
  void initState() {
    getStoredUserProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: height,
            width: width,
            decoration: const BoxDecoration(
                gradient:
                    LinearGradient(colors: [Palette.bgBlue1, Palette.bgBlue2])),
            child: Padding(
              padding: EdgeInsets.only(
                  left: 20, right: 20, top: height * 0.1, bottom: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: width - 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 60, bottom: 15, left: 20, right: 20),
                              child: PrettyQr(
                                image: const AssetImage(
                                    "assets/logo/51-cash-logo.png"),
                                size: width - 60 - 40,
                                data: jsonEncode(myData),
                                errorCorrectLevel: QrErrorCorrectLevel.M,
                                roundEdges: true,
                                elementColor: Palette.bgBlue2,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Text(
                                "@${userName ?? ''}",
                                style: TextStyles.headingBoldPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: -80,
                        child: SizedBox(
                          width: width - 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 130,
                                width: 130,
                                decoration: BoxDecoration(
                                  color: Palette.sky,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Center(
                                  child: Container(
                                    height: 128,
                                    width: 128,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(colors: [
                                        Palette.bgBlue1,
                                        Palette.bgBlue2
                                      ]),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Center(
                                      child: Container(
                                        height: 126,
                                        width: 126,
                                        decoration: BoxDecoration(
                                          image: imageData == null
                                              ? const DecorationImage(
                                                  image: AssetImage(
                                                      "assets/icons/personavator.png"),
                                                  fit: BoxFit.cover)
                                              : DecorationImage(
                                                  image:
                                                      MemoryImage(imageData!),
                                                  fit: BoxFit.cover),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Text(
                      "Empower your connections and transactions with our dynamic QR code – Share, Accept, and Thrive!",
                      style: TextStyles.paraBigBoldWhite,
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white.withOpacity(0.1),
                  child: const Center(
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
