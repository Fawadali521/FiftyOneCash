import 'package:fifty_one_cash/src/modules/auth/UserSignUpProfileUpdate.dart';
import 'package:fifty_one_cash/src/modules/auth/NewPasswordPage.dart';
import 'package:fifty_one_cash/src/modules/auth/SignIn.dart';
import 'package:fifty_one_cash/src/services/ApiService.dart';
import 'package:fifty_one_cash/src/services/toast-msg.dart';
import 'package:fifty_one_cash/src/widgets/button-one.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pinput/pinput.dart';

class UserSignUpVerify extends StatefulWidget {
  final String mobileNumber;

  // Edited by MHK-MotoVlogs
  final bool? navigationFromForgetPassword;
  const UserSignUpVerify(
      {super.key,
      required this.mobileNumber,
      this.navigationFromForgetPassword});

//end

  @override
  State<UserSignUpVerify> createState() => _UserSignUpVerifyState();
}

class _UserSignUpVerifyState extends State<UserSignUpVerify> {
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyles.bodyBigBold,
    decoration: BoxDecoration(
      borderRadius: BorderStyles.norm2,
      border: Border.all(color: Palette.primaryColor.withOpacity(0.5)),
    ),
  );
  final pinControllerEmail = TextEditingController();
  final focusNodeEmail = FocusNode();
  final pinControllerPhone = TextEditingController();
  final focusNodePhone = FocusNode();
  final focusedBorderColor = Palette.primaryColor.withOpacity(0.5);
  final fillColor = Palette.chatUiBg2.withOpacity(0.1);
  final borderColor = Palette.primaryColor;
  String? enterOtp;
  bool isLoading = false;
  handelOtpVerify() async {
    if (enterOtp != null && enterOtp!.length == 6) {
      setState(() {
        isLoading = true;
      });
      bool? isOtpVerified = await ApiService()
          .verifyMobileOtp(mobileNumber: widget.mobileNumber, otp: enterOtp!);
      if (isOtpVerified == true) {
        setState(() {
          isLoading = false;
        });
        ToastMsg().sendSuccessMsg("OTP verified successfully!");
        // Navigate to next screen or perform any other actions.
        if (mounted) {
          //Edited by MHK-MotoVlogs

          if (widget.navigationFromForgetPassword == true) {
            Navigator.pushReplacement(
                context,
                PageTransition(
                    type: PageTransitionType.fade,
                    child: NewPasswordPage(
                      otp: enterOtp!,
                      phoneNumber: widget.mobileNumber,
                    )));
          } else {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.fade,
                    child: const UserSignUpProfileUpdate()));
          }

          //end
        }
      } else if (isOtpVerified == false) {
        setState(() {
          isLoading = false;
        });
        ToastMsg().sendErrorMsg("Incorrect OTP. Please try again.");
      } else {
        setState(() {
          isLoading = false;
        });
        ToastMsg().sendErrorMsg("Error occurred while verifying OTP.");
      }
    } else {
      setState(() {
        isLoading = false;
      });
      ToastMsg().sendErrorMsg("Please enter a 6-digit OTP.");
    }
  }

  handleResend() async {
    bool? isOtpResent = await ApiService().resendMobileOtp(
      mobileNumber: widget.mobileNumber,
      countryCode:
          widget.mobileNumber, // Assuming you're always using +91 for now
    );

    if (isOtpResent == true) {
      ToastMsg().sendSuccessMsg("OTP resent successfully!");
    } else if (isOtpResent == false) {
      ToastMsg().sendErrorMsg("Failed to resend OTP. Please try again.");
    } else {
      ToastMsg().sendErrorMsg("Error occurred while resending OTP.");
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
                      "VERIFY PHONE NUMBER".toUpperCase(),
                      style: TextStyles.headingBoldBlack,
                      textAlign: TextAlign.center,
                    ),
                    // Edited by MHK-MotoVlogs
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Opacity(
                          opacity: 0.4,
                          child: Text(
                            "A verification code was sent to\n ${widget.mobileNumber}",
                            // end
                            style: TextStyles.bodyBlack,
                            textAlign: TextAlign.center,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          Pinput(
                            length: 6,
                            controller: pinControllerEmail,
                            focusNode: focusNodeEmail,
                            androidSmsAutofillMethod:
                                AndroidSmsAutofillMethod.smsUserConsentApi,
                            listenForMultipleSmsOnAndroid: true,
                            defaultPinTheme: defaultPinTheme,
                            hapticFeedbackType: HapticFeedbackType.lightImpact,
                            onChanged: (value) {
                              setState(() {
                                enterOtp = value;
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
                      padding: const EdgeInsets.only(top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () async {
                              await handleResend();
                            },
                            child: const Text(
                              "Resend Code",
                              style: TextStyles.bodyBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: SizedBox(
                        width: width - 40,
                        height: 45,
                        child: ButtonOne(
                          isLoading: isLoading,
                          onTap: () async {
                            await handelOtpVerify();
                          },
                          title: "Continue".toUpperCase(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Already Have an Account?",
                            style: TextStyles.bodyBlack,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child: const SignIn()));
                            },
                            child: const Text(
                              "SIGN IN",
                              style: TextStyles.bodyBigBold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 30,
                  top: 20,
                  left: 20,
                  right: 20,
                ),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: 'By Signing Up, you accept our ',
                        style: TextStyles.bodyBlack,
                        recognizer: TapGestureRecognizer()..onTap = () {}),
                    TextSpan(
                        text: 'Terms Of Service',
                        style: TextStyles.bodyBigBold,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Navigator.push(
                            //     context,
                            //     PageTransition(
                            //         type: PageTransitionType.fade, child: const TermsConditions()));
                          }),
                    TextSpan(
                        text: ' and ',
                        style: TextStyles.bodyBlack,
                        recognizer: TapGestureRecognizer()..onTap = () {}),
                    TextSpan(
                        text: 'Privacy Policy.',
                        style: TextStyles.bodyBigBold,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Navigator.push(
                            //     context,
                            //     PageTransition(
                            //         type: PageTransitionType.fade, child: const PrivacyPolicy()));
                          }),
                  ]),
                ),
              ),
            ],
          ),
        ));
  }
}
