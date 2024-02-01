//created by shivay
import 'package:badges/badges.dart' as badges;
import 'package:fifty_one_cash/src/modules/ProviderStateManagementViewModel/GlobalViewModel.dart';
import 'package:fifty_one_cash/src/modules/dashboard/qr-scan/qr-scan.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import 'chat/chat.dart';
import 'history/history.dart';
import 'home/home.dart';
import 'profile/profile.dart';

class DashBoard extends StatefulWidget {
  final int page;
  const DashBoard({super.key, this.page = 0});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  PersistentTabController tabController =
      PersistentTabController(initialIndex: 0);
  @override
  void initState() {
    tabController.index = widget.page;
    super.initState();
  }

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
        child: Consumer<GlobalViewModel>(
          builder: (context, model, child) => PersistentTabView(
            context,
            controller: tabController,
            resizeToAvoidBottomInset: true,
            confineInSafeArea: true,
            backgroundColor: Colors.white, // Default is Colors.white.
            handleAndroidBackButtonPress: true, // Default is true.
            stateManagement: true, // Default is true.
            hideNavigationBarWhenKeyboardShows:
                true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
            popAllScreensOnTapOfSelectedTab: true,
            screens: const [
              //edited by shivay
              Home(),
              Chats(),
              QrScan(),
              History(),
              Profile(),
              //end
            ],
            items: [
              PersistentBottomNavBarItem(
                icon: const ImageIcon(
                  AssetImage("assets/icons/home.png"),
                  size: 25,
                ),
                activeColorPrimary: Palette.bgBlue2,
                inactiveColorPrimary: Palette.grey2,
              ),
              PersistentBottomNavBarItem(
                icon: const badges.Badge(
                  stackFit: StackFit.passthrough,
                  showBadge: true,
                  badgeStyle: badges.BadgeStyle(
                    shape: badges.BadgeShape.circle,
                    badgeColor: Colors.red,
                    padding: EdgeInsets.all(5),
                    elevation: 0,
                  ),
                  badgeContent: Text(
                    "6",
                    style: TextStyles.notificationWhiteBold,
                  ),
                  child: ImageIcon(
                    AssetImage("assets/icons/chat.png"),
                    size: 25,
                  ),
                ),
                activeColorPrimary: Palette.bgBlue2,
                inactiveColorPrimary: Palette.grey2,
              ),
              PersistentBottomNavBarItem(
                icon: const ImageIcon(
                  AssetImage("assets/icons/qr-scan.png"),
                  color: Colors.white,
                  size: 30,
                ),
                activeColorPrimary: Palette.purple,
                // inactiveColorPrimary: CupertinoColors.systemGrey,
              ),
              PersistentBottomNavBarItem(
                icon: const ImageIcon(
                  AssetImage("assets/icons/time.png"),
                  size: 28,
                ),
                activeColorPrimary: Palette.bgBlue2,
                inactiveColorPrimary: Palette.grey2,
              ),
              PersistentBottomNavBarItem(
                icon: badges.Badge(
                  stackFit: StackFit.passthrough,
                  showBadge: true,
                  badgeStyle: badges.BadgeStyle(
                    shape: badges.BadgeShape.circle,
                    badgeColor: model.kycStatus == 'PENDING'
                        ? Colors.orange[300]!
                        : model.kycStatus == 'VERIFIED'
                            ? Colors.transparent
                            : Colors.red,
                    padding: const EdgeInsets.all(5),
                    elevation: 0,
                  ),
                  badgeContent: const Text(
                    "1",
                    style: TextStyles.notificationWhiteBold,
                  ),
                  child: const ImageIcon(
                    AssetImage("assets/icons/profile.png"),
                    size: 25,
                  ),
                ),
                activeColorPrimary: Palette.bgBlue2,
                inactiveColorPrimary: Palette.grey2,
              ),
            ],
            decoration: NavBarDecoration(
                borderRadius: BorderRadius.circular(10.0),
                colorBehindNavBar: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.01),
                    blurRadius: 10,
                    spreadRadius: 8,
                  ),
                ]),
            itemAnimationProperties: const ItemAnimationProperties(
              // Navigation Bar's items animation properties.
              duration: Duration(milliseconds: 200),
              curve: Curves.ease,
            ),
            screenTransitionAnimation: const ScreenTransitionAnimation(
              // Screen transition animation on change of selected tab.
              animateTabTransition: true,
              curve: Curves.ease,
              duration: Duration(milliseconds: 200),
            ),
            navBarStyle: NavBarStyle.style15,
          ),
        ),
      ),
    );
  }
}
