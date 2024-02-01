import 'package:fifty_one_cash/src/modules/auth/ForgetPassword.dart';
import 'package:fifty_one_cash/src/modules/auth/SignUp.dart';
import 'package:fifty_one_cash/src/modules/dashboard/dashboard.dart';
import 'package:fifty_one_cash/src/modules/dashboard/master_pin/SetUpMasterPin.dart';
import 'package:fifty_one_cash/src/services/ApiService.dart';
import 'package:fifty_one_cash/src/services/toast-msg.dart';
import 'package:fifty_one_cash/src/widgets/button-one.dart';
import 'package:fifty_one_cash/src/widgets/number-text-field.dart';
import 'package:fifty_one_cash/src/widgets/password-field.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'UserSignUpProfileUpdate.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String? number;
  String? password;
  bool isLoading = false;
  Future<void> handleSignIn() async {
    if (number == null || number!.trim().isEmpty) {
      ToastMsg().sendErrorMsg("Mobile number is required");
      return;
    }

    if (password == null || password!.trim().isEmpty) {
      ToastMsg().sendErrorMsg("Password is required");
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });
      String result = await ApiService()
          .signIn(mobilenumber: number!.trim(), password: password!.trim());
      if (result == "DASHBOARD") {
        ToastMsg().sendSuccessMsg("Successful sign in");
        if (mounted) {
          Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.fade, child: const DashBoard()));
        }
      } else if (result == 'SETUPMASTERPIN') {
        setState(() {
          isLoading = false;
        });
        if (mounted) {
          Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child: const SetUpMasterPin()));
        }
      } else if (result == "UPDATE_REQUIRED") {
        // Navigate to UserSignUpProfileUpdate
        setState(() {
          isLoading = false;
        });
        if (mounted) {
          Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child: const UserSignUpProfileUpdate()));
        }
      } else {
        ToastMsg().sendErrorMsg("Failed to sign in : $result");
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      // ToastMsg().sendErrorMsg("Error: $error");
      setState(() {
        isLoading = false;
      });
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
                      "Let's Sign You In".toUpperCase(),
                      style: TextStyles.headingBoldBlack,
                      textAlign: TextAlign.center,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Opacity(
                          opacity: 0.4,
                          child: Text(
                            "Enter your details bellow",
                            style: TextStyles.bodyBlack,
                            textAlign: TextAlign.center,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Row(
                              children: [
                                Text(
                                  "Phone Number",
                                  style: TextStyles.paraBlack,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: width - 40,
                            child: NumberTextField(
                              onChanged: (x) {
                                setState(() {
                                  number = x;
                                });
                              },
                              hint: "Enter Your Phone Number",
                            ),
                          ),
                        ],
                      ),
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
                                  "Password",
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
                              hint: "Enter Your Password",
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
                            // Edited by MHK-MotoVlogs

                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child: const ForgetPassword()));
                            },
                            //end
                            child: const Text(
                              "Forgot password?",
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
                            await handleSignIn();
                          },
                          title: "Sign In".toUpperCase(),
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
