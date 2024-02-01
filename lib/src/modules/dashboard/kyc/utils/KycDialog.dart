import 'package:fifty_one_cash/src/modules/dashboard/dashboard.dart';
import 'package:fifty_one_cash/src/modules/dashboard/kyc/DoKyc.dart';
import 'package:fifty_one_cash/src/widgets/button-one.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class KycDialog extends StatelessWidget {
  const KycDialog({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
          color: Colors.white, borderRadius: BorderStyles.alertDialogRadius),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "KYC PENDING",
            style: TextStyles.alertDialogTitle,
          ),
          Padding(
            padding: EdgeInsets.only(top: height - (height - 5)),
            child: const Text(
              "Your account setup is almost complete! please finish your KYC verification to unlock full feature",
              textAlign: TextAlign.center,
              style: TextStyles.textAreaAlertDialog,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ButtonOne(
                  width: (width - 90) / 2,
                  height: height - (height - 40),
                  onTap: () {
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: const DoKyc(),
                        ),
                      );
                    }
                  },
                  title: "DO KYC",
                  textStyle: TextStyles.buttonOnSmallFont,
                ),
                ButtonOne(
                  width: (width - 90) / 2,
                  height: height - (height - 40),
                  onTap: () {
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: const DashBoard(),
                        ),
                      );
                    }
                  },
                  title: "SKIP",
                  backgroundColor: Palette.grey,
                  showShadow: false,
                  textStyle: TextStyles.buttonOneSmallFontBlue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
