import 'package:fifty_one_cash/src/models/get-contacts.dart';
import 'package:fifty_one_cash/src/modules/dashboard/chat/chat.dart';
import 'package:fifty_one_cash/src/modules/ProviderStateManagementViewModel/ChatSearchTileViewModel.dart';
import 'package:fifty_one_cash/src/modules/dashboard/contancts/utils/ContactsTile.dart';
import 'package:fifty_one_cash/src/modules/ProviderStateManagementViewModel/SearchContactsViewModel.dart';
import 'package:fifty_one_cash/src/services/ApiService.dart';
import 'package:fifty_one_cash/src/widgets/IconAndTextButton.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class ChatSearchTile extends StatefulWidget {
  // final bool isContact;
  const ChatSearchTile({super.key, required this.contact});

  final ContactsDetails contact;

  @override
  State<ChatSearchTile> createState() => _ChatSearchTileState();
}

class _ChatSearchTileState extends State<ChatSearchTile> {
  Uint8List? imageData;

  getProfileImageThroughApi() async {
    if (widget.contact.profilePicUrl != null) {
      imageData =
          await ApiService().getProfileImage(widget.contact.profilePicUrl!);
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    getProfileImageThroughApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          ChatSearchTileViewModel(context: context, contact: widget.contact),
      child: Consumer<ChatSearchTileViewModel>(
        builder: (context, model, child) => Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: CircleAvatar(
                          radius: 32,
                          backgroundColor: Palette.sky,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: imageData != null
                                ? MemoryImage(imageData!)
                                : const AssetImage(
                                        "assets/icons/personavator.png")
                                    as ImageProvider,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.contact.userName ?? "@user_name",
                            style: TextStyles.paraBigBoldWhite,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Opacity(
                              opacity: 0.7,
                              child: Text(
                                "${widget.contact.firstName ?? 'Ada'} ${widget.contact.lastName ?? 'Byron'}",
                                style: TextStyles.bodyWhite,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      model.isLoading == false
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (widget.contact.friendStatus == 'BLOCKED' ||
                                    widget.contact.friendStatus == 'FRIEND' ||
                                    widget.contact.friendStatus == 'FRIENDS' ||
                                    widget.contact.friendStatus ==
                                        'BLOCKED_BY_PRINCIPAL' ||
                                    widget.contact.friendStatus ==
                                        'BLOCKED_BY_SEARCHED_USER') ...[
                                  PopupMenuButton<String>(
                                    surfaceTintColor: Colors.white,
                                    color: Colors.white,
                                    icon: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border:
                                              Border.all(color: Palette.grey1),
                                          borderRadius: BorderStyles.norm2),
                                      child: const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        size: 20,
                                        color: Palette.secondaryColor,
                                      ),
                                    ),
                                    itemBuilder: (BuildContext context) {
                                      return <PopupMenuEntry<String>>[
                                        if (widget.contact.friendStatus ==
                                                'Blocked' ||
                                            widget.contact.friendStatus ==
                                                'BLOCKED_BY_PRINCIPAL' ||
                                            widget.contact.friendStatus ==
                                                'BLOCKED_BY_SEARCHED_USER') ...[
                                          const PopupMenuItem<String>(
                                            value: 'unBlockAccount',
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 8.0),
                                                  child: Text('UnBlock'),
                                                ),
                                                Icon(
                                                  Icons.lock_open_sharp,
                                                  color: Colors.green,
                                                  size: 20,
                                                )
                                              ],
                                            ),
                                          ),
                                        ] else ...[
                                          const PopupMenuItem<String>(
                                            value: 'blockAccount',
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 8.0),
                                                  child: Text('Block Contact'),
                                                ),
                                                Icon(
                                                  Icons.block,
                                                  color: Colors.red,
                                                  size: 20,
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                        const PopupMenuItem<String>(
                                          value: 'unFriend',
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(right: 8.0),
                                                child: Text('Remove Contact'),
                                              ),
                                              Icon(
                                                Icons.group_remove_outlined,
                                                color: Colors.red,
                                                size: 20,
                                              )
                                            ],
                                          ),
                                        ),
                                      ];
                                    },
                                    onSelected: (String value) {
                                      switch (value) {
                                        case 'blockAccount':
                                          model.blockAccount();
                                          break;
                                        case 'unBlockAccount':
                                          model.unBlockAccount();
                                          break;
                                        case 'unFriend':
                                          model.removeContact();
                                          break;
                                      }
                                    },
                                  ),
                                ] else ...[
                                  ...model.getIconWidget(widget.contact),
                                ],
                              ],
                            )
                          : const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                    ],
                  )
                ],
              ),
              if (widget.contact.friendStatus == 'FRIEND' ||
                  widget.contact.friendStatus == 'FRIENDS') ...[
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: IconAndTextButton(
                    title: "SendMessage",
                    icon: Icons.email,
                    onTap: () async {
                      await pushNewScreen(
                        context,
                        screen: const Chats(),
                        withNavBar: false, // OPTIONAL VALUE. True by default.
                        pageTransitionAnimation:
                            PageTransitionAnimation.slideUp,
                      );
                    },
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
