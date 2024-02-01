import 'dart:io';

import 'package:delayed_display/delayed_display.dart';
import 'package:fifty_one_cash/src/models/get-contacts.dart';
import 'package:fifty_one_cash/src/modules/ProviderStateManagementViewModel/GlobalViewModel.dart';
import 'package:fifty_one_cash/src/modules/ProviderStateManagementViewModel/ContactProfileViewModel.dart';
import 'package:fifty_one_cash/src/modules/dashboard/ProfileOfContact/TransactionTile.dart';
import 'package:fifty_one_cash/src/modules/dashboard/Report/ReportAnIssue.dart';
import 'package:fifty_one_cash/src/modules/dashboard/chat/chatting/chat-ui.dart';
import 'package:fifty_one_cash/src/modules/ProviderStateManagementViewModel/BottomSheetViewModel.dart';
import 'package:fifty_one_cash/src/modules/dashboard/contancts/Contacts.dart';
import 'package:fifty_one_cash/src/modules/dashboard/contancts/utils/BottomSheet.dart';
import 'package:fifty_one_cash/src/services/ApiService.dart';
import 'package:fifty_one_cash/src/widgets/IconAndTextButton.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class ContactProfile extends StatefulWidget {
  const ContactProfile({
    super.key,
    this.contact,
    this.imageData,
  });

  final Uint8List? imageData;
  final ContactsDetails? contact;

  @override
  State<ContactProfile> createState() => _ContactProfileState();
}

class _ContactProfileState extends State<ContactProfile> {
  Duration upRowDelay = const Duration(milliseconds: 500);
  Duration listDelay = const Duration(milliseconds: 350);

  String? firstName;
  String? lastName;
  String? userName;
  String? numberOfContacts;

  Uint8List? userProfileImage;

  GetContacts? contacts;

  ScrollController controller = ScrollController();

  bool isContactLoading = false;
  bool isBlockingAccount = false;
  bool isUnblockingAccount = false;
  bool isAddingAccount = false;
  bool isAcceptingAccount = false;
  bool isRejectingRequest = false;
  bool isCancellingRequest = false;
  bool isRemovingAccount = false;

  blockAccount() async {
    if (widget.contact?.id != null) {
      isBlockingAccount = true;
      if (context.mounted) {
        setState(() {});
      }
      bool result = await ApiService().blockContact(widget.contact!.id);
      if (result) {
        widget.contact!.friendStatus = 'BLOCKED';
      }
      isBlockingAccount = false;
      if (context.mounted) {
        setState(() {});
      }
    }
  }

  unBlockAccount() async {
    if (widget.contact?.id != null) {
      isUnblockingAccount = true;
      if (context.mounted) {
        setState(() {});
      }
      bool result = await ApiService().unBlockContact(widget.contact!.id);
      if (result) {
        widget.contact!.friendStatus = 'FRIEND';
      }
      isUnblockingAccount = false;
      if (context.mounted) {
        setState(() {});
      }
    }
  }

  removeContact() async {
    if (widget.contact?.id != null) {
      isRemovingAccount = true;
      if (context.mounted) {
        setState(() {});
      }
      bool isContactRemoved =
          await ApiService().removeContact(widget.contact!.id);
      if (isContactRemoved) {
        widget.contact!.friendStatus = null;
      }
      isRemovingAccount = false;
      if (context.mounted) {
        setState(() {});
      }
    }
  }

  acceptRequest() async {
    if (widget.contact?.id != null) {
      isAcceptingAccount = true;
      if (context.mounted) {
        setState(() {});
      }
      bool isRequestAccepted =
          await ApiService().acceptContactRequest(widget.contact!.id);
      if (isRequestAccepted == true) {
        widget.contact!.friendStatus = 'FRIEND';
      }
      isAcceptingAccount = false;
      if (context.mounted) {
        setState(() {});
      }
    }
  }

  rejectRequest() async {
    if (widget.contact?.id != null) {
      isRejectingRequest = true;
      if (context.mounted) {
        setState(() {});
      }
      bool isRequestRejected =
          await ApiService().rejectContactRequest(widget.contact!.id);
      if (isRequestRejected) {
        widget.contact!.friendStatus = null;
      }
      isRejectingRequest = false;
      if (context.mounted) {
        setState(() {});
      }
    }
  }

  addContact() async {
    if (widget.contact?.id != null) {
      isAddingAccount = true;
      if (context.mounted) {
        setState(() {});
      }
      bool addContactRequestSend =
          await ApiService().addContact(widget.contact!.id);
      if (addContactRequestSend) {
        widget.contact!.friendStatus = 'REQUESTED';
      }

      isAddingAccount = false;
      if (context.mounted) {
        setState(() {});
      }
    }
  }

  unsendContact() async {
    if (widget.contact?.id != null) {
      isCancellingRequest = true;
      if (context.mounted) {
        setState(() {});
      }
      bool unSendRequest = await ApiService().unSendRequest(widget.contact!.id);
      if (unSendRequest == true) {
        widget.contact!.friendStatus = null;
      }
      isCancellingRequest = false;
      if (context.mounted) {
        setState(() {});
      }
    }
  }

  String? getFirstAndLastName() {
    if (widget.contact?.firstName != null && widget.contact?.lastName != null) {
      return "${widget.contact!.firstName![0].toUpperCase()}${widget.contact!.firstName!.substring(1)} "
          "${widget.contact!.lastName![0].toUpperCase()}${widget.contact!.lastName!.substring(1)}";
    } else if (widget.contact?.firstName != null &&
        widget.contact?.lastName == null) {
      return "${widget.contact!.firstName![0].toUpperCase()}${widget.contact!.firstName!.substring(1)}";
    } else if (widget.contact?.firstName == null &&
        widget.contact?.lastName != null) {
      return "${widget.contact!.lastName![0].toUpperCase()}${widget.contact!.lastName!.substring(1)}";
    }
    return null;
  }

  displaySheet(ContactsDetails? contactsDetails) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      useSafeArea: true,
      context: context,
      builder: (context) => ChangeNotifierProvider(
        create: (context) => BottomSheetViewModel(context: context),
        child: Consumer<BottomSheetViewModel>(
          builder: (context, model, child) => Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0)),
              color: Colors.white,
            ),
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 30,
                ),
                shrinkWrap: true,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 120),
                    width: 80,
                    height: 7,
                    decoration: BoxDecoration(
                      color: Palette.grey2.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: BottomSheetButtons(
                        width: MediaQuery.of(context).size.width,
                        isLoading: false,
                        buttonText: 'Request Money',
                        icon: Icons.money),
                  ),
                  if (widget.contact?.friendStatus == 'FRIEND' ||
                      widget.contact?.friendStatus == 'FRIENDS' ||
                      widget.contact?.friendStatus == 'REQUESTED' ||
                      widget.contact?.friendStatus == 'REQUEST_PRESENT') ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: model.isBlockingAccount == true
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Palette.secondaryColor,
                              ),
                            )
                          : BottomSheetButtons(
                              width: MediaQuery.of(context).size.width,
                              onTap: () async {
                                bool result =
                                    await model.blockAccount(widget.contact);
                                if (result) {
                                  if (mounted) {
                                    Navigator.pop(context);
                                  }
                                }
                              },
                              isLoading: model.isBlockingAccount,
                              buttonText: 'Block Contact',
                              icon: Icons.person_off,
                            ),
                    ),
                  ],
                  if (widget.contact?.friendStatus == 'FRIENDS' ||
                      widget.contact?.friendStatus == 'FRIEND' ||
                      widget.contact?.friendStatus == 'BLOCKED' ||
                      widget.contact?.friendStatus == 'BLOCKED_BY_PRINCIPAL')
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: model.isRemovingAccount == true
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Palette.secondaryColor,
                              ),
                            )
                          : BottomSheetButtons(
                              onTap: () async {
                                bool result =
                                    await model.removeContact(contactsDetails);
                                if (result) {
                                  if (mounted) {
                                    Navigator.pop(context);
                                  }
                                }
                              },
                              width: MediaQuery.of(context).size.width,
                              isLoading: model.isRemovingAccount,
                              buttonText: 'Remove Contact',
                              icon: Icons.delete_sweep_outlined,
                            ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                    ),
                    child: BottomSheetButtons(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => const AlertDialog(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 0),
                                  insetPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  content: ReportAnIssue(),
                                ));
                      },
                      width: MediaQuery.of(context).size.width,
                      buttonText: 'Report',
                      isLoading: false,
                      icon: Icons.info,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              controller: controller,
              physics: const ClampingScrollPhysics(),
              children: [
                const SafeArea(child: SizedBox()),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 20, bottom: 0),
                  child: DelayedDisplay(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.arrow_back_ios,
                              size: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Text(
                          "Profile",
                          style: TextStyles.ScreenWhiteTitle,
                        ),
                        GestureDetector(
                          onTap: () {
                            displaySheet(widget.contact);
                          },
                          child: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 20,
                      top: height - (height - 30)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: width - (width - 115),
                            height: width - (width - 115),
                            child: Stack(
                              children: [
                                Positioned(
                                  right: width - (width - 5),
                                  top: width - (width - 8),
                                  child: Container(
                                    height: width - (width - 95),
                                    width: width - (width - 98),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    height: width - (width - 100),
                                    width: width - (width - 100),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      image: widget.imageData == null
                                          ? const DecorationImage(
                                              image: AssetImage(
                                                  "assets/icons/personavator.png"),
                                              fit: BoxFit.cover)
                                          : DecorationImage(
                                              image: MemoryImage(
                                                widget.imageData!,
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  left: 2,
                                  bottom: 0,
                                  child: Image.asset(
                                    "assets/icons/ProfileHalfCircle.png",
                                    width: width - (width - 55),
                                    height: height - (height - 110),
                                  ),
                                )
                              ],
                            ),
                          ),
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
                            "@${widget.contact?.userName ?? "User Name"}",
                            style: TextStyles.profileScreenTitle,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 0, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.contact?.friendStatus == 'FRIENDS' ||
                          widget.contact?.friendStatus == 'FRIEND') ...[
                        IconAndTextButton(
                          icon: Icons.email_outlined,
                          isLoading: false,
                          title: 'Send Message',
                          backgroundColor: Colors.transparent,
                          iconColor: Palette.buttonIconColor,
                          width: (width - 55) / 2,
                          onTap: () {
                            if (widget.contact != null) {
                              if (mounted) {
                                pushNewScreen(
                                  context,
                                  screen: ChatUi(
                                    receiverDetails: widget.contact!,
                                  ),
                                  withNavBar: false,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.fade,
                                );
                              }
                            }
                          },
                          textStyle: TextStyles.iconTextStyle,
                          border: Border.all(
                              width: 0.4,
                              color: Palette.iconAndTextButtonBorderColor),
                        ),
                        IconAndTextButton(
                          icon: Icons.arrow_outward_rounded,
                          isLoading: false,
                          title: 'Send Money',
                          backgroundColor: Colors.transparent,
                          iconColor: Palette.buttonIconColor,
                          width: (width - 55) / 2,
                          textStyle: TextStyles.iconTextStyle,
                          border: Border.all(
                              width: 1,
                              color: Palette.iconAndTextButtonBorderColor),
                        ),
                      ] else if (widget.contact?.friendStatus == 'BLOCKED' ||
                          widget.contact?.friendStatus ==
                              'BLOCKED_BY_PRINCIPAL') ...[
                        IconAndTextButton(
                          icon: Icons.arrow_outward_rounded,
                          isLoading: isUnblockingAccount,
                          onTap: () {
                            unBlockAccount();
                          },
                          title: 'UnBlock Contact',
                          backgroundColor: Colors.transparent,
                          iconColor: Palette.buttonIconColor,
                          width: (width - 40),
                          textStyle: TextStyles.iconTextStyle,
                          border: Border.all(
                              width: 1,
                              color: Palette.iconAndTextButtonBorderColor),
                        ),
                      ] else if (widget.contact?.friendStatus ==
                          'REQUEST_PRESENT') ...[
                        IconAndTextButton(
                          icon: Icons.arrow_outward_rounded,
                          isLoading: isAcceptingAccount,
                          onTap: () {
                            acceptRequest();
                          },
                          title: 'Accept',
                          backgroundColor: Colors.transparent,
                          iconColor: Palette.buttonIconColor,
                          width: (width - 55) / 2,
                          textStyle: TextStyles.iconTextStyle,
                          border: Border.all(
                              width: 1,
                              color: Palette.iconAndTextButtonBorderColor),
                        ),
                        IconAndTextButton(
                          icon: Icons.arrow_outward_rounded,
                          isLoading: isRejectingRequest,
                          onTap: () {
                            rejectRequest();
                          },
                          title: 'Decline',
                          backgroundColor: Colors.transparent,
                          iconColor: Palette.buttonIconColor,
                          width: (width - 55) / 2,
                          textStyle: TextStyles.iconTextStyle,
                          border: Border.all(
                              width: 1,
                              color: Palette.iconAndTextButtonBorderColor),
                        ),
                      ] else if (widget.contact?.friendStatus ==
                          'REQUESTED') ...[
                        IconAndTextButton(
                          icon: Icons.arrow_outward_rounded,
                          isLoading: isCancellingRequest,
                          onTap: () {
                            unsendContact();
                          },
                          title: 'Cancel Request',
                          backgroundColor: Colors.transparent,
                          iconColor: Palette.buttonIconColor,
                          width: (width - 40),
                          textStyle: TextStyles.iconTextStyle,
                          border: Border.all(
                              width: 1,
                              color: Palette.iconAndTextButtonBorderColor),
                        ),
                      ] else ...[
                        IconAndTextButton(
                          icon: Icons.arrow_outward_rounded,
                          isLoading: isAddingAccount,
                          title: 'Send Request',
                          onTap: () {
                            addContact();
                          },
                          backgroundColor: Colors.transparent,
                          iconColor: Palette.buttonIconColor,
                          width: (width - 40),
                          textStyle: TextStyles.iconTextStyle,
                          border: Border.all(
                              width: 1,
                              color: Palette.iconAndTextButtonBorderColor),
                        ),
                      ],
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
                    padding: const EdgeInsets.only(
                      top: 20,
                      bottom: 20,
                      left: 20,
                      right: 20,
                    ),
                    child: AnimationLimiter(
                      child: ListView(
                        shrinkWrap: true,
                        controller: controller,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Transactions",
                                style: TextStyles.buttonBlackOne,
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: width - (width - 10)),
                                    child: PopupMenuButton<String>(
                                      itemBuilder: (BuildContext context) =>
                                          const <PopupMenuEntry<String>>[
                                        PopupMenuItem<String>(
                                          value: 'option1',
                                          child: Text('Option 1'),
                                        ),
                                        PopupMenuItem<String>(
                                          value: 'option2',
                                          child: Text('Option 2'),
                                        ),
                                        PopupMenuItem<String>(
                                          value: 'option3',
                                          child: Text('Option 3'),
                                        ),
                                      ],
                                      child: Container(
                                        width: width / 4,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderStyles.norm3,
                                            border: Border.all(
                                                color: Palette
                                                    .dropDownButtonBorderColor)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              "Sort by",
                                              style: TextStyles
                                                  .dropDownButtonTextStyle,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: width - (width - 10)),
                                              child: const Icon(
                                                Icons.keyboard_arrow_down,
                                                color:
                                                    Palette.dropDownIconColor,
                                                size: 15,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onSelected: (String result) {
                                        print('Selected: $result');
                                      },
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    itemBuilder: (BuildContext context) =>
                                        const <PopupMenuEntry<String>>[
                                      PopupMenuItem<String>(
                                        value: 'option1',
                                        child: Text('Option 1'),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'option2',
                                        child: Text('Option 2'),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'option3',
                                        child: Text('Option 3'),
                                      ),
                                    ],
                                    child: Container(
                                      width: width / 4,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderStyles.norm3,
                                          border: Border.all(
                                              color: Palette
                                                  .dropDownButtonBorderColor)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Filter",
                                            style: TextStyles
                                                .dropDownButtonTextStyle,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: width - (width - 10)),
                                            child: const Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Palette.dropDownIconColor,
                                              size: 15,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    onSelected: (String result) {
                                      print('Selected: $result');
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                          const TransactionTile(),
                          const TransactionTile(
                            backgroundColorOfImage:
                                Palette.transactionLightPurpleColor,
                          ),
                          const TransactionTile(
                            backgroundColorOfImage:
                                Palette.transactionYellowColor,
                          ),
                          const TransactionTile(
                            backgroundColorOfImage:
                                Palette.transactionLighterBlueColor,
                          ),
                          const TransactionTile(
                            backgroundColorOfImage:
                                Palette.transactionLighterBlueColor,
                          ),
                          const TransactionTile(
                            backgroundColorOfImage:
                                Palette.transactionLighterBlueColor,
                          ),
                          const TransactionTile(
                            backgroundColorOfImage:
                                Palette.transactionLighterBlueColor,
                          ),
                        ],
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
