import 'package:fifty_one_cash/src/modules/dashboard/chat/utils/char-qr-scan.dart';
import 'package:fifty_one_cash/src/modules/dashboard/history/history-tile.dart';
import 'package:fifty_one_cash/src/widgets/text-field-history.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class HistorySearch extends StatefulWidget {
  const HistorySearch({super.key});

  @override
  State<HistorySearch> createState() => _HistorySearchState();
}

class _HistorySearchState extends State<HistorySearch> {
  Duration listDelay = const Duration(milliseconds: 350);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 10),
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.1),
              radius: 10,
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: TextFieldHistory(
            hint: "Search History Here",
            onChanged: (x) {},
            onTap: () {
              pushNewScreen(
                context,
                screen: const ChatQrScan(),
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.fade,
              );
            },
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Palette.primaryColor, Palette.secondaryColor],
              end: Alignment.centerRight,
              begin: Alignment.centerLeft,
            ),
          ),
        ),
      ),
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 20,
                shrinkWrap: true,
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 20, bottom: 50),
                itemBuilder: (BuildContext context, int index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: listDelay,
                    child: const SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(child: HistoryTile())),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
