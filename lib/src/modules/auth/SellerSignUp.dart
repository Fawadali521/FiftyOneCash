import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:fifty_one_cash/src/modules/auth/SignIn.dart';
import 'package:fifty_one_cash/src/modules/auth/Verify.dart';
import 'package:fifty_one_cash/src/widgets/button-one.dart';
import 'package:fifty_one_cash/src/widgets/password-field.dart';
import 'package:fifty_one_cash/src/widgets/text-field-one.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SellerSignUp extends StatefulWidget {
  const SellerSignUp({super.key});

  @override
  State<SellerSignUp> createState() => _SellerSignUpState();
}

class _SellerSignUpState extends State<SellerSignUp> {
  DateTime? selectedDate;
  PageController pageController = PageController(initialPage: 0);
  int currentPage = 0;
  List<String> organizationType = [
    "Sole trader",
    "Partnership",
    "Limited Liability Company",
    "Charity Organization",
    "Government Organization"
  ];

  String? organizationValue;

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime(1900, 1),
        lastDate: DateTime(2101),
        initialDate: DateTime.now());
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
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
                      "Let's Sign You Up".toUpperCase(),
                      style: TextStyles.headingBoldBlack,
                      textAlign: TextAlign.center,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Opacity(
                          opacity: 0.4,
                          child: Text(
                            "Please enter name as it appears on your\nOfficial Documents",
                            style: TextStyles.bodyBlack,
                            textAlign: TextAlign.center,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                            3,
                            (index) => Padding(
                                  padding: const EdgeInsets.only(
                                      left: 2.5, right: 2.5),
                                  child: Container(
                                    height: 7,
                                    width: 25,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderStyles.norm2,
                                        color: (index <= currentPage)
                                            ? Palette.primaryColor
                                            : Palette.lightGrey3),
                                  ),
                                )),
                      ),
                    ),
                    SizedBox(
                      width: width - 40,
                      child: ExpandablePageView(
                        controller: pageController,
                        scrollDirection: Axis.horizontal,
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 5),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Organization Name",
                                            style: TextStyles.paraBlack,
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: width - 40,
                                      child: TextFieldOne(
                                        onChanged: (x) {},
                                        hint: "Enter Your Organization Name",
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
                                            "Organization Type",
                                            style: TextStyles.paraBlack,
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: (width - 40),
                                      height: 45,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderStyles.norm2,
                                        color: Palette.lightGrey3,
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: ButtonTheme(
                                          alignedDropdown: true,
                                          child: DropdownButton(
                                            isDense: true,
                                            icon: const Icon(
                                                Icons
                                                    .keyboard_arrow_down_rounded,
                                                size: 20,
                                                color: Colors.black),
                                            // hides the dropdown icon
                                            hint: const Opacity(
                                              opacity: 0.5,
                                              child: Text(
                                                "Select Your Organization Type",
                                                style: TextStyles.bodyBlack,
                                              ),
                                            ),
                                            value: organizationValue,
                                            items:
                                                organizationType.map((value) {
                                              return DropdownMenuItem(
                                                value: value.toString(),
                                                child: Text(
                                                  value.toString(),
                                                  style: TextStyles.bodyBlack,
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                organizationValue = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 5),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Director/Owner's Name",
                                            style: TextStyles.paraBlack,
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: width - 40,
                                      child: TextFieldOne(
                                        onChanged: (x) {},
                                        hint: "Enter Director/Owner's Name",
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
                                            "Organization Address",
                                            style: TextStyles.paraBlack,
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: width - 40,
                                      child: TextFieldOne(
                                        onChanged: (x) {},
                                        hint: "Enter Your Organization Address",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
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
                                      child: TextFieldOne(
                                        onChanged: (x) {},
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
                                            "Business Email Address",
                                            style: TextStyles.paraBlack,
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: width - 40,
                                      child: TextFieldOne(
                                        onChanged: (x) {},
                                        hint:
                                            "Enter Your Business Email Address",
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
                                        onChanged: (x) {},
                                        hint: "Enter Your Password",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // if (currentPage == 0)
                    //   Padding(
                    //     padding: const EdgeInsets.only(top: 10),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.end,
                    //       children: [
                    //         InkWell(
                    //           onTap: () {
                    //             // Navigator.push(
                    //             //     context,
                    //             //     PageTransition(
                    //             //         type: PageTransitionType.fade,
                    //             //         child: const SellerSignUp()));
                    //           },
                    //           child: const Text(
                    //             "Forgot password?",
                    //             style: TextStyles.bodyBlack,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: SizedBox(
                        width: width - 40,
                        height: 45,
                        child: ButtonOne(
                          onTap: () {
                            if (currentPage == 0) {
                              pageController.animateToPage(1,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeIn);
                              setState(() {
                                currentPage = 1;
                              });
                            } else if (currentPage == 1) {
                              pageController.animateToPage(2,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeIn);
                              setState(() {
                                currentPage = 2;
                              });
                            } else if (currentPage == 2) {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child: const Verify()));
                            }
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
                              "SIGN IN!",
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
                              text: 'By Signing Up, you accept our ',
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
