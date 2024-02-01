import 'package:delayed_display/delayed_display.dart';
import 'package:extended_image/extended_image.dart';
import 'package:fifty_one_cash/src/models/PersonalChatList.dart';
import 'package:fifty_one_cash/src/models/get-contacts.dart';
import 'package:fifty_one_cash/src/controller/showAllChatUser.dart';
import 'package:fifty_one_cash/src/modules/dashboard/chat/utils/ChatTile.dart';
import 'package:fifty_one_cash/src/modules/dashboard/chat/utils/CreatGroupDialog.dart';
import 'package:fifty_one_cash/src/modules/dashboard/contancts/utils/SearchContacts.dart';
import 'package:fifty_one_cash/src/services/ApiService.dart';
import 'package:fifty_one_cash/src/services/SharedData.dart';
import 'package:fifty_one_cash/src/widgets/ShimmerTile.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import 'chatting/chat-ui.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  Duration upRowDelay = const Duration(milliseconds: 500);
  Duration listDelay = const Duration(milliseconds: 350);

  PersonalChatList? listOfChats;

  // final controller = Get.put(ShowAllChatUserController());

  int page = 0;

  bool isLoading = false;
  String? userId;
  getListOfPersonalChat() async {
    isLoading = true;
    userId = await SharedData.getUserId();
    setState(() {});
    listOfChats = await ApiService().getListOfPersonalChat(page);
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    getListOfPersonalChat();
    // controller.FetchData();
    super.initState();
  }

  Uint8List? imageData;
  @override
  Widget build(BuildContext context) {
    // controller.FetchData();
    print('hhhhhhhhhhhhhhh : ${userId}');

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      // backgroundColor: Colors.red,
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
                const SafeArea(
                  child: SizedBox(),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 15, bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DelayedDisplay(
                        delay: upRowDelay,
                        slidingBeginOffset: const Offset(-1.0, 0.0),
                        slidingCurve: Curves.ease,
                        child: const Text(
                          "Chat",
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
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => const AlertDialog(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 0),
                                    insetPadding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    content: CreateGroupDialog(),
                                  ),
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
                                          "New Group ",
                                          style: TextStyles.bodyWhite,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(),
                                        child: Icon(
                                          Icons.add,
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
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: DelayedDisplay(
                              delay: upRowDelay,
                              slidingBeginOffset: const Offset(1.0, 0.0),
                              slidingCurve: Curves.ease,
                              child: InkWell(
                                onTap: () {
                                  pushNewScreen(
                                    context,
                                    screen: const SearchContacts(),
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
                                  child: Center(
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(),
                                        child: Image.asset(
                                          "assets/icons/search2.png",
                                          width: 20,
                                          fit: BoxFit.contain,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(
                //       left: 20, right: 20, top: 15, bottom: 20),
                //   child: SizedBox(
                //     height: 40,
                //     child: TextFieldSearch(
                //       onChanged: (x) {},
                //       hint: 'Search People',
                //     ),
                //   ),
                // ),
                // if (controller.showAllChatUser?.chatheads != null &&
                //     controller.showAllChatUser?.chatheads.length != 0) ...[
                Container(
                  width: width,
                  height: height - 205,
                  decoration: const BoxDecoration(
                    color: Palette.chatBg3,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: isLoading
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: 7,
                          itemBuilder: (context, index) =>
                              ShimmerTile(width: width),
                        )
                      : listOfChats?.chatDetails.length == 0
                          ? Center(
                              child: Image.asset("assets/icons/EmptyChat.png"))
                          : ListView.builder(
                              itemCount: listOfChats?.chatDetails.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20, bottom: 50),
                              itemBuilder: (BuildContext context, int index) {
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: listDelay,
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: InkWell(
                                        onTap: () {
                                          pushNewScreen(
                                            context,
                                            screen: ChatUi(
                                              isThisGroupChat: listOfChats!
                                                          .chatDetails[index]
                                                          .chatType ==
                                                      'GROUP'
                                                  ? true
                                                  : false,
                                              groupId: listOfChats!
                                                  .chatDetails[index].groupId,
                                              receiverDetails: ContactsDetails
                                                  .fromPersonalChat(listOfChats!
                                                      .chatDetails[index]),
                                            ),
                                            withNavBar: false,
                                            pageTransitionAnimation:
                                                PageTransitionAnimation.fade,
                                          );
                                        },
                                        child: ChatTile(
                                                chatDetails: listOfChats
                                                    ?.chatDetails[index],
                                                // msgCount: (index + 1).toString(),
                                              ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),

                  /*
                          child:  controller.showAllChatUser?.chatheads.length == 0
              ? Center(child: Image.asset("assets/icons/EmptyChat.png"))
              : Obx(
                            () => controller.isLoading.value
                                ? ListView.builder(
                                  
                          shrinkWrap: true,
                          itemCount: 7,
                          itemBuilder: (context, index) =>
                              ShimmerTile(width: width),
                        )
                                : Container(
                                    child: ListView.builder(
                                      itemCount:  controller.showAllChatUser
                                              ?.chatheads.length==0?0 :controller.showAllChatUser
                                              ?.chatheads.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 20,
                                          bottom: 50),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return AnimationConfiguration
                                            .staggeredList(
                                          position: index,
                                          duration: listDelay,
                                          child: SlideAnimation(
                                            verticalOffset: 50.0,
                                            child: FadeInAnimation(
                                              child: InkWell(
                                                  onTap: () {
                                                    pushNewScreen(
                                                      context,
                                                      screen: ChatUi(
                                                        isThisGroupChat: controller
                                                                    .showAllChatUser
                                                                    ?.chatheads[
                                                                        index]
                                                                    .chatType ==
                                                                'GROUP'
                                                            ? true
                                                            : false,
                                                        groupId: controller
                                                            .showAllChatUser
                                                            ?.chatheads[index]
                                                            .groupid,
                                                        receiverDetails:
                                                            ContactsDetails
                                                                .fromPersonalChat(
                                                                    listOfChats!
                                                                            .chatDetails[
                                                                        index]),
                                                        controller.showAllChatUser.chatheads[index]
                                                      ),
                                                      withNavBar: false,
                                                      pageTransitionAnimation:
                                                          PageTransitionAnimation
                                                              .fade,
                                                    );
                                                  },
                                                  // child: ChatTile(
                                                  //   chatDetails: listOfChats!.chatDetails[index],
                                                  //   // msgCount: (index + 1).toString(),
                                                  // ),
                                                  child: Container(
                                                    height: 110,
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.transparent,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 20),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          // controller
                                                          //             .showAllChatUser
                                                          //             ?.chatheads[
                                                          //                 index]
                                                          //             .profilepic !=
                                                          //         null
                                                          //     ? ExtendedImage
                                                          //         .network(
                                                          //         height: 54.0,
                                                          //         width: 54.0,
                                                          //            controller
                                                          //             .showAllChatUser
                                                          //             ?.chatheads[
                                                          //                 index]
                                                          //             .profilepic,
                                                          //         shape: BoxShape
                                                          //             .circle,
                                                          //       )
                                                          //     : 
                                                              ExtendedImage
                                                                  .asset(
                                                                  height: 54,
                                                                  width: 54,
                                                                  'assets/icons/personavator.png',
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 20),
                                                            child: SizedBox(
                                                              width: width -
                                                                  60 -
                                                                  54,
                                                              child: Stack(
                                                                clipBehavior:
                                                                    Clip.none,
                                                                children: [
                                                                  Column(
                                                                    children: [
                                                                       Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          SizedBox(
                                                                            width: width -
                                                                                60 -
                                                                                54 -
                                                                                100,
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Flexible(
                                                                                  child: Text(
                                                                                    controller.showAllChatUser?.chatheads[index].chatheadname ?? 'User',
                                                                                    style: TextStyles.chatName,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Opacity(
                                                                            opacity:
                                                                                0.5,
                                                                            child:
                                                                                Text(
                                                                              controller.showAllChatUser?.chatheads[index].lastmessagetime != null ? DateFormat('h:mm a').format(DateTime.parse(controller.showAllChatUser!.chatheads[index].lastmessagetime.toString())) : "11:54 AM",
                                                                              style: TextStyles.chatTime,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            top:
                                                                                5),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            SizedBox(
                                                                              width: width - 60 - 54 - 30,
                                                                              height: 50,
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Flexible(
                                                                                      child: RichText(
                                                                                    overflow: TextOverflow.visible,
                                                                                    text: TextSpan(
                                                                                      children: [
                                                                                        WidgetSpan(
                                                                                            child: Padding(
                                                                                          padding: const EdgeInsets.only(top: 2, right: 2),
                                                                                          child: Image.asset(
                                                                                            "assets/icons/double-check.png",
                                                                                            width: 18,
                                                                                            fit: BoxFit.contain,
                                                                                          ),
                                                                                        )),
                                                                                        TextSpan(
                                                                                          text: controller.showAllChatUser?.chatheads[index].lastmessage ?? 'In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document',
                                                                                          style: TextStyles.chatMsg,
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  )),
                                                                                 
                                                                         controller.showAllChatUser?.chatheads[index].oponentuserid ==   controller.showAllChatUser?.chatheads[index].oponentuserid
                                                                         ?  
                                                                           Icon(Icons.check,size: 17,):   controller
                                                                      .showAllChatUser
                                                                      ?.chatheads[
                                                                          index]
                                                                      .profilepic !=
                                                                  null
                                                              ? ExtendedImage
                                                                  .memory(
                                                                  height: 24,
                                                                  width: 24,
                                                                  imageData!,
                                                                  shape: BoxShape
                                                                      .circle,
                                                                )
                                                              : ExtendedImage
                                                                  .asset(
                                                                  height: 24,
                                                                  width: 24,
                                                                  'assets/icons/personavator.png',
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            // SizedBox(
                                                                            //     width: 20,
                                                                            //     child: CircleAvatar(
                                                                            //       backgroundColor: Palette.chatBg,
                                                                            //       child: Text(
                                                                            //         widget.msgCount,
                                                                            //         style: TextStyles.notificationWhiteBold,
                                                                            //         textAlign: TextAlign.center,
                                                                            //       ),
                                                                            //     )),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Positioned(
                                                                    bottom: -5,
                                                                    child:
                                                                        Container(
                                                                      width: width -
                                                                          60 -
                                                                          54,
                                                                      height: 1,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .black
                                                                              .withOpacity(0.05)),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                          )),*/
                )
              ]
              // ],
              ),
        ),
      ),
    );
  }
}
