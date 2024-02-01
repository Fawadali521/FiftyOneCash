import 'package:delayed_display/delayed_display.dart';
import 'package:fifty_one_cash/src/modules/dashboard/history/history-category.dart';
import 'package:fifty_one_cash/src/modules/dashboard/history/history-filter.dart';
import 'package:fifty_one_cash/src/modules/dashboard/history/history-search.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import 'history-tile.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  Duration upRowDelay = const Duration(milliseconds: 500);
  Duration listDelay = const Duration(milliseconds: 350);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
            gradient:
                LinearGradient(colors: [Palette.bgBlue1, Palette.bgBlue2])),
        child: MediaQuery.removePadding(
          context: context,
          removeBottom: true,
          child: ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: [
              const SafeArea(child: SizedBox()),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DelayedDisplay(
                      delay: upRowDelay,
                      slidingBeginOffset: const Offset(-1.0, 0.0),
                      slidingCurve: Curves.ease,
                      child: const Text(
                        "Transaction",
                        style: TextStyles.homeBigBoldWhiteText,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: DelayedDisplay(
                        delay: upRowDelay,
                        slidingBeginOffset: const Offset(1.0, 0.0),
                        slidingCurve: Curves.ease,
                        child: InkWell(
                          onTap: () {
                            //TODO
                            pushNewScreen(
                              context,
                              screen: const HistorySearch(),
                              withNavBar: false,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.fade,
                            );
                          },
                          child: Container(
                            height: 42,
                            width: 42,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                              color: Colors.transparent,
                            ),
                            child: const Center(
                              child: Center(
                                child: Padding(
                                    padding: EdgeInsets.only(),
                                    child: Icon(
                                      CupertinoIcons.search,
                                      color: Colors.white,
                                      size: 20,
                                    )),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // DelayedDisplay(
                    //   delay: upRowDelay,
                    //   slidingBeginOffset: const Offset(1.0, 0.0),
                    //   slidingCurve: Curves.ease,
                    //   child: Container(
                    //     height: 42,
                    //     width: 42,
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(15),
                    //       border: Border.all(
                    //         color: Colors.white.withOpacity(0.2),
                    //         width: 1,
                    //       ),
                    //       color: Colors.transparent,
                    //     ),
                    //     child: Center(
                    //       child: Padding(
                    //         padding: const EdgeInsets.all(12.0),
                    //         child: Image.asset(
                    //           "assets/icons/qr-code-scan.png",
                    //           height: 20,
                    //           fit: BoxFit.contain,
                    //           color: Colors.white,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(
              //       left: 20, right: 20, top: 15, bottom: 10),
              //   child: SizedBox(
              //     height: 40,
              //     // child: TextFieldSearch(
              //     //   onChanged: (x) {},
              //     //   hint: 'Search People',
              //     // ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 15, top: 20),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        final selected = await showMonthYearPicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2019),
                          lastDate: DateTime(2023),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              width: 1,
                              color: Colors.white.withOpacity(0.2),
                            ),
                            borderRadius: BorderRadius.circular(15)),
                        child: const Padding(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 5, bottom: 5),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Opacity(
                                opacity: 0.8,
                                child: Text(
                                  "Month",
                                  style: TextStyles.bodyWhite,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(),
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: InkWell(
                        onTap: () {
                          showBottomSheet(
                              context: context,
                              builder: (context) => const HistoryCategory());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                width: 1,
                                color: Colors.white.withOpacity(0.2),
                              ),
                              borderRadius: BorderRadius.circular(15)),
                          child: const Padding(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Opacity(
                                  opacity: 0.8,
                                  child: Text(
                                    "Categories",
                                    style: TextStyles.bodyWhite,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(),
                                  child: Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        showBottomSheet(
                            context: context,
                            enableDrag: true,
                            builder: (context) => const HistoryFilter());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              width: 1,
                              color: Colors.white.withOpacity(0.2),
                            ),
                            borderRadius: BorderRadius.circular(15)),
                        child: const Padding(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 5, bottom: 5),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Opacity(
                                opacity: 0.8,
                                child: Text(
                                  "Filter",
                                  style: TextStyles.bodyWhite,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(),
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: width,
                decoration: const BoxDecoration(
                  color: Palette.chatBg3,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: ListView.builder(
                  itemCount: 12,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 20, bottom: 50),
                  itemBuilder: (BuildContext context, int index) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: listDelay,
                      child: const SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: HistoryTile(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
