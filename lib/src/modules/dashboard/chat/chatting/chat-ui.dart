import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:fifty_one_cash/constants.dart';
import 'package:fifty_one_cash/src/models/PersonalChatResponse.dart';
import 'package:fifty_one_cash/src/models/StreamChatMessageResponse.dart';
import 'package:fifty_one_cash/src/models/get-contacts.dart';
import 'package:fifty_one_cash/src/modules/dashboard/chat/chat.dart';
import 'package:fifty_one_cash/src/controller/showAllChatUser.dart';
import 'package:fifty_one_cash/src/services/ApiService.dart';
import 'package:fifty_one_cash/src/services/SharedData.dart';
import 'package:fifty_one_cash/src/services/toast-msg.dart';
import 'package:fifty_one_cash/src/widgets/ShimmerChat.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'utils/chat-bubble.dart';
import 'utils/chat-msg-input.dart';

class ChatUi extends StatefulWidget {
  const ChatUi({
    super.key,
    required this.receiverDetails,
    this.isThisGroupChat = false,
    this.groupId,
  });

  final ContactsDetails receiverDetails;
  final bool? isThisGroupChat;
  final int? groupId;

  @override
  State<ChatUi> createState() => _ChatUiState();
}

class _ChatUiState extends State<ChatUi> {
  // var messages = Datas().messages.reversed.toList();
  WebSocketChannel? webSocketChannel;
  Stream? stream;
  PersonalChat? personalChat;
  int? myId;
  int page = 0;

  List<Messages> allMessages = [];
  List<StreamChatMessageResponse> sentMessages = [];

  String? token;
  String? userId;
  String? phoneNumber;
  String? typeMsg;

  Duration scrollDelay = const Duration(milliseconds: 500);
  final ScrollController scrollController = ScrollController();
  final controller =Get.put(ShowAllChatUserController());
  bool isLoading = false;
  bool isTyping = false;

  void handleTextFieldChanged(String text) {
    setState(() {
      isTyping = text.isNotEmpty;
    });
  }

  scrollDown() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.minScrollExtent,
        duration: scrollDelay,
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  webSocketConnection() async {
    if (token != null) {
      webSocketChannel = IOWebSocketChannel.connect(
          Uri.parse(widget.isThisGroupChat == true
              ? Consts.webSocketGroupChatUrl
              : Consts.webSocketPersonalChatUrl),
          headers: {'Authorization': 'Bearer $token'});
      stream = webSocketChannel?.stream;
      stream?.listen((event) {
        allMessages.insert(
            0,
            Messages.fromStream(
                StreamChatMessageResponse.fromJson(jsonDecode(event))));
        setState(() {});
      });
    }
  }
  getPersonalMessages(int page) async {
    personalChat =
        await ApiService().getPersonalChat(widget.receiverDetails, page);
    if (personalChat?.messages != null) {
      allMessages.addAll(personalChat!.messages);
    }
    isLoading = false;
    setState(() {});
  }

  getGroupMessages(int page) async {
    if (widget.groupId != null && widget.isThisGroupChat == true) {
      await ApiService().getGroupChat(widget.groupId!, page);
      // if (personalChat?.messages != null) {
      //   allMessages.addAll(personalChat!.messages);
      // }
      isLoading = false;
      setState(() {});
    }
  }

  getStoredDataAndInitSocket() async {
    token = await SharedData.getToken();
    userId = await SharedData.getUserId();
    if (userId != null) {
      myId = int.parse(userId!);
    }
    phoneNumber = await SharedData.getPhoneNumber();
    webSocketConnection();
  }

  sendMessage() {
    if (typeMsg != null && typeMsg?.trim() != '') {
      if (webSocketChannel != null) {
        if (widget.isThisGroupChat == false) {
          webSocketChannel!.sink.add(jsonEncode({
            "senderuserid": myId,
            "sendermobilenumber": phoneNumber,
            "receiveruserid": widget.receiverDetails.id,
            "receivermobilenumber": widget.receiverDetails.mobileNumber,
            "message": typeMsg,
            "messagetype": "TEXT",
            "chattype": "PERSONAL"
          }));
        } else {
          webSocketChannel!.sink.add(jsonEncode({
            "senderuserid": myId,
            "sendermobilenumber": phoneNumber,
            "groupid": widget.groupId,
            "message": typeMsg,
            "messagetype": "TEXT",
            "chattype": "GROUP"
          }));
        }
        typeMsg = null;
      }
    }
  }

  // scrollControllerListener() {
  //   scrollController.addListener(() {
  //     if (scrollController.offset ==
  //         scrollController.position.maxScrollExtent) {
  //       page = page + 1;

  //       getPersonalMessages(page);
  //     }
  //   });
  // }



  Uint8List? imageData;
  getProfileImageThroughApi() async {
    if (widget.receiverDetails != null) {
      if (widget.receiverDetails.profilePicUrl != null) {
        imageData = await ApiService()
            .getProfileImage(widget.receiverDetails.profilePicUrl!);
        if (mounted) {
          setState(() {});
        }
      }
    }
  }

  @override
  void initState() {
    if (widget.receiverDetails.profilePicUrl != null) {
      getProfileImageThroughApi();
    }
    if (widget.receiverDetails.id != null) {
      isLoading = true;
      if (mounted) {
        setState(() {});
      }
      getStoredDataAndInitSocket();
      if (widget.isThisGroupChat == true) {
        getGroupMessages(page);
      } else {
        getPersonalMessages(page);
      }
    } else {
      ToastMsg().sendErrorMsg("This user don't exist");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('Qaiser token : ${token}');
    print('Qaiser token : ${widget.receiverDetails.id}');
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        centerTitle: false,
        leadingWidth: 50,
        leading: InkWell(
          onTap: () {controller.FetchData();
            Navigator.pop(context);
          },
          child: const Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              scrollDown();
              if (kDebugMode) {
                print("Scroll");
              }
            },
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
              size: 22,
            ),
          ),
        ],
        title: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Row(
            children: [
              imageData == null
                  ? ExtendedImage.asset(
                      'assets/icons/personavator.png',
                      height: 40,
                      width: 40,
                      shape: BoxShape.circle,
                    )
                  : ExtendedImage.memory(
                      imageData!,
                      height: 40,
                      width: 40,
                      shape: BoxShape.circle,
                    ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      widget.receiverDetails.firstName != null ||
                              widget.receiverDetails.lastName != null
                          ? "${widget.receiverDetails.firstName ?? ''} ${widget.receiverDetails.lastName ?? ''}"
                          : widget.receiverDetails.mobileNumber ??
                              'No Identity',
                      style: TextStyles.chatUiName,
                    ),
                  ),
                  Opacity(
                    opacity: 0.5,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        isTyping ? "typing..." : "online",
                        style: TextStyles.bodyWhite,
                      ),
                    ),
                  ),
                ],
              ),
            ],
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
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async {
                page = page + 1;
                await getPersonalMessages(page);
              },
              child: isLoading
                  ? ListView.builder(
                      itemCount: 10,
                      reverse: true,
                      padding: const EdgeInsets.only(top: 0, bottom: 100),
                      itemBuilder: (context, index) => const ShimmerChat())
                  : allMessages.isNotEmpty
                      ? ListView.builder(
                          itemCount: allMessages.length,
                          shrinkWrap: true,
                          reverse: true,
                          padding: const EdgeInsets.only(top: 30, bottom: 100),
                          controller: scrollController,
                          itemBuilder: (context, index) {
                            // return Padding(
                            //   padding: const EdgeInsets.only(
                            //       left: 7, right: 7, top: 5, bottom: 5),
                            //   child: Align(
                            //     alignment:
                            //         (messages[reversedIndex].messageType == "receiver"
                            //             ? Alignment.topLeft
                            //             : Alignment.topRight),
                            //     child: Container(
                            //       constraints: BoxConstraints(
                            //         maxWidth: width * 0.8,
                            //       ),
                            //       decoration: BoxDecoration(
                            //         borderRadius:
                            //             (messages[reversedIndex].messageType == "receiver")
                            //                 ? const BorderRadius.only(
                            //                     topRight: Radius.circular(25),
                            //                     bottomLeft: Radius.circular(25),
                            //                     bottomRight: Radius.circular(25))
                            //                 : const BorderRadius.only(
                            //                     topLeft: Radius.circular(25),
                            //                     topRight: Radius.circular(25),
                            //                     bottomLeft: Radius.circular(25)),
                            //         color:
                            //             (messages[reversedIndex].messageType == "receiver")
                            //                 ? Palette.primaryColor
                            //                 : Palette.chatBg2,
                            //       ),
                            //       padding: const EdgeInsets.all(12),
                            //       child: Text(messages[reversedIndex].messageContent,
                            //           style: TextStyles.chatTypeMsg),
                            //     ),
                            //   ),
                            // );
                            if (allMessages[index].messageType == 'TEXT') {
                              return
                                  // widget.isThisGroupChat == true
                                  //     ?
                                  // GroupChatBubble(
                                  //     messageType:
                                  //         allMessages[index].fromUser != myId
                                  //             ? 'receiver'
                                  //             : 'sender',
                                  //     messageContent:
                                  //         allMessages[index].message ?? '');
                                  // :
                                  ChatBubble(
                                messageType: allMessages[index].fromUser != myId
                                    ? 'receiver'
                                    : 'sender',
                                messageContent:
                                    allMessages[index].message ?? '',
                                    time: allMessages[index].createdTime??'',
                              );
                            }
                            // if (messages[reversedIndex].sendMoney == true) {
                            //   return SendMoneyBubble(
                            //     messageType: messages[reversedIndex].messageType,
                            //     messageContent: messages[reversedIndex].messageContent,
                            //   );
                            // }
                            // if (messages[reversedIndex].requestMoney == true) {
                            //   return RequestMoneyBubble(
                            //     sendMoney: () {
                            //       sendMoney(messages[reversedIndex].messageContent);
                            //     },
                            //     isMedia: messages[reversedIndex].isMedia,
                            //     messageType: messages[reversedIndex].messageType,
                            //     messageContent: messages[reversedIndex].messageContent,
                            //   );
                            // }
                          },
                        )
                      : Center(
                          child: Image.asset(
                          "assets/icons/EmptyChat.png",
                          width: width / 1.2,
                          height: height / 2,
                        )),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: ChatMsgInput(requestMoney: () {
                  // requestMoney(typeMsg);
                }, sendMoney: () {
                  // sendMoney(typeMsg);
                }, sendMessage: () {
                  sendMessage();
                }, onChanged: (value) {
                  handleTextFieldChanged(value);
                  setState(() {
                    typeMsg = value;
                  });
                }, tap: () {
                  scrollDown();
                })),
          ],
        ),
      ),
    );
  }

  // // void sendMessage(String? content) {
  // //   if (content != null) {
  // //     final newMessage = ChatMessage(
  // //       messageContent: content,
  // //       messageType: "sender",
  // //       isMedia: false,
  // //       time: DateTime.now(),
  // //       isSeen: false,
  // //       sendMoney: false,
  // //       requestMoney: false,
  // //     );
  // //     setState(() {
  // //       messages.add(newMessage);
  // //       typeMsg = null;
  // //     });
  // //   }
  // // }

  // void sendMoney(String? content) {
  //   if (content != null) {
  //     pushNewScreen(
  //       context,
  //       screen: EnterMasterPin(
  //           navigatePage: PaymentSuccessful(
  //         amount: content,
  //         name: "Shivay Kumar",
  //       )),
  //       withNavBar: false,
  //       pageTransitionAnimation: PageTransitionAnimation.cupertino,
  //     );
  //     final newMessage = ChatMessage(
  //       messageContent: content,
  //       messageType: "sender",
  //       isMedia: false,
  //       time: DateTime.now(),
  //       isSeen: false,
  //       sendMoney: true,
  //       requestMoney: false,
  //     );
  //     webSocketChannel!.sink.add(jsonDecode('data'));
  //     setState(() {
  //       messages.add(newMessage);
  //       typeMsg = null;
  //     });
  //   }
  // }

  // void requestMoney(String? content) {
  //   if (content != null) {
  //     final newMessage = ChatMessage(
  //       messageContent: content,
  //       messageType: "sender",
  //       isMedia: false,
  //       time: DateTime.now(),
  //       isSeen: false,
  //       sendMoney: false,
  //       requestMoney: true,
  //     );
  //     setState(() {
  //       messages.add(newMessage);
  //       typeMsg = null;
  //     });
  //   }
  // }
}
