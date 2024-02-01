import 'package:avatar_glow/avatar_glow.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';

class TextFieldSearch extends StatefulWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback onTap;
  final IconData? icon;

  // Edited by MHK-MotoVlogs
  final VoidCallback? onEditingComplete;
  final TextEditingController? controller;
  final Widget? prefixIcon;

  const TextFieldSearch({
    super.key,
    required this.hint,
    this.onChanged,
    required this.onTap,
    this.onEditingComplete,
    this.controller,
    this.icon,
    this.prefixIcon,
  });

  @override
  State<TextFieldSearch> createState() => _TextFieldSearchState();
}

class _TextFieldSearchState extends State<TextFieldSearch> {
  Duration avtar = const Duration(milliseconds: 2000);
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: widget.onChanged,
      controller: widget.controller,
      autofocus: false,
      onEditingComplete: widget.onEditingComplete,
      style: TextStyles.bodyBlack,
      cursorColor: Palette.primaryColor,
      decoration: InputDecoration(
        isDense: true,
        hintText: widget.hint,
        prefixIcon: widget.prefixIcon,
        hintStyle: TextStyles().bodyBlackLight,
        suffixIcon: InkWell(
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: widget.icon != null
                ? Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Palette.secondaryColor,
                    ),
                    child: Icon(
                      widget.icon,
                      color: Colors.white,
                      size: 20,
                    ),
                  )
                : const ImageIcon(
                    AssetImage("assets/icons/qr-code-scan.png"),
                    color: Palette.primaryColor,
                  ),
          ),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderStyles.norm2,
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        fillColor: Palette.lightGrey3,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14.0, horizontal: 12),
        // contentPadding:
        //     const EdgeInsets.only(top: 12, right: 10, left: 10, bottom: 12)),
      ),
    );
  }
}
