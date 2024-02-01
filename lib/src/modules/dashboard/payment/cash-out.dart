import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:fifty_one_cash/datas.dart';
import 'package:fifty_one_cash/src/modules/dashboard/payment/adding-funds-info.dart';
import 'package:fifty_one_cash/src/widgets/payment-field.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class CashOut extends StatefulWidget {
  const CashOut({super.key});

  @override
  State<CashOut> createState() => _CashOutState();
}

class _CashOutState extends State<CashOut> {
  int? selected;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient:
                  LinearGradient(colors: [Palette.bgBlue1, Palette.bgBlue2])),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Cash Out",
          style: TextStyles.homeBigBoldWhiteText,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.info_outline,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {
              pushNewScreen(
                context,
                screen: const AddingFundsInfo(),
                withNavBar: false, // OPTIONAL VALUE. True by default.
                pageTransitionAnimation: PageTransitionAnimation.fade,
              );
            },
          ),
        ],
      ),
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
            gradient:
                LinearGradient(colors: [Palette.bgBlue1, Palette.bgBlue2])),
        child: Column(
          children: [
            const SafeArea(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 4),
              child: Container(
                height: 102,
                width: 102,
                decoration: BoxDecoration(
                  color: Palette.sky,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Container(
                    height: 98,
                    width: 98,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Palette.bgBlue1, Palette.bgBlue2]),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                      child: Container(
                        height: 96,
                        width: 96,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                              image: AssetImage("assets/image/me.jpg"),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            AnimatedTextKit(
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
            const Padding(
              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Opacity(
                opacity: 0.7,
                child: Text(
                  Datas.cashOut,
                  style: TextStyles.bodyWhite,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: PaymentField(
                hint: "Enter Amount",
                onChanged: (x) {},
              ),
            ),
            const Spacer(),
            const Padding(
              padding:
                  EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
              child: Opacity(
                opacity: 0.9,
                child: Text(
                  Datas.cashInWarning,
                  style: TextStyles.bodyWhite,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              width: width,
              height: 50,
              decoration: const BoxDecoration(
                color: Palette.chatBg,
              ),
              child: const Center(
                  child: Text(
                "Cash Out",
                style: TextStyles.buttonWhiteOne,
                textAlign: TextAlign.center,
              )),
            )
          ],
        ),
      ),
    );
  }
}
