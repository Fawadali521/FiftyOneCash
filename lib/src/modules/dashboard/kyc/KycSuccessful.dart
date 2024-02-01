//created by MHK-MotoVlogs

import 'package:fifty_one_cash/src/modules/dashboard/dashboard.dart';
import 'package:fifty_one_cash/src/widgets/button-one.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class KycSuccessful extends StatelessWidget {
  const KycSuccessful({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 2, end: 1),
                    curve: Curves.bounceInOut,
                    duration: const Duration(seconds: 2),
                    builder: (context, value, child) => Transform.scale(
                      scale: value,
                      child: Image.asset(
                        "assets/icons/successKyc.png",
                        height: 150,
                        width: 150,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text(
                      "You KYC has been updated,please wait for admin to validate and confirm",
                      style: TextStyles.kycText,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 7, top: 5),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 5,
              child: SafeArea(
                child: SizedBox(
                  height: 50,
                  width: width,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: ButtonOne(
                      title: 'Done',
                      isLoading: false,
                      backgroundColor: Palette.secondaryColor,
                      textStyle: TextStyles.simpleButton,
                      onTap: () {
                        pushNewScreen(
                          context,
                          screen: const DashBoard(),
                          withNavBar: false,
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
