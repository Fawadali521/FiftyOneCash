import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile(
      {super.key,
      this.paidTo,
      this.date,
      this.money,
      this.backgroundColorOfImage});

  final String? paidTo;
  final String? date;
  final String? money;
  final Color? backgroundColorOfImage;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(top: height - (height - 20)),
      child: Row(
        children: [
          TransactionImage(
            backgroundColor: backgroundColorOfImage,
          ),
          Container(
            width: width - 92,
            padding: EdgeInsets.only(left: width - (width - 10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      paidTo ?? "Paid To",
                      style: TextStyles.contactScreenTitle,
                    ),
                    Text(
                      date ?? "11 June, 2023",
                      style: TextStyles.customerTimeRequestContacts,
                    ),
                  ],
                ),
                Text(
                  money ?? "\$172.51",
                  style: TextStyles.transactionPaymentStyle,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class TransactionImage extends StatelessWidget {
  const TransactionImage({super.key, this.backgroundColor});

  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width - (width - 50),
      height: width - (width - 50),
      padding: EdgeInsets.all(width - (width - 8)),
      decoration: BoxDecoration(
          color: backgroundColor ?? Palette.transactionLightBlueColor,
          borderRadius: BorderStyles.floatingActionButtonRadius),
      child: Image.asset(
        "assets/icons/transactionDollar.png",
        height: width - (width - 30),
        width: width - (width - 30),
      ),
    );
  }
}
