import 'package:fifty_one_cash/datas.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';

class HistoryCategory extends StatefulWidget {
  const HistoryCategory({super.key});

  @override
  State<HistoryCategory> createState() => _HistoryCategoryState();
}

class _HistoryCategoryState extends State<HistoryCategory> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      // height: height * 0.8,
      // constraints: BoxConstraints(
      //   maxHeight: height*0.8
      // ),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          color: Palette.primaryColor),
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        // padding: const EdgeInsets.only(bottom: 50),
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 8,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white.withOpacity(0.2),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Transaction",
                        style: TextStyles.buttonWhiteOne,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Opacity(
                          opacity: 0.5,
                          child: Text(
                            "CLEAR",
                            style: TextStyles.bodyWhite,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: List.generate(
                      Datas().category.length,
                      (index) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Datas().category[index],
                                style: TextStyles.paraBigBoldWhite,
                              ),
                              Checkbox(
                                value: false,
                                onChanged: (x) {},
                                activeColor: Colors.white,
                              )
                            ],
                          )),
                ),
              ],
            ),
          ),
          Container(
            width: width,
            height: 60,
            decoration: const BoxDecoration(
              color: Palette.secondaryColor,
            ),
            child: const Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  "APPLY",
                  style: TextStyles.buttonWhiteOne,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
