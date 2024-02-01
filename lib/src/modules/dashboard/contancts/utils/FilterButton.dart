import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  const FilterButton(
      {super.key,
      this.buttonText,
      this.icon,
      this.iconBackgroundColor,
      this.iconColor,
      this.isSelected = false,
      this.onTap});

  final String? buttonText;

  final Color? iconColor;
  final Color? iconBackgroundColor;

  final bool isSelected;

  final IconData? icon;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected
                ? Palette.selectedFilterButtonBorderColor
                : Palette.unselectedFilterButtonBorderColor,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: Palette.selectedFilterButtonBorderColor
                          .withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 10)
                ]
              : null,
          borderRadius: BorderStyles.norm3,
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  color: iconBackgroundColor ?? Colors.amber[300],
                  shape: BoxShape.circle),
              child: Icon(
                icon ?? Icons.person,
                color: iconColor ?? Colors.white,
                size: 18,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text(
                buttonText ?? "My Contacts",
                style: TextStyles.contactListViewButtons,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
