import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldOne extends StatefulWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatter;
  final bool isEnable;
  final TextEditingController? controller;

  const TextFieldOne(
      {super.key,
      this.hint = '',
      required this.onChanged,
      this.inputFormatter,
      this.isEnable = true,
      this.controller});

  @override
  State<TextFieldOne> createState() => _TextFieldOneState();
}

class _TextFieldOneState extends State<TextFieldOne> {
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
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14.0, horizontal: 12),
        // contentPadding:
        //     const EdgeInsets.only(top: 12, right: 10, left: 10, bottom: 12)),
      ),
    );
  }
}
