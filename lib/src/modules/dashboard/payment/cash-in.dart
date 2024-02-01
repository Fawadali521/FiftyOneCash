import 'package:fifty_one_cash/datas.dart';
import 'package:fifty_one_cash/src/modules/dashboard/payment/adding-funds-info.dart';
import 'package:fifty_one_cash/src/modules/dashboard/payment/payment-successful.dart';
import 'package:fifty_one_cash/src/modules/privacy/master-pin-enter.dart';
import 'package:fifty_one_cash/src/widgets/payment-field.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class CashIn extends StatefulWidget {
  const CashIn({super.key});

  @override
  State<CashIn> createState() => _CashInState();
}

class _CashInState extends State<CashIn> {
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
          "Cash In",
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
            const Padding(
              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Opacity(
                opacity: 0.7,
                child: Text(
                  Datas.cashIn,
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
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Wrap(
                  runSpacing: 10,
                  spacing: 10,
                  children: List.generate(
                      7,
                      (index) => InkWell(
                            onTap: () {
                              if (selected != index) {
                                setState(() {
                                  selected = index;
                                });
                              } else {
                                setState(() {
                                  selected = null;
                                });
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Palette.chatBg,
                                borderRadius: BorderRadius.circular(10),
                                border: selected == index
                                    ? Border.all(
                                        color: Palette.chatBg3, width: 2)
                                    : null,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, right: 15, top: 7, bottom: 7),
                                child: Text(
                                  "\$${(index + 1) * 100}",
                                  style: TextStyles.profileWhiteOne,
                                ),
                              ),
                            ),
                          )),
                ),
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                pushNewScreen(
                  context,
                  screen:
                      const EnterMasterPin(navigatePage: PaymentSuccessful()),
                  withNavBar: false, // OPTIONAL VALUE. True by default.
                  pageTransitionAnimation: PageTransitionAnimation.fade,
                );
              },
              child: Container(
                width: width,
                height: 50,
                decoration: const BoxDecoration(
                  color: Palette.chatBg,
                ),
                child: const Center(
                    child: Text(
                  "Cash In",
                  style: TextStyles.buttonWhiteOne,
                  textAlign: TextAlign.center,
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
