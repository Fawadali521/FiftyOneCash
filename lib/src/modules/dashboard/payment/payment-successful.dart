import 'package:avatar_glow/avatar_glow.dart';
import 'package:fifty_one_cash/src/modules/dashboard/dashboard.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class PaymentSuccessful extends StatefulWidget {
  final String name;
  final String amount;
  const PaymentSuccessful(
      {super.key, this.name = "Jhon Reek", this.amount = "100.00"});

  @override
  State<PaymentSuccessful> createState() => _PaymentSuccessfulState();
}

class _PaymentSuccessfulState extends State<PaymentSuccessful>
    with SingleTickerProviderStateMixin {
  Duration duration0 = const Duration(milliseconds: 300);
  Duration duration1 = const Duration(milliseconds: 750);
  Duration duration2 = const Duration(milliseconds: 800);
  Duration duration3 = const Duration(milliseconds: 2000);
  Duration duration4 = const Duration(milliseconds: 2200);
  Duration avtar = const Duration(milliseconds: 2000);
  late AnimationController _controller;
  late Animation<double> _animation;
  bool showFirstWidget = true;
  bool showText = false;
  bool firstAnimatedOpacity = false;
  bool nextAnimatedOpacity = false;
  @override
  void initState() {
    super.initState();

    Future.delayed(duration0, () {
      setState(() {
        firstAnimatedOpacity = true;
      });
    });
    _controller = AnimationController(vsync: this, duration: duration1);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Start the animation
    _controller.forward();

    Future.delayed(duration2, () {
      setState(() {
        showFirstWidget = false;
      });
    });

    Future.delayed(duration3, () {
      setState(() {
        showText = true;
      });
    });
    Future.delayed(duration4, () {
      setState(() {
        nextAnimatedOpacity = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: height,
            width: width,
            decoration: const BoxDecoration(
                gradient:
                    LinearGradient(colors: [Palette.bgBlue1, Palette.bgBlue2])),
            child: AnimatedPadding(
              duration: duration3,
              padding: EdgeInsets.only(
                  left: 20, right: 20, top: 20, bottom: showText ? 70 : 20),
              child: SizedBox(
                height: height * 0.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedPadding(
                        duration: duration3,
                        padding: EdgeInsets.only(bottom: showText ? 20 : 0),
                        child: switcher()),
                    AnimatedOpacity(
                        duration: duration3,
                        opacity: showText ? 1.0 : 0.0,
                        child: _buildThirdWidget()),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: () {
                pushNewScreen(
                  context,
                  screen: const DashBoard(),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
              child: AnimatedOpacity(
                duration: duration1,
                opacity: nextAnimatedOpacity ? 1.0 : 0.0,
                child: Container(
                  height: 55,
                  width: width,
                  decoration: const BoxDecoration(
                    color: Palette.chatBg,
                  ),
                  child: const Center(
                    child: Text(
                      "Done",
                      style: TextStyles.buttonWhiteOne,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFirstWidget() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: const Offset(0.0, 0.0),
          ).animate(_animation),
          child: Transform.scale(
            scale: 1.0 - _animation.value * 0.2,
            child: AnimatedOpacity(
              duration: duration0,
              opacity: firstAnimatedOpacity ? 1.0 : 0.0,
              child: Material(
                elevation: 8.0,
                shape: const CircleBorder(),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    gradient: const LinearGradient(
                      colors: [Palette.bgBlue1, Palette.bgBlue2],
                    ),
                  ),
                  child: Image.asset(
                    'assets/icons/checked.png',
                    height: 80,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSecondWidget() {
    return AvatarGlow(
      glowColor: Colors.white.withOpacity(0.5),
      endRadius: 90.0,
      duration: avtar,
      repeat: true,
      showTwoGlows: true,
      child: Material(
        elevation: 8.0,
        shape: const CircleBorder(),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              gradient: const LinearGradient(
                  colors: [Palette.bgBlue1, Palette.bgBlue2])),
          child: Image.asset(
            'assets/icons/checked.png',
            height: 80,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildThirdWidget() {
    return Text(
      "Payment Of \$${widget.amount} to ${widget.name}\nSuccessful!",
      style: TextStyles.masterPinTitle, // Define this style
      textAlign: TextAlign.center,
    );
  }

  Widget switcher() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: showFirstWidget ? _buildFirstWidget() : _buildSecondWidget(),
    );
  }
}
