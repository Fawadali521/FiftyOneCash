import 'package:fifty_one_cash/src/modules/dashboard/dashboard.dart';
import 'package:fifty_one_cash/src/services/ApiService.dart';
import 'package:fifty_one_cash/src/services/toast-msg.dart';
import 'package:fifty_one_cash/src/widgets/button-one.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pinput/pinput.dart';

class SetUpMasterPin extends StatefulWidget {
  const SetUpMasterPin({super.key});

  @override
  State<SetUpMasterPin> createState() => _SetUpMasterPinState();
}

class _SetUpMasterPinState extends State<SetUpMasterPin> {
  String? pin;

  bool isLoading = false;
  bool enableBiometric = true;

  TextEditingController controller = TextEditingController();

  FocusNode focusNode = FocusNode();

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyles.bodyBigBold,
    decoration: BoxDecoration(
      borderRadius: BorderStyles.norm2,
      border: Border.all(color: Palette.primaryColor.withOpacity(0.5)),
    ),
  );

  final focusedBorderColor = Palette.primaryColor.withOpacity(0.5);
  final fillColor = Palette.chatUiBg2.withOpacity(0.1);
  final borderColor = Palette.primaryColor;

  savePin() async {
    if (pin != null && pin!.trim().isNotEmpty && pin!.trim() != '') {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      bool result = await ApiService().saveMasterPin(pin);
      if (result) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: const DashBoard(),
            ),
          );
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        ToastMsg().sendErrorMsg("Something went wrong");
      }
    } else {
      ToastMsg().sendErrorMsg("Master pin field is empty");
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: height * 0.2 + 10,
                  width: width,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25)),
                      color: Palette.sky),
                ),
                Stack(
                  children: [
                    Container(
                      height: height * 0.2,
                      width: width,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30)),
                          gradient: LinearGradient(
                            colors: [
                              Palette.primaryColor,
                              Palette.secondaryColor,
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          )),
                    ),
                    SizedBox(
                      height: height * 0.2,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 0),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/logo/logo-shadow.png",
                                width: 85,
                              ),
                              const Text(
                                "Cash",
                                style: TextStyles.splashBigBoldWhiteText,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 25),
              child: Column(
                children: [
                  Text(
                    "Master Pin Setup".toUpperCase(),
                    style: TextStyles.headingBoldBlack,
                    textAlign: TextAlign.center,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Opacity(
                        opacity: 0.4,
                        child: Text(
                          "Setup you master pin, it will be use in transfer of money.",
                          style: TextStyles.bodyBlack,
                          textAlign: TextAlign.center,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        Pinput(
                          length: 4,
                          controller: controller,
                          focusNode: focusNode,
                          androidSmsAutofillMethod:
                              AndroidSmsAutofillMethod.smsUserConsentApi,
                          listenForMultipleSmsOnAndroid: true,
                          defaultPinTheme: defaultPinTheme,
                          hapticFeedbackType: HapticFeedbackType.lightImpact,
                          onChanged: (value) {
                            setState(() {
                              pin = value;
                            });
                          },
                          cursor: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 9),
                                width: 22,
                                height: 1,
                                color: focusedBorderColor,
                              ),
                            ],
                          ),
                          focusedPinTheme: defaultPinTheme.copyWith(
                            decoration: defaultPinTheme.decoration!.copyWith(
                              borderRadius: BorderStyles.norm,
                              border: Border.all(color: focusedBorderColor),
                            ),
                          ),
                          submittedPinTheme: defaultPinTheme.copyWith(
                            decoration: defaultPinTheme.decoration!.copyWith(
                              color: fillColor,
                              borderRadius: BorderStyles.norm,
                              border: Border.all(color: focusedBorderColor),
                            ),
                          ),
                          errorPinTheme: defaultPinTheme.copyBorderWith(
                            border: Border.all(color: Colors.redAccent),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: SizedBox(
                      width: width - 40,
                      height: 45,
                      child: ButtonOne(
                        isLoading: isLoading,
                        onTap: () async {
                          await savePin();
                        },
                        title: "Continue".toUpperCase(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
