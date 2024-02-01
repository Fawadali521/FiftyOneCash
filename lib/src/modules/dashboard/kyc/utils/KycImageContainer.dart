import 'dart:io';

import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class KycImageContainer extends StatelessWidget {
  final XFile? kycImage;
  final bool isFront;
  const KycImageContainer({
    super.key,
    required this.kycImage,
    this.isFront = true,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: (width - 40) / 2 - 10,
      height: ((width - 40) / 2 - 10) * 53.98 / 85.6,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          image: kycImage != null
              ? DecorationImage(
                  image: FileImage(
                    File(kycImage!.path),
                  ),
                  fit: BoxFit.fill)
              : null,
          color: Palette.lightGrey3,
          borderRadius: BorderStyles.norm2),
      child: kycImage == null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Opacity(
                  opacity: 0.7,
                  child: Image.asset(
                    isFront
                        ? "assets/icons/card-front.png"
                        : "assets/icons/card-back.png",
                    height: 30,
                    width: 30,
                  ),
                ),
                const Opacity(
                  opacity: 0.5,
                  child: Text(
                    "Choose Image",
                    style: TextStyles.bodySmallBlack,
                  ),
                ),
              ],
            )
          : null,
    );
  }
}
