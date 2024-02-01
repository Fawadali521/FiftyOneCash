import 'package:fifty_one_cash/src/modules/dashboard/notifications/notification-tile.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  Duration listDelay = const Duration(milliseconds: 350);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: const Text(
          "Notifications",
          style: TextStyles.homeSmallBoldWhiteText,
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
      body: ListView.builder(
        itemCount: 12,
        shrinkWrap: true,
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 50),
        itemBuilder: (BuildContext context, int index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: listDelay,
            child: const SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: NotificationTile(),
              ),
            ),
          );
        },
      ),
    );
  }
}
