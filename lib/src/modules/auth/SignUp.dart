import 'package:fifty_one_cash/src/modules/auth/UserSignUpVerify.dart';
import 'package:fifty_one_cash/src/modules/auth/SignIn.dart';
import 'package:fifty_one_cash/src/services/ApiService.dart';
import 'package:fifty_one_cash/src/services/toast-msg.dart';
import 'package:fifty_one_cash/src/widgets/TextFieldCountryCode.dart';
import 'package:fifty_one_cash/src/widgets/button-one.dart';
import 'package:fifty_one_cash/src/widgets/password-field.dart';
import 'package:fifty_one_cash/src/widgets/text-field-one.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? userPhone;
  String countryCode = "+91";
  String? userEmail;
  String? userPassword;
  bool isLoading = false;

  Future<void> handleSignUp() async {
    // Check userPhone
    if (userPhone == null || userPhone == "") {
      ToastMsg().sendErrorMsg("Mobile number is required");
      return;
    }

    // Check countryCode
    if (countryCode == "") {
      ToastMsg().sendErrorMsg("Country code is required");
      return;
    }

    // Check userEmail
    if (userEmail == null || userEmail == "") {
      ToastMsg().sendErrorMsg("Email is required");
      return;
    }

    // Validate email format
    if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(userEmail!)) {
      ToastMsg().sendErrorMsg("Invalid email format");
      return;
    }

    // Check userPassword
    if (userPassword == null || userPassword == "") {
      ToastMsg().sendErrorMsg("Password is required");
      return;
    }
    // If all values are valid, proceed to call the userSignUp method
    try {
      setState(() {
        isLoading = true;
      });
      bool? result = await ApiService().userSignUp(
        email: userEmail!,
        mobileNumber: userPhone!,
        password: userPassword!,
        countryCode: countryCode!,
      );

      if (result != null && result == true) {
        // Handle successful signup
        setState(() {
          isLoading = false;
        });
        ToastMsg().sendSuccessMsg("Successfully OTP Sent!");
        if (mounted) {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: UserSignUpVerify(
                mobileNumber: userPhone!,
              ),
            ),
          );
        }
      } else {
        // Handle unsuccessful signup (specific errors are already shown inside userSignUp)
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      // This will handle any exceptions thrown by userSignUp method.
      // Since you're already showing ToastMsg inside userSignUp for specific errors,
      // you might not need to show another generic toast message here.
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
                      "Let's Sign You Up".toUpperCase(),
                      style: TextStyles.headingBoldBlack,
                      textAlign: TextAlign.center,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Opacity(
                          opacity: 0.4,
                          child: Text(
                            "Please enter your details to continue",
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
                                  "Phone Number",
                                  style: TextStyles.paraBlack,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: width - 40,
                            child: TextFieldCountryCode(
                              onChanged: (x) {
                                setState(() {
                                  userPhone = x;
                                });
                              },
                              onCountryCodeChanged: (code) {
                                setState(() {
                                  countryCode = code;
                                });
                              },
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
                                  "Email Address",
                                  style: TextStyles.paraBlack,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: width - 40,
                            child: TextFieldOne(
                              onChanged: (x) {
                                setState(() {
                                  userEmail = x;
                                });
                              },
                              hint: "Enter Your Email Address",
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
                                  userPassword = x;
                                });
                              },
                              hint: "Enter Your Password",
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: SizedBox(
                        width: width - 40,
                        height: 45,
                        child: ButtonOne(
                          isLoading: isLoading,
                          onTap: () async {
                            await handleSignUp();
                          },
                          title: "Sign Up".toUpperCase(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Already have an account?",
                            style: TextStyles().bodyBlackLight,
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
              )
            ],
          ),
        ));
  }
}
