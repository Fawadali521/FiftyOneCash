import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerTile extends StatelessWidget {
  const ShimmerTile({
    super.key,
    required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 15, top: 15),
      child: Shimmer.fromColors(
        baseColor: Palette.shimmerBaseColor,
        highlightColor: Palette.grey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 5),
                  child: SizedBox(
                    width: width / 1.8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 150,
                          height: 10,
                          color: Colors.black,
                        ),
                        Container(
                          width: 100,
                          height: 10,
                          margin: const EdgeInsets.only(top: 10),
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10.0, right: 10),
              child: Icon(
                Icons.more_vert_rounded,
                size: 25,
                color: Palette.primaryColor,
              ),
            ),
          ],
        ),
      ),
   
    );
  }
}
