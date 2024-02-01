import 'package:fifty_one_cash/datas.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';

class AddingFundsInfo extends StatefulWidget {
  const AddingFundsInfo({super.key});

  @override
  State<AddingFundsInfo> createState() => _AddingFundsInfoState();
}

class _AddingFundsInfoState extends State<AddingFundsInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient:
                  LinearGradient(colors: [Palette.bgBlue1, Palette.bgBlue2])),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Information",
          style: TextStyles.homeBigBoldWhiteText,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        shrinkWrap: true,
        children: [
          Text(
            Datas().termsAndConditions['title'],
            style: TextStyles.midHeadingBlack,
          ),

          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                  Datas().termsAndConditions['sections'].length,
                  (index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Datas().termsAndConditions['sections'][index]
                                ['title'],
                            style: TextStyles.paraBigBoldBlack,
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                Datas()
                                    .termsAndConditions['sections'][index]
                                        ['subTitle']
                                    .length,
                                (index2) => Text(
                                  Datas().termsAndConditions['sections'][index]
                                      ['subTitle'][index2],
                                  style: TextStyles.bodyBlack,
                                ),
                              )),
                        ],
                      )))
          // Text(
          //   "Cash Out (Withdrawal of Funds):",
          //   style: TextStyles.paraBigBoldBlack,
          // ),
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Text(
          //       "* While adding funds to your wallet is free, withdrawing funds (Cash Out) from your wallet will incur a service charge known as ${Datas.withdrawTax} which is a percentage of the withdrawal amount.",
          //       style: TextStyles.bodyBlack,
          //     ),
          //     Text(
          //       "* The ${Datas.withdrawTax} withdrawal tax may vary from time to time, and any changes will be communicated to users through our official communication channels.",
          //       style: TextStyles.bodyBlack,
          //     ),
          //     Text(
          //       "* The withdrawal tax will be deducted from the withdrawal (Cash Out) amount before the funds are transferred to your designated bank account.",
          //       style: TextStyles.bodyBlack,
          //     ),
          //     Text(
          //       "* The availability of the Cash Out service is subject to the terms and conditions of your designated bank and payment method providers.",
          //       style: TextStyles.bodyBlack,
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
