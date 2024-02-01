// created by MHK-MotoVlogs

import 'package:fifty_one_cash/landing-page.dart';
import 'package:fifty_one_cash/src/modules/auth/SignUp.dart';
import 'package:fifty_one_cash/src/services/ApiService.dart';
import 'package:fifty_one_cash/src/services/toast-msg.dart';
import 'package:fifty_one_cash/src/widgets/button-one.dart';
import 'package:fifty_one_cash/src/widgets/password-field.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class NewPasswordPage extends StatefulWidget {
  final String otp;
  final String phoneNumber;

  const NewPasswordPage(
      {super.key, required this.phoneNumber, required this.otp});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  String? password;
  bool isLoading = false;
  Future<void> handleChangePassword() async {
    if (password == null || password!.trim().isEmpty) {
      ToastMsg().sendErrorMsg("Password is required");
      return;
    } else {
      try {
        setState(() {
          isLoading = true;
        });
        bool? result = await ApiService().chagnePassword(
            mobileNumber: widget.phoneNumber,
            otp: widget.otp,
            newPassword: password!);
        if (result != true) {
          setState(() {
            isLoading = false;
          });
        } else {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: const LandingPage(
                  navigationFromForgetPassword: true,
                ),
              ),
            );
          }
        }
      } catch (error) {
        // ToastMsg().sendErrorMsg("Error: $error");
        setState(() {
          isLoading = false;
        });
      }
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
                      "Let's Enter New Password".toUpperCase(),
                      style: TextStyles.headingBoldBlack,
                      textAlign: TextAlign.center,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Opacity(
                          opacity: 0.4,
                          child: Text(
                            "Enter your new password bellow",
                            style: TextStyles.bodyBlack,
                            textAlign: TextAlign.center,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Row(
                              children: [
                                Text(
                                  "New Password",
                                  style: TextStyles.paraBlack,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: width - 40,
                            child: PasswordField(
                              onChanged: (x) {
                                setState(() {
                                  password = x;
                                });
                              },
                              hint: "Enter New Password",
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
                            await handleChangePassword();
                          },
                          title: "Change Password".toUpperCase(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Don't Have an Account?",
                            style: TextStyles.bodyBlack,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child: const SignUp()));
                            },
                            child: const Text(
                              "SIGN UP",
                              style: TextStyles.bodyBigBold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30, top: 20),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                              text: 'By Signing In, you accept our ',
                              style: TextStyles.bodyBlack,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {}),
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
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {}),
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
              )
            ],
          ),
        ));
  }
}
