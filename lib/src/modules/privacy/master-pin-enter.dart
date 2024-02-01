import 'package:fifty_one_cash/src/services/ApiService.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pinput/pinput.dart';

class EnterMasterPin extends StatefulWidget {
  final Widget navigatePage;
  const EnterMasterPin({super.key, required this.navigatePage});

  @override
  State<EnterMasterPin> createState() => _EnterMasterPinState();
}

class _EnterMasterPinState extends State<EnterMasterPin> {
  String? enterPin;
  bool showPin = false;
  bool isLoading = false;

  verifyMasterPin() async {
    isLoading = true;
    if (mounted) {
      setState(() {});
    }
    bool result = await ApiService().verifyMasterPin(enterPin);
    if (result == false) {
      showPin = true;
    } else {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: widget.navigatePage,
          ),
        );
      }
    }
    isLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  final defaultPinTheme = PinTheme(
    width: 60,
    height: 60,
    textStyle: const TextStyle(
      fontSize: 22,
      color: Colors.white,
    ),
    margin: const EdgeInsets.only(left: 5, right: 5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.white, width: 1),
    ),
  );
  final focusedPinTheme = PinTheme(
    width: 60,
    height: 60,
    textStyle: TextStyles.masterPinStyle,
    margin: const EdgeInsets.only(left: 5, right: 5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100),
      border: Border.all(color: Colors.white, width: 1),
    ),
  );

  final submittedPinTheme = PinTheme(
    width: 60,
    height: 60,
    textStyle: TextStyles.masterPinStyle,
    margin: const EdgeInsets.only(left: 5, right: 5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100),
      border: Border.all(color: Colors.white, width: 1),
    ),
  );
  final errorPinTheme = PinTheme(
    width: 60,
    height: 60,
    textStyle: TextStyles.masterPinStyle,
    margin: const EdgeInsets.only(left: 5, right: 5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.redAccent, width: 1),
    ),
  );

  final pinControllerEmail = TextEditingController();
  final focusNodeEmail = FocusNode();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Palette.bgBlue1, Palette.bgBlue2]),
        ),
        child: isLoading == true
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 40),
                    child: Text(
                      "Please enter Master PIN",
                      style: TextStyles.masterPinTitle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Pinput(
                          length: 4,
                          controller: pinControllerEmail,
                          focusNode: focusNodeEmail,
                          defaultPinTheme: defaultPinTheme,
                          hapticFeedbackType: HapticFeedbackType.lightImpact,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          errorTextStyle: TextStyles.errorPinStyle,
                          onChanged: (value) {
                            setState(() {
                              showPin = false;
                              enterPin = value;
                            });
                          },
                          onCompleted: (value) async {
                            verifyMasterPin();
                          },
                          focusedPinTheme: focusedPinTheme,
                          submittedPinTheme: submittedPinTheme,
                          errorPinTheme: errorPinTheme),
                    ),
                  ),
                  if (showPin)
                    const Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: Text(
                        "Forgot PIN?",
                        style: TextStyles.paraBigBoldWhite,
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
