// ignore_for_file: unnecessary_null_comparison

import 'package:extended_image/extended_image.dart';
import 'package:fifty_one_cash/src/models/PersonalChatList.dart';
import 'package:fifty_one_cash/src/services/ApiService.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ChatTile extends StatefulWidget {
  final String msgCount;
  const ChatTile({
    super.key,
     this.chatDetails,
    this.msgCount = '3',
  });

  final ChatDetails? chatDetails;

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  Uint8List? imageData;
  getProfileImageThroughApi() async {
    if (widget.chatDetails != null) {
      if (widget.chatDetails?.profilePic != null) {
        imageData =
            await ApiService().getProfileImage(widget.chatDetails?.profilePic??'');
        if (mounted) {
          setState(() {});
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: 110,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            imageData ==null ? ExtendedImage.asset(
                    height: 54,
                    width: 54,
                    'assets/icons/personavator.png',
                    shape: BoxShape.circle,
                  )
                  :
                ExtendedImage.memory(
                    height: 54,
                    width: 54,
                    imageData as Uint8List,
                    shape: BoxShape.circle,
                  ),
                
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: SizedBox(
                width: width - 60 - 54,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: width - 60 - 54 - 100,
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      widget.chatDetails?.chatHeadName ?? 'User',
                                      style: TextStyles.chatName,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Opacity(
                              opacity: 0.5,
                              child: Text(
                                widget.chatDetails?.lastMessageTime != null
                                    ? DateFormat('h:mm a')
                                        .format(DateTime.parse(widget
                                            .chatDetails?.lastMessageTime??''))
                                        .toString()
                                    : "11:54 AM",
                                style: TextStyles.chatTime,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: width - 60 - 54 - 30,
                                height: 50,
                                child: Row(
                                  children: [
                                    Flexible(
                                        child: RichText(
                                      overflow: TextOverflow.visible,
                                      text: TextSpan(
                                        children: [
                                          WidgetSpan(
                                              child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 2, right: 2),
                                            child: Image.asset(
                                              "assets/icons/double-check.png",
                                              width: 18,
                                              fit: BoxFit.contain,
                                            ),
                                          )),
                                          TextSpan(
                                            text: widget
                                                    .chatDetails?.lastMessage ??
                                                'In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document',
                                            style: TextStyles.chatMsg,
                                          ),
                                        ],
                                      ),
                                    )),
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
                      child: Container(
                        width: width - 60 - 54,
                        height: 1,
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.05)),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  
  }
}
