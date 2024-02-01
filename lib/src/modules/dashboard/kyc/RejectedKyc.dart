//created by MHK-MotoVlogs

import 'package:fifty_one_cash/src/modules/dashboard/kyc/DoKyc.dart';
import 'package:fifty_one_cash/src/widgets/button-one.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';

class RejectedKyc extends StatelessWidget {
  const RejectedKyc({super.key});

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
                  Image.asset(
                    "assets/icons/failedKyc.png",
                    height: 150,
                    width: 150,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text(
                      "Thank you for your KYC application. we regret to inform you that it did not meet our requirements.Please consider Reappling",
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
                      title: 'Reapply',
                      isLoading: false,
                      backgroundColor: Palette.secondaryColor,
                      textStyle: TextStyles.simpleButton,
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          PageTransition(
                            child: const DoKyc(),
                            type: PageTransitionType.fade,
                          ),
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

    // Scaffold(
    //   appBar: AppBar(
    //     systemOverlayStyle: Platform.isIOS
    //         ? SystemUiOverlayStyle.dark
    //         : SystemUiOverlayStyle.light,
    //     leading: SizedBox(
    //       height: 25,
    //       width: 25,
    //       child: InkWell(
    //         onTap: () {
    //           if (context.mounted) {
    //             Navigator.pop(context);
    //           }
    //         },
    //         child: const Icon(
    //           Icons.arrow_back_ios_new_rounded,
    //           size: 15,
    //           color: Colors.black,
    //         ),
    //       ),
    //     ),
    //   ),
    //   body: MediaQuery.removePadding(
    //     context: context,
    //     removeTop: true,
    //     child: Stack(
    //       children: [
    //         SizedBox(
    //           height: height,
    //           width: width,
    //           child: ListView(
    //               padding: const EdgeInsets.only(left: 20, right: 20, top: 140),
    //               shrinkWrap: true,
    //               children: [
    //                 UnconstrainedBox(
    //                   child: Container(
    //                     width: 100,
    //                     height: 100,
    //                     decoration: const BoxDecoration(
    //                         image: DecorationImage(
    //                             image: AssetImage('assets/icons/failedKyc.png'),
    //                             fit: BoxFit.fill)),
    //                   ),
    //                 ),
    //                 const Padding(
    //                   padding: EdgeInsets.only(top: 20.0),
    //                   child: Text(
    //                     "Thank you for your KYC application. we regret to inform you that it did not meet our requirements.Please consider Reappling",
    //                     style: TextStyles.kycText,
    //                     textAlign: TextAlign.center,
    //                   ),
    //                 )
    //               ]),
    //         ),
    //         Positioned(
    //           width: width,
    //           bottom: 20,
    //           child: SafeArea(
    //             child: Padding(
    //               padding: const EdgeInsets.symmetric(horizontal: 20),
    //               child: GradientTextButton(
    //                 buttonText: 'Reapply',
    //                 paddingVertical: 15,
    //                 onTap: () {
    //                   Navigator.pushReplacement(
    //                       context,
    //                       PageTransition(
    //                         child: const DoKyc(),
    //                         type: PageTransitionType.fade,
    //                       ));
    //                 },
    //               ),
    //             ),
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}
