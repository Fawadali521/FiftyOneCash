import 'package:fifty_one_cash/src/modules/dashboard/master_pin/UpdateMasterPin.dart';
import 'package:fifty_one_cash/src/services/ApiService.dart';
import 'package:fifty_one_cash/src/services/SharedData.dart';
import 'package:fifty_one_cash/src/services/toast-msg.dart';
import 'package:fifty_one_cash/src/widgets/button-one.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pinput/pinput.dart';

class SendMasterPinOtp extends StatefulWidget {
  const SendMasterPinOtp({
    super.key,
  });

  @override
  State<SendMasterPinOtp> createState() => _SendMasterPinOtpState();
}

class _SendMasterPinOtpState extends State<SendMasterPinOtp> {
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
  String? mobileNumber;

  bool isLoading = false;
  bool isOtpSend = false;

  handelOtpVerify() async {
    if (enterOtp != null && enterOtp!.length == 6) {
      if (mobileNumber != null) {
        setState(() {
          isLoading = true;
        });
        bool? isOtpVerified = await ApiService().verifyMobileOtp(
            mobileNumber: mobileNumber!,
            otp: enterOtp!,
            isVerificationForMasterPin: true);
        if (isOtpVerified == true) {
          setState(() {
            isLoading = false;
          });
          ToastMsg().sendSuccessMsg("OTP verified successfully!");
          if (mounted) {
            Navigator.pushReplacement(
                context,
                PageTransition(
                    type: PageTransitionType.fade,
                    child: UpdateMasterPin(
                      otp: enterOtp!,
                      phoneNumber: mobileNumber!,
                    )));
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
        ToastMsg().sendErrorMsg("You don't have a phone number save");
      }
    } else {
      setState(() {
        isLoading = false;
      });
      ToastMsg().sendErrorMsg("Please enter a 6-digit OTP.");
    }
  }

  handleResend() async {
    isLoading = true;
    setState(() {});
    if (mobileNumber != null) {
      bool? isOtpResent = await ApiService().sendMobileOtp(
        mobileNumber: mobileNumber!,
      );

      if (isOtpResent == true) {
        isOtpSend = true;
        isLoading = false;
        setState(() {});
        ToastMsg().sendSuccessMsg("OTP resent successfully!");
      } else if (isOtpResent == false) {
        isLoading = false;
        setState(() {});
        ToastMsg().sendErrorMsg("Failed to resend OTP. Please try again.");
      } else {
        isLoading = false;
        setState(() {});
        ToastMsg().sendErrorMsg("Error occurred while resending OTP.");
      }
    }
  }

  getPhoneNumber() async {
    mobileNumber = await SharedData.getPhoneNumber();
  }

  @override
  void initState() {
    getPhoneNumber();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Palette.primaryColor,
                  Palette.secondaryColor,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          title: Text(
            isOtpSend == true ? "Verify OTP" : 'Sent OTP',
            style: TextStyles.appBarTitleWhite,
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              size: 20,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 45),
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                "Verify Phone Number".toUpperCase(),
                style: TextStyles.headingBoldBlack,
                textAlign: TextAlign.center,
              ),
              // Edited by MHK-MotoVlogs
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Opacity(
                    opacity: 0.4,
                    child: Text(
                      isOtpSend
                          ? "A verification code was sent to $mobileNumber. Before Setting New Master Pin you must have to Verify your Phone Number"
                          : 'Unlock the power of security! A verification code will be sent to $mobileNumber. Ensure the safety of your account by verifying your phone number before setting a new Master PIN.',
                      // end
                      style: TextStyles.bodyBlack,
                      textAlign: TextAlign.center,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
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
              if (isOtpSend) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 10),
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
              ],
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: SizedBox(
                  width: width - 40,
                  height: 45,
                  child: ButtonOne(
                    isLoading: isLoading,
                    onTap: () async {
                      if (isOtpSend == true) {
                        await handelOtpVerify();
                      } else {
                        await handleResend();
                      }
                    },
                    title:
                        isOtpSend == true ? "Verify".toUpperCase() : 'SEND OTP',
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
