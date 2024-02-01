import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:fifty_one_cash/datas.dart';
import 'package:fifty_one_cash/src/modules/dashboard/notifications/notifications.dart';
import 'package:fifty_one_cash/src/modules/dashboard/payment/cash-in.dart';
import 'package:fifty_one_cash/src/modules/dashboard/payment/cash-out.dart';
import 'package:fifty_one_cash/src/modules/dashboard/payment/send-cash.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Duration upRowDelay = const Duration(milliseconds: 500);
  Duration gridDelay = const Duration(milliseconds: 2000);
  bool hideBalance = true;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      height: height,
      width: width,
      decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Palette.bgBlue1, Palette.bgBlue2])),
      child: ListView(
        // shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: [
          const SafeArea(child: SizedBox()),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DelayedDisplay(
                  delay: upRowDelay,
                  slidingBeginOffset: const Offset(-1.0, 0.0),
                  slidingCurve: Curves.ease,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/logo/51-cash-logo-trans.png",
                        fit: BoxFit.contain,
                        height: 30,
                      ),
                      const Text(
                        "Cash",
                        style: TextStyles.homeBigBoldWhiteText,
                      ),
                    ],
                  ),
                ),
                DelayedDisplay(
                  delay: upRowDelay,
                  slidingBeginOffset: const Offset(1.0, 0.0),
                  slidingCurve: Curves.ease,
                  child: InkWell(
                    onTap: () {
                      pushNewScreen(
                        context,
                        screen: const Notifications(),
                        withNavBar: false, // OPTIONAL VALUE. True by default.
                        pageTransitionAnimation: PageTransitionAnimation.fade,
                      );
                    },
                    child: Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                        color: Colors.transparent,
                      ),
                      child: Center(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.asset(
                                "assets/icons/notification.png",
                                height: 20,
                                fit: BoxFit.contain,
                                color: Colors.white,
                              ),
                            ),
                            const Positioned(
                              right: -7,
                              top: -7,
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.red,
                                child: Text(
                                  "3",
                                  style: TextStyles.notificationWhiteBold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Opacity(
                  opacity: 0.6,
                  child: Text(
                    "Available Balance",
                    style: TextStyles.paraBigWhite,
                  ),
                ),

                // Edited by MHK-MotoVlogs
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 15.0),
                      child: Opacity(
                        opacity: 0.6,
                        child: Text(
                          "JMD",
                          style: TextStyles.paraBigWhite,
                        ),
                      ),
                    ),
                    hideBalance
                        ? const Text(
                            "\$*.00 ",
                            style:
                                TextStyles.splashBigBoldWhiteTextOswaldFamily,
                            textAlign: TextAlign.center,
                          )
                        : AnimatedTextKit(
                            repeatForever: false,
                            isRepeatingAnimation: false,
                            totalRepeatCount: 1,
                            animatedTexts: [
                                TyperAnimatedText(
                                  speed: const Duration(milliseconds: 500),
                                  "\$450.50 ",
                                  textStyle: TextStyles.splashBigBoldWhiteText,
                                  textAlign: TextAlign.center,
                                ),
                              ]),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15.0,
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            hideBalance
                                ? hideBalance = false
                                : hideBalance = true;
                          });
                          print(hideBalance);
                        },
                        child: Icon(
                          hideBalance
                              ? Icons.remove_red_eye
                              : Icons.remove_red_eye_outlined,
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                    )
                  ],
                ),
                //end
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: width,
                  constraints: BoxConstraints(
                    minHeight: height * 0.3,
                  ),
                  decoration: const BoxDecoration(
                    color: Palette.grey3,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: Column(
                      children: [
                        ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 60,
                          ),
                          shrinkWrap: true,
                          children: [
                            const Text(
                              "Features",
                              style: TextStyles.midHeadingBlack,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 25),
                              child: SizedBox(
                                child: AnimationLimiter(
                                  child: GridView.count(
                                    crossAxisCount: 4,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    crossAxisSpacing: 20,
                                    childAspectRatio: 2 / 2.8,
                                    // mainAxisSpacing: 10,
                                    children: List.generate(
                                        Datas().paymentList.length,
                                        (index) => AnimationConfiguration
                                                .staggeredGrid(
                                              position: index,
                                              duration: gridDelay,
                                              columnCount: 2,
                                              child: ScaleAnimation(
                                                child: FadeInAnimation(
                                                  child: paymentItem(
                                                      isAvailable:
                                                          (index == 4 ||
                                                                  index == 4 ||
                                                                  index == 6 ||
                                                                  index == 5)
                                                              ? false
                                                              : true,
                                                      image:
                                                          Datas().paymentList[
                                                              index]['image'],
                                                      title:
                                                          Datas().paymentList[
                                                              index]['title']),
                                                ),
                                              ),
                                            )),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Promos & Discounts",
                                    style: TextStyles.midHeadingBlack,
                                  ),
                                  Text(
                                    "See more",
                                    style: TextStyles.smallPurple,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 50),
                              child: SizedBox(
                                height: 100,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: Container(
                                        height: 100,
                                        width: 300,
                                        decoration: BoxDecoration(
                                            image: const DecorationImage(
                                              image: AssetImage(
                                                  "assets/banner/banner1.png"),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Palette.grey4),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: Container(
                                        height: 100,
                                        width: 300,
                                        decoration: BoxDecoration(
                                            image: const DecorationImage(
                                              image: AssetImage(
                                                  "assets/banner/banner1.png"),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Palette.grey4),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: Container(
                                        height: 100,
                                        width: 300,
                                        decoration: BoxDecoration(
                                            image: const DecorationImage(
                                              image: AssetImage(
                                                  "assets/banner/banner1.png"),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Palette.grey4),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: -45,
                  child: SizedBox(
                    width: width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: width - 60,
                          // height: 120,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.02),
                                  blurRadius: 10,
                                  spreadRadius: 8,
                                ),
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 20, bottom: 20),
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      pushNewScreen(
                                        context,
                                        screen: const CashIn(),
                                        withNavBar:
                                            false, // OPTIONAL VALUE. True by default.
                                        pageTransitionAnimation:
                                            PageTransitionAnimation.fade,
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          "assets/icons/add-funds.png",
                                          height: 25,
                                          fit: BoxFit.contain,
                                          color: Palette.bgBlue2,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Text(
                                            "Cash In",
                                            style: TextStyles.bodyBlack,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      print("object");
                                      pushNewScreen(
                                        context,
                                        screen: const SendCash(),
                                        withNavBar:
                                            false, // OPTIONAL VALUE. True by default.
                                        pageTransitionAnimation:
                                            PageTransitionAnimation.fade,
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          child: Image.asset(
                                            "assets/icons/send-money.png",
                                            height: 25,
                                            fit: BoxFit.contain,
                                            color: Palette.bgBlue2,
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Text(
                                            "Send",
                                            style: TextStyles.bodyBlack,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Column(
                                  //   children: [
                                  //     Image.asset(
                                  //       "assets/icons/receive-money.png",
                                  //       height: 25,
                                  //       fit: BoxFit.contain,
                                  //       color: Palette.bgBlue2,
                                  //     ),
                                  //     const Padding(
                                  //       padding: EdgeInsets.only(top: 5),
                                  //       child: Text(
                                  //         "Request",
                                  //         style: TextStyles.bodyBlack,
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  InkWell(
                                    onTap: () {
                                      pushNewScreen(
                                        context,
                                        screen: const CashOut(),
                                        withNavBar:
                                            false, // OPTIONAL VALUE. True by default.
                                        pageTransitionAnimation:
                                            PageTransitionAnimation.fade,
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          "assets/icons/withdraw-funds.png",
                                          height: 25,
                                          fit: BoxFit.contain,
                                          color: Palette.bgBlue2,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Text(
                                            "Cash Out",
                                            style: TextStyles.bodyBlack,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
          )
        ],
      ),
    ));
  }

  Widget paymentItem(
      {required String image, required String title, bool isAvailable = true}) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Palette.grey4,
              ),
              child: Center(
                  child: Image.asset(
                image,
                height: 25,
                fit: BoxFit.contain,
              )),
            ),
            if (!isAvailable)
              Positioned(
                top: -18,
                right: -18,
                child: Image.asset(
                  "assets/icons/coming-soon.png",
                  height: 30,
                  fit: BoxFit.contain,
                ),
              ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            title,
            style: TextStyles.bodyBlack,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
