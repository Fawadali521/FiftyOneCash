import 'package:fifty_one_cash/datas.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';

class TextFieldCountryCode extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCountryCodeChanged;
  final String? initialText;

  const TextFieldCountryCode({
    Key? key,
    this.onChanged,
    this.onCountryCodeChanged,
    this.initialText,
  }) : super(key: key);

  @override
  State<TextFieldCountryCode> createState() => _TextFieldCountryCodeState();
}

class _TextFieldCountryCodeState extends State<TextFieldCountryCode> {
  String? dropdownValue;
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    dropdownValue =
        Datas().dropdownItems.first; // Initialize with the first item

    if (widget.initialText != null) {
      _controller = TextEditingController(text: widget.initialText);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Container(
            width: 55,
            height: 50,
            decoration: const BoxDecoration(
              borderRadius: BorderStyles.norm2,
              color: Palette.lightGrey3,
            ),
            child: Center(
              child: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Colors.white,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    icon: const SizedBox.shrink(),
                    style: TextStyles.bodyBlack,
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                      if (widget.onCountryCodeChanged != null &&
                          newValue != null) {
                        widget.onCountryCodeChanged!(newValue);
                      }
                    },
                    items: Datas()
                        .dropdownItems
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 3.0, right: 3),
                          child: Text(
                            value,
                            style: TextStyles().bodyBlackLight,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: width - 40 - 55 - 15,
          height: 50,
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            onChanged: widget.onChanged,
            style: TextStyles.bodyBlack,
            cursorColor: Palette.primaryColor,
            decoration: InputDecoration(
              isDense: true,
              hintText: widget.initialText ?? 'Enter your phone number',
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
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
