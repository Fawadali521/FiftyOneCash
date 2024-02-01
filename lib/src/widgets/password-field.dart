import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class PasswordField extends StatefulWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatter;
  final bool isEnable;

  const PasswordField(
      {super.key,
      this.hint = '',
      required this.onChanged,
      this.inputFormatter,
      this.isEnable = true});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: widget.onChanged,
      autofocus: false,
      obscureText: _obscureText ? true : false,
      style: TextStyles.bodyBlack,
      cursorColor: Palette.primaryColor,
      inputFormatters: widget.inputFormatter,
      decoration: InputDecoration(
        isDense: true,
        hintText: widget.hint,
        hintStyle: TextStyles().bodyBlackLight,
        border: const OutlineInputBorder(
          borderRadius: BorderStyles.norm2,
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        fillColor: Palette.lightGrey3,
        suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscureText ? _obscureText = false : _obscureText = true;
              });
            },
            child: Icon(
              _obscureText
                  ? Icons.remove_red_eye
                  : Icons.remove_red_eye_outlined,
              color: Palette.black2,
              size: 20,
            )),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14.0, horizontal: 12),
      ),
    );
  }
}
