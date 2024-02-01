import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';

class BottomSheetButtons extends StatelessWidget {
  const BottomSheetButtons(
      {super.key,
      required this.width,
      this.onTap,
      this.buttonText,
      this.icon,
      required this.isLoading});

  final VoidCallback? onTap;
  final String? buttonText;
  final IconData? icon;
  final bool isLoading;

  final double width;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: Palette.secondaryColor,
            ),
          )
        : InkWell(
            onTap: onTap,
            child: SizedBox(
              width: width,
              height: 40,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                      borderRadius: BorderStyles.norm2,
                      color: Palette.grey,
                    ),
                    child: Icon(
                      icon ?? Icons.email,
                      color: Palette.secondaryColor,
                      size: 22,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      buttonText ?? "Send Message",
                      style: TextStyles.contactDraggableSheetButtonText,
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
