import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';

class ButtonOne extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final bool isLoading;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final double? height;
  final double? width;
  final bool? showShadow;
  final Color? circularProgressColor;

  const ButtonOne({
    Key? key,
    required this.onTap,
    required this.title,
    this.isLoading = false,
    this.textStyle,
    this.backgroundColor,
    this.height,
    this.width,
    this.showShadow,
    this.circularProgressColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading != true ? onTap : null,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderStyles.norm2,
          boxShadow: showShadow == false
              ? null
              : [
                  BoxShadow(
                    color: Palette.sky.withOpacity(0.5),
                    blurRadius: 4,
                    spreadRadius: 2,
                  )
                ],
          gradient: backgroundColor != null
              ? null
              : const LinearGradient(
                  colors: [
                    Palette.primaryColor,
                    Palette.secondaryColor,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
        ),
        child: Center(
          child: isLoading == true
              ? SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        circularProgressColor ?? Colors.white.withOpacity(0.9)),
                  ),
                )
              : Text(
                  title,
                  style: textStyle ?? TextStyles.buttonWhiteOne,
                ),
        ),
      ),
    );
  }
}
