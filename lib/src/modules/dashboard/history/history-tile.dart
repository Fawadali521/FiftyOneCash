import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';

class HistoryTile extends StatefulWidget {
  const HistoryTile({super.key});

  @override
  State<HistoryTile> createState() => _HistoryTileState();
}

class _HistoryTileState extends State<HistoryTile> {
  List category = [
    'Merchant Payments',
    'Refunds',
    'Money Received',
    'Money Sent',
    'Watter Bill',
    'Mobile Recharge',
    'Electricity BIll'
  ];
  List filterPaymentMethod = ['Wallet', 'Credit/Debit Card'];
  List filterStatus = ['Failed', 'Pending', 'Successful'];
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          // height: 110,
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Palette.chatBg,
                      ),
                      child: const Icon(
                        Icons.send,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: SizedBox(
                        width: width - 60 - 54,
                        child: const Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Opacity(
                                          opacity: 0.8,
                                          child: Text(
                                            "Paid to",
                                            style:
                                                TextStyles.historyTileHeading,
                                          ),
                                        ),
                                        Opacity(
                                          opacity: 0.9,
                                          child: Text(
                                            "Amazon LTD.",
                                            style: TextStyles.historyPerson,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  "\$174.51",
                                  style: TextStyles.historyMoneyGreen,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Opacity(
                        opacity: 0.4,
                        child: Text(
                          "11 June, 2023",
                          style: TextStyles.bodyBlack,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            "Debited From",
                            style: TextStyles.chatMsg,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Image.asset(
                              "assets/icons/wallet.png",
                              fit: BoxFit.contain,
                              width: 20,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          child: Container(
            width: width - 40,
            height: 1,
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.05)),
          ),
        )
      ],
    );
  }
}
