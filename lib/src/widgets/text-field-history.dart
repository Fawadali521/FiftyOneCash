import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextFieldHistory extends StatefulWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback onTap;
  const TextFieldHistory({
    super.key,
    required this.hint,
    this.onChanged,
    required this.onTap,
  });
  @override
  State<TextFieldHistory> createState() => _TextFieldHistoryState();
}

class _TextFieldHistoryState extends State<TextFieldHistory> {
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
        suffixIcon: InkWell(
          onTap: widget.onTap,
          child: const Icon(
            CupertinoIcons.search,
            color: Palette.primaryColor,
            size: 20,
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
