import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';

class GradientTextButton extends StatelessWidget {
  const GradientTextButton(
      {super.key,
      this.buttonText,
      this.gradientColor,
      this.onTap,
      this.width,
      this.paddingVertical});

  final Gradient? gradientColor;
  final String? buttonText;
  final VoidCallback? onTap;
  final double? width;
  final double? paddingVertical;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          width: width,
          padding: EdgeInsets.symmetric(
              horizontal: 42, vertical: paddingVertical ?? 8),
          decoration: BoxDecoration(
              gradient: gradientColor ??
                  const LinearGradient(
                    colors: [
                      Palette.primaryColor,
                      Palette.secondaryColor,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
              borderRadius: BorderStyles.norm2),
          child: Text(
            buttonText ?? "Accept",
            textAlign: TextAlign.center,
            style: TextStyles.gradientButton,
          )),
    );
  }
}
