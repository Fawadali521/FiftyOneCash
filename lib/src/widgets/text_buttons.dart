import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';

class TextButtons extends StatelessWidget {
  const TextButtons({super.key, this.title, this.onTap, this.isChatSearch});
  final String? title;
  final bool? isChatSearch;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 90,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isChatSearch == true ? Colors.white : Palette.secondaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title ?? "UnSend",
          textAlign: TextAlign.center,
          style: isChatSearch == true
              ? TextStyles.notificationBlueNormal
              : TextStyles.notificationWhiteNormal,
        ),
      ),
    );
  }
}
