import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';

class PaymentMsgField extends StatefulWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  const PaymentMsgField({super.key, required this.hint, this.onChanged});

  @override
  State<PaymentMsgField> createState() => _PaymentMsgFieldState();
}

class _PaymentMsgFieldState extends State<PaymentMsgField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextField(
        onChanged: widget.onChanged,
        autofocus: false,
        style: TextStyles.paymentFieldText,
        // keyboardType: TextInputType.number,
        cursorColor: Colors.white.withOpacity(0.5),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyles().paymentFieldTextHint,
          // prefixIcon: const Padding(
          //   padding: EdgeInsets.all(12.0),
          //   child: ImageIcon(AssetImage("assets/icons/commerce.png"),
          //       color: Colors.white),
          // ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderStyles.norm2,
            borderSide: BorderSide(
              width: 1,
              style: BorderStyle.solid,
              color: Colors.white.withOpacity(0.5),
            ),
          ),

          focusColor: Colors.white,
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderStyles.norm2,
            borderSide: BorderSide(
              width: 1,
              style: BorderStyle.solid,
              color: Colors.white,
            ),
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 7.0, horizontal: 10),
          // contentPadding:
          //     const EdgeInsets.only(top: 12, right: 10, left: 10, bottom: 12)),
        ),
      ),
    );
  }
}
