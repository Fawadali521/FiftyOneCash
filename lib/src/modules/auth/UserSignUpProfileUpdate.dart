import 'package:fifty_one_cash/src/modules/dashboard/master_pin/SetUpMasterPin.dart';
import 'package:fifty_one_cash/src/services/ApiService.dart';
import 'package:fifty_one_cash/src/services/toast-msg.dart';
import 'package:fifty_one_cash/src/widgets/UserNameTextField.dart';
import 'package:fifty_one_cash/src/widgets/button-one.dart';
import 'package:fifty_one_cash/src/widgets/text-field-one.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

class UserSignUpProfileUpdate extends StatefulWidget {
  const UserSignUpProfileUpdate({super.key});

  @override
  State<UserSignUpProfileUpdate> createState() =>
      _UserSignUpProfileUpdateState();
}

class _UserSignUpProfileUpdateState extends State<UserSignUpProfileUpdate> {
  DateTime? selectedDate;
  String? userName;
  String? gender;
  List<String> genderOptions = ['MALE', 'FEMALE', 'NOT_DISCLOSED'];
  String? firstName;
  String? lastName;
  Icon? usernameIcon;
  bool isLoading = false;
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

  checkUserName(value) async {
    if (value != "" && value.length > 4) {
      bool? isAvailable = await ApiService().checkUserNameAvailability(value);
      if (isAvailable == true) {
        setState(() {
          userName = value;
          usernameIcon = const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 20,
          );
        });
      } else if (isAvailable == false) {
        setState(() {
          userName =
              null; // You can choose to keep the entered value if you want
          usernameIcon = const Icon(
            Icons.error,
            color: Colors.red,
            size: 20,
          );
        });
      } else {
        setState(() {
          userName = null;
          usernameIcon = null;
        });
        ToastMsg().sendErrorMsg("Error checking username availability.");
      }
    } else {
      ToastMsg().sendErrorMsg("Username must be at least 5 characters long.");
      setState(() {
        userName = null;
        usernameIcon = null;
      });
    }
  }

  Future<void> handleUserUpdate() async {
    if (firstName == null || firstName!.trim().isEmpty) {
      return ToastMsg().sendErrorMsg("First name is required");
    } else if (lastName == null || lastName!.trim().isEmpty) {
      return ToastMsg().sendErrorMsg("Last name is required");
    } else if (userName == null || userName!.trim().isEmpty) {
      return ToastMsg().sendErrorMsg("Username is required");
    } else if (userName!.length > 50) {
      return ToastMsg()
          .sendErrorMsg("Username length should not exceed 50 characters");
    } else if (selectedDate == null) {
      return ToastMsg().sendErrorMsg("Date of birth is required");
    } else if (gender == null) {
      return ToastMsg().sendErrorMsg("Select your gender!");
    }

    // Convert selectedDate to string in YYYY-MM-DD format
    String? dobStr;
    if (selectedDate != null) {
      setState(() {
        dobStr =
            "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}";
      });
    }

    try {
      if (kDebugMode) {
        print("dobStr: $dobStr");
      }
      setState(() {
        isLoading = true;
      });
      print("isLoading: $isLoading");
      bool? isSuccess = await ApiService().updateUser(
        firstname: firstName!.trim(),
        lastname: lastName!.trim(),
        username: userName!.trim(),
        gender: gender,
        dob: dobStr,
      );

      if (isSuccess != null && isSuccess) {
        setState(() {
          isLoading = false;
        });
        ToastMsg().sendSuccessMsg("User data updated successfully");
        if (mounted) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: const SetUpMasterPin(),
            ),
          );
        }
      } else {
        ToastMsg().sendErrorMsg("Failed to update user data");
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      ToastMsg().sendErrorMsg("Error: $error");
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
                    Column(
                      children: [
                        Text(
                          "Update your profile".toUpperCase(),
                          style: TextStyles.headingBoldBlack,
                          textAlign: TextAlign.center,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Opacity(
                              opacity: 0.4,
                              child: Text(
                                "Please enter your details same as official documents",
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
                                      "First Name",
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
                                      firstName = x;
                                    });
                                  },
                                  hint: "Enter Your First Name",
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
                                      "Last Name",
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
                                      lastName = x;
                                    });
                                  },
                                  hint: "Enter Your Last Name",
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
                                      "User Name",
                                      style: TextStyles.paraBlack,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: width - 40,
                                child: UserNameTextField(
                                  onChanged: (value) async {
                                    await checkUserName(value);
                                  },
                                  hint: "Enter Unique User Name",
                                  suffixIcon: usernameIcon,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Date Of Birth",
                                      style: TextStyles.paraBlack,
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      width: (width - 40 - 20) / 2,
                                      child: const Text(
                                        "Gender",
                                        style: TextStyles.paraBlack,
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                      width: (width - 40 - 20) / 2,
                                      child: InkWell(
                                        onTap: () {
                                          selectDate(context);
                                        },
                                        child: Container(
                                          width: (width - 40 - 20) / 2,
                                          height: 45,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderStyles.norm2,
                                            color: Palette.lightGrey3,
                                          ),
                                          child: Center(
                                              child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 12),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                (selectedDate == null)
                                                    ? Text(
                                                        "Select Your DOB",
                                                        style: TextStyles()
                                                            .bodySemiBlack,
                                                      )
                                                    : Text(
                                                        DateFormat.yMMMMd()
                                                            .format(
                                                                selectedDate!),
                                                        style: TextStyles
                                                            .bodyBlack,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                              ],
                                            ),
                                          )),
                                        ),
                                      )),
                                  SizedBox(
                                    width: (width - 40 - 20) / 2,
                                    child: Container(
                                      width: (width - 40 - 20) / 2,
                                      height: 45,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderStyles.norm2,
                                        color: Palette.lightGrey3,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Theme(
                                        data: Theme.of(context).copyWith(
                                          canvasColor: Colors.white,
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: gender,
                                            isExpanded: true,
                                            hint: Text(
                                              "Select Gender",
                                              style: TextStyles().bodySemiBlack,
                                            ),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                gender = newValue;
                                              });
                                            },
                                            items: genderOptions
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value,
                                                    style:
                                                        TextStyles.bodyBlack),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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
                                await handleUserUpdate();
                              },
                              title: "Continue".toUpperCase(),
                            ),
                          ),
                        ),
                      ],
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
