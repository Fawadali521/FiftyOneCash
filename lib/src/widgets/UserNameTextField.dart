import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserNameTextField extends StatefulWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatter;
  final bool isEnable;
  final Icon? suffixIcon;
  final TextEditingController? controller;
  final Widget? prefixIcon;

  final Color? fillColor;

  final TextStyle? hintTextStyle;
  final TextStyle? textStyle;

  final VoidCallback? onEditingComplete;
  const UserNameTextField(
      {super.key,
      this.hint = '',
      required this.onChanged,
      this.inputFormatter,
      this.isEnable = true,
      this.suffixIcon,
      this.controller,
      this.prefixIcon,
      this.onEditingComplete,
      this.fillColor,
      this.hintTextStyle,
      this.textStyle});

  @override
  State<UserNameTextField> createState() => _UserNameTextFieldState();
}

class _UserNameTextFieldState extends State<UserNameTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      //Edited by MHK-MotoVlogs
      controller: widget.controller,
      //end
      onChanged: widget.onChanged,
      autofocus: false,

      style: TextStyles.bodyBlack,
      cursorColor: Palette.primaryColor,
      inputFormatters: widget.inputFormatter,
      onEditingComplete: widget.onEditingComplete,
      decoration: InputDecoration(
        isDense: true, suffixIcon: widget.suffixIcon,

        hintText: widget.hint,
        hintStyle: widget.hintTextStyle ?? TextStyles().bodyBlackLight,
        prefixIcon: widget.prefixIcon,
        filled: true,
        fillColor: Palette.lightGrey3,
        border: const OutlineInputBorder(
          borderRadius: BorderStyles.norm2,
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),

        contentPadding:
            const EdgeInsets.symmetric(vertical: 14.0, horizontal: 12),
        // contentPadding:
        //     const EdgeInsets.only(top: 12, right: 10, left: 10, bottom: 12)),
      ),
    );
  }
}
