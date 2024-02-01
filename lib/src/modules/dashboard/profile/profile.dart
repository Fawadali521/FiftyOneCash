import 'dart:io';
import 'dart:typed_data';

import 'package:delayed_display/delayed_display.dart';
import 'package:fifty_one_cash/landing-page.dart';
import 'package:fifty_one_cash/src/models/get-contacts.dart';
import 'package:fifty_one_cash/src/modules/ProviderStateManagementViewModel/GlobalViewModel.dart';
import 'package:fifty_one_cash/src/modules/dashboard/contancts/Contacts.dart';
import 'package:fifty_one_cash/src/modules/dashboard/kyc/DoKyc.dart';
import 'package:fifty_one_cash/src/modules/dashboard/kyc/PendingKyc.dart';
import 'package:fifty_one_cash/src/modules/dashboard/kyc/RejectedKyc.dart';
import 'package:fifty_one_cash/src/modules/dashboard/master_pin/SendMasterPinOtp.dart';
import 'package:fifty_one_cash/src/modules/dashboard/master_pin/SetUpMasterPin.dart';
import 'package:fifty_one_cash/src/modules/dashboard/master_pin/SendMasterPinOtp.dart';
import 'package:fifty_one_cash/src/modules/dashboard/master_pin/UpdateMasterPin.dart';
import 'package:fifty_one_cash/src/modules/dashboard/profile/UpdateProfile/UpdateUserProfile.dart';
import 'package:fifty_one_cash/src/modules/dashboard/qr-scan/qr-show.dart';
import 'package:fifty_one_cash/src/services/ApiService.dart';
import 'package:fifty_one_cash/src/services/SharedData.dart';
import 'package:fifty_one_cash/src/widgets/UserProfileImageContainer.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Duration upRowDelay = const Duration(milliseconds: 500);
  Duration listDelay = const Duration(milliseconds: 350);

  //Edited by MHK-MotoVlogs
  String? firstName;
  String? lastName;
  String? userName;
  String? numberOfContacts;

  Uint8List? userProfileImage;

  GetContacts? contacts;

  ScrollController controller = ScrollController();

  bool isContactLoading = false;

  getStoredUserProfile() async {
    firstName = await SharedData.getFirstName();
    lastName = await SharedData.getLastName();
    userName = await SharedData.getUserName();

    String? profilePictureUrl = await SharedData.getProfilePicture();

    if (profilePictureUrl != null) {
      userProfileImage = await ApiService().getProfileImage(profilePictureUrl);
    }
    setState(() {});
  }

  String? getFirstAndLastName() {
    if (firstName != null && lastName != null) {
      return "${firstName![0].toUpperCase()}${firstName!.substring(1)} "
          "${lastName![0].toUpperCase()}${lastName!.substring(1)}";
    } else if (firstName != null && lastName == null) {
      return "${firstName![0].toUpperCase()}${firstName!.substring(1)}";
    } else if (firstName == null && lastName != null) {
      return "${lastName![0].toUpperCase()}${lastName!.substring(1)}";
    }
    return null;
  }

  getContacts() async {
    isContactLoading = true;
    setState(() {});
    contacts = await ApiService().getContacts();
    if (contacts != null) {
      if (contacts!.blockedContacts.isNotEmpty &&
          contacts!.generalContacts.isNotEmpty) {
        numberOfContacts = (contacts!.blockedContacts.length +
                contacts!.generalContacts.length)
            .toString();
      } else if (contacts!.blockedContacts.isNotEmpty &&
          contacts!.generalContacts.isEmpty) {
        numberOfContacts = contacts!.blockedContacts.length.toString();
      } else if (contacts!.generalContacts.isNotEmpty &&
          contacts!.blockedContacts.isEmpty) {
        numberOfContacts = contacts!.generalContacts.length.toString();
      } else {
        numberOfContacts = '0';
      }
      isContactLoading = false;

      setState(() {});
    }
  }

  @override
  void initState() {
    getStoredUserProfile();
    getContacts();
    super.initState();
  }

  //end
  @override
  Widget build(BuildContext context) {
    List<Widget> navigationTiles = [
      profileItem(
        icon: "assets/icons/group.png",
        title: "Contacts",
        destination: const Contacts(),
      ),
      profileItem(
        icon: "assets/icons/id.png",
        title: "KYC",
        destination: Provider.of<GlobalViewModel>(context, listen: false)
                    .kycStatus ==
                'PENDING'
            ? const PendingKyc()
            : Provider.of<GlobalViewModel>(context, listen: false).kycStatus ==
                    'FAILED'
                ? const RejectedKyc()
                : const DoKyc(),
        havingBadge:
            Provider.of<GlobalViewModel>(context, listen: false).kycStatus !=
                    'VERIFIED'
                ? true
                : false,
      ),
      profileItem(
        icon: "assets/icons/password.png",
        title: "Update Master Pin",
        destination: const SendMasterPinOtp(),
      ),
      profileItem(icon: "assets/icons/operator.png", title: "Contact Us"),
      profileItem(
          icon: "assets/icons/terms-and-conditions.png",
          title: "Terms & Conditions"),
      profileItem(
          icon: "assets/icons/privacy-policy.png", title: "Privacy Policy"),
      GestureDetector(
        onTap: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.clear();
          if (mounted) {
            pushNewScreen(
              context,
              screen: const LandingPage(),
              withNavBar: false,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          }
        },
        child:
            profileItem(icon: "assets/icons/power-off.png", title: "Sign Out"),
      )
    ];
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: Platform.isIOS
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light,
        child: Container(
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
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 20, bottom: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DelayedDisplay(
                        delay: upRowDelay,
                        slidingBeginOffset: const Offset(-1.0, 0.0),
                        slidingCurve: Curves.ease,
                        child: const Text(
                          "Profile",
                          style: TextStyles.homeBigBoldWhiteText,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          DelayedDisplay(
                            delay: upRowDelay,
                            slidingBeginOffset: const Offset(1.0, 0.0),
                            slidingCurve: Curves.ease,
                            child: InkWell(
                              onTap: () {
                                pushNewScreen(
                                  context,
                                  screen: const QrShow(),
                                  withNavBar:
                                      false, // OPTIONAL VALUE. True by default.
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.slideUp,
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
                                child: Center(
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Image.asset(
                                          "assets/icons/qr.png",
                                          height: 20,
                                          fit: BoxFit.contain,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: DelayedDisplay(
                              delay: upRowDelay,
                              slidingBeginOffset: const Offset(1.0, 0.0),
                              slidingCurve: Curves.ease,
                              child: InkWell(
                                // Edited by MHK-MotoVlogs
                                onTap: () async {
                                  await pushNewScreen(
                                    context,
                                    screen: const UpdateUserProfile(),
                                    withNavBar:
                                        false, // OPTIONAL VALUE. True by default.
                                    pageTransitionAnimation:
                                        PageTransitionAnimation.cupertino,
                                  );
                                  getStoredUserProfile();
                                },
                                //end
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
                                  child: Center(
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Image.asset(
                                            "assets/icons/user-avatar-edit.png",
                                            height: 22,
                                            fit: BoxFit.contain,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          UserProfileImageContainer(
                              userProfileImage: userProfileImage),
                          Padding(
                            padding: const EdgeInsets.only(top: 7),
                            child: Opacity(
                              opacity: 0.9,
                              child: Text(
                                getFirstAndLastName() ?? "Name",
                                style: TextStyles.buttonWhiteOne,
                              ),
                            ),
                          ),
                          Text(
                            userName ?? "User Name",
                            style: TextStyles.bodyWhite,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 0, bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "\$0",
                            style: TextStyles.paraBigWhite,
                          ),
                          Opacity(
                            opacity: 0.7,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Money In",
                                  style: TextStyles.bodyWhite,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Icon(
                                    CupertinoIcons.arrow_down_left,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "\$0",
                            style: TextStyles.paraBigWhite,
                          ),
                          Opacity(
                            opacity: 0.7,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Money Out",
                                  style: TextStyles.bodyWhite,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Icon(
                                    CupertinoIcons.arrow_turn_right_up,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            numberOfContacts ?? '0',
                            style: TextStyles.paraBigWhite,
                          ),
                          const Opacity(
                            opacity: 0.7,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Contacts",
                                  style: TextStyles.bodyWhite,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Icon(
                                    Icons.people_alt_outlined,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Palette.grey3,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 50),
                    child: AnimationLimiter(
                      child: ListView.builder(
                        controller: controller,
                        shrinkWrap: true,
                        itemCount: navigationTiles.length,
                        itemBuilder: (context, index) =>
                            AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(seconds: 1),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child:
                                FadeInAnimation(child: navigationTiles[index]),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  profileItem(
      {required String icon,
      required String title,
      Widget? destination,
      bool? havingBadge}) {
    double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Palette.secondaryColor.withOpacity(0.05),
                ),
                child: Center(
                    child: Image.asset(
                  icon,
                  height: 25,
                  fit: BoxFit.contain,
                  color: Palette.secondaryColor,
                )),
              ),
              if (havingBadge != null && havingBadge == true) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: SizedBox(
                    width: 35,
                    child: Stack(
                      children: [
                        Text(
                          title,
                          style: TextStyles.bodyBlack,
                        ),
                        Positioned(
                          right: 0,
                          child: Badge(
                            backgroundColor: Provider.of<GlobalViewModel>(
                                            context,
                                            listen: false)
                                        .kycStatus !=
                                    'PENDING'
                                ? Colors.red
                                : Colors.orange[300]!,
                            smallSize: 8,
                            largeSize: 11,
                            alignment: Alignment.topRight,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ] else ...[
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    title,
                    style: TextStyles.bodyBlack,
                  ),
                ),
              ],
              const Spacer(),
              IconButton(
                  onPressed: () {
                    if (destination != null) {
                      pushNewScreen(
                        context,
                        screen: destination,
                        withNavBar: false,
                        pageTransitionAnimation: PageTransitionAnimation.fade,
                      );
                    }
                  },
                  icon: const Icon(
                    Icons.arrow_forward,
                    size: 20,
                    color: Colors.black,
                  ))
            ],
          ),
        ),
        Positioned(
          bottom: 10,
          child: Padding(
            padding: const EdgeInsets.only(left: 70),
            child: Container(
              width: width,
              height: 1,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
              ),
            ),
          ),
        )
      ],
    );
  }
}
