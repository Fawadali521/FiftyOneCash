import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';

class NoContactImageWithOpacityAnimation extends StatelessWidget {
  const NoContactImageWithOpacityAnimation(
      {super.key,
      required this.height,
      required this.width,
      this.targetOpacity = 0});
  final double height;
  final double width;
  final double targetOpacity;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(seconds: 1),
      builder: (context, double value, child) => Opacity(
        opacity: value,
        child: Column(
          children: [
            Container(
              width: width,
              height: width / 1.5,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/icons/no_contacts_image.png"),
                    fit: BoxFit.fill),
              ),
            ),
            const Text(
              "Empty Contact List",
              textAlign: TextAlign.center,
              style: TextStyles.emptyContactsStype,
            ),
          ],
        ),
      ),
    );
  }
}
