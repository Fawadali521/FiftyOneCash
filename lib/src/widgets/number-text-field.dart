import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';

class NumberTextField extends StatefulWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  const NumberTextField({super.key, required this.hint, this.onChanged});

  @override
  State<NumberTextField> createState() => _NumberTextFieldState();
}

class _NumberTextFieldState extends State<NumberTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: widget.onChanged,
      autofocus: false,
      style: TextStyles.bodyBlack,
      cursorColor: Palette.primaryColor,
      decoration: InputDecoration(
        isDense: true,
        hintText: widget.hint,
        hintStyle: TextStyles().bodyBlackLight,
        // suffix: ,
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
      ),
    );
  }
}
