import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserProfileImageContainer extends StatelessWidget {
  final double size;
  const UserProfileImageContainer({
    super.key,
    this.userProfileImage,
    this.size = 102,
  });

  final Uint8List? userProfileImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Palette.sky,
        borderRadius: BorderRadius.circular(100),
      ),

      // Edited by MHK-MotoVlogs
      child: Center(
        child: Container(
          height: size - 4,
          width: size - 4,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Palette.bgBlue1, Palette.bgBlue2]),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Center(
            child: Container(
              height: size - 8,
              width: size - 8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  image: userProfileImage == null
                      ? const DecorationImage(
                          image: AssetImage("assets/icons/personavator.png"),
                          fit: BoxFit.cover)
                      : DecorationImage(
                          image: MemoryImage(
                            userProfileImage!,
                          ),
                          fit: BoxFit.cover,
                        )),
            ),
          ),
        ),
      ),
    );
  }
}
