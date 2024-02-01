import 'package:fifty_one_cash/src/modules/dashboard/dashboard.dart';
import 'package:fifty_one_cash/src/widgets/payment-field.dart';
import 'package:fifty_one_cash/src/widgets/payment-msg-field.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SendPayment extends StatefulWidget {
  final String name;
  final String userId;
  final String userName;
  const SendPayment(
      {super.key,
      required this.name,
      required this.userId,
      required this.userName});
  // SendPayment();

  @override
  State<SendPayment> createState() => _SendPaymentState();
}

class _SendPaymentState extends State<SendPayment> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient:
                  LinearGradient(colors: [Palette.bgBlue1, Palette.bgBlue2])),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                PageTransition(
                    type: PageTransitionType.fade,
                    child: const DashBoard(
                      page: 2,
                    )));
          },
        ),
        title: const Text(
          "Send Money",
          style: TextStyles.homeBigBoldWhiteText,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.info_outline,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
            gradient:
                LinearGradient(colors: [Palette.bgBlue1, Palette.bgBlue2])),
        child: Column(
          children: [
            const SafeArea(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 4),
              child: Container(
                height: 102,
                width: 102,
                decoration: BoxDecoration(
                  color: Palette.sky,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Container(
                    height: 98,
                    width: 98,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Palette.bgBlue1, Palette.bgBlue2]),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                      child: Container(
                        height: 96,
                        width: 96,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                              image: AssetImage("assets/image/me.jpg"),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 7),
              child: Opacity(
                opacity: 0.9,
                child: Text(
                  widget.name,
                  style: TextStyles.buttonWhiteOne,
                ),
              ),
            ),
            Text(
              widget.userName,
              style: TextStyles.bodyWhite,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: PaymentField(
                hint: "Enter Amount",
                onChanged: (x) {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: PaymentMsgField(
                hint: "Send Message (Optional)",
                onChanged: (x) {},
              ),
            ),
            Spacer(),
            SafeArea(
              child: Container(
                width: width,
                height: 50,
                decoration: const BoxDecoration(
                  color: Palette.chatBg,
                ),
                child: const Center(
                    child: Text(
                  "Send",
                  style: TextStyles.buttonWhiteOne,
                  textAlign: TextAlign.center,
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
