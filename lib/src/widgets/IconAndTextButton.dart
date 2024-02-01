import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';

class IconAndTextButton extends StatelessWidget {
  const IconAndTextButton({
    super.key,
    this.onTap,
    this.title,
    this.icon,
    this.iconColor,
    this.backgroundColor,
    this.textStyle,
    this.iconSize,
    this.height,
    this.width,
    this.border,
    this.isLoading,
    this.progressIndicatorColor,
    this.borderRadius,
  });

  final VoidCallback? onTap;
  final String? title;
  final IconData? icon;

  final Color? iconColor;
  final Color? backgroundColor;
  final Color? progressIndicatorColor;

  final double? iconSize;
  final double? height;
  final double? width;

  final TextStyle? textStyle;

  final Border? border;
  final BorderRadius? borderRadius;

  final bool? isLoading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading == false ? onTap : null,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: borderRadius ?? BorderStyles.norm2,
          border: border ?? Border.all(color: Palette.grey2),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: isLoading == true
              ? Center(
                  child: CircularProgressIndicator(
                    color: progressIndicatorColor ?? Colors.white,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon ?? Icons.email_sharp,
                      color: iconColor ?? Palette.secondaryColor,
                      size: iconSize ?? 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        title ?? "Send Message",
                        style: textStyle ?? TextStyles.bodyBigNormal,
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
