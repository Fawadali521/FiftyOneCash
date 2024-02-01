import 'package:fifty_one_cash/src/services/ApiService.dart';
import 'package:fifty_one_cash/src/services/toast-msg.dart';
import 'package:fifty_one_cash/src/widgets/button-one.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

class UpdateMasterPin extends StatefulWidget {
  const UpdateMasterPin(
      {super.key, required this.otp, required this.phoneNumber});
  final String otp;
  final String phoneNumber;
  @override
  State<UpdateMasterPin> createState() => _UpdateMasterPinState();
}

class _UpdateMasterPinState extends State<UpdateMasterPin> {
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
  String? pin;
  bool isLoading = false;

  changeMasterPin() async {
    if (pin != null) {
      isLoading = true;
      if (mounted) {
        setState(() {});
      }
      bool result = await ApiService().updateMasterPin(pin, widget.otp);
      if (result && mounted) {
        Navigator.pop(context);
      }
      isLoading = false;
      if (mounted) {
        setState(() {});
      }
    } else {
      ToastMsg().sendErrorMsg("New pin is missing");
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
        title: const Text(
          "Master Pin",
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
              "Update Master Pin".toUpperCase(),
              style: TextStyles.headingBoldBlack,
              textAlign: TextAlign.center,
            ),
            // Edited by MHK-MotoVlogs
            const Padding(
              padding: EdgeInsets.only(top: 15),
              child: Opacity(
                  opacity: 0.4,
                  child: Text(
                    "Enter your new 4-digit Master PIN for enhanced security in money transfers. Keep it secret, keep it safe.",
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
                    length: 4,
                    controller: pinControllerEmail,
                    focusNode: focusNodeEmail,
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
              padding: const EdgeInsets.only(top: 50),
              child: SizedBox(
                width: width - 40,
                height: 45,
                child: ButtonOne(
                  isLoading: isLoading,
                  onTap: () async {
                    changeMasterPin();
                  },
                  title: "Update".toUpperCase(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
