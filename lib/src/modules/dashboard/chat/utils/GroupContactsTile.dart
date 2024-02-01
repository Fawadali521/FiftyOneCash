import 'package:extended_image/extended_image.dart';
import 'package:fifty_one_cash/src/models/CreateGroupChatResponse.dart';
import 'package:fifty_one_cash/src/models/get-contacts.dart';
import 'package:fifty_one_cash/src/services/ApiService.dart';
import 'package:fifty_one_cash/src/widgets/button-one.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GroupContactsTile extends StatefulWidget {
  GroupContactsTile({
    super.key,
    required this.contactsDetails,
    required this.groupUsers,
    required this.group,
  });
  final ContactsDetails contactsDetails;
  final CreateGroupChatResponse group;

  List<ContactsDetails>? groupUsers;

  @override
  State<GroupContactsTile> createState() => _GroupContactsTileState();
}

class _GroupContactsTileState extends State<GroupContactsTile> {
  Uint8List? imageData;
  ContactsDetails contactPresent = ContactsDetails();

  bool isLoading = false;

  getProfileImageThroughApi() async {
    if (widget.contactsDetails.profilePicUrl != null) {
      imageData = await ApiService()
          .getProfileImage(widget.contactsDetails.profilePicUrl!);
      if (mounted) {
        setState(() {});
      }
    }
  }

  addUserToGroup() async {
    print("entered into add user");
    isLoading = true;
    if (mounted) {
      setState(() {});
    }
    bool result = await ApiService()
        .addMemberToChatGroup(widget.contactsDetails.id, widget.group.groupId);
    if (result) {
      contactPresent.id = widget.contactsDetails.id;
    }
    isLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  removeUserFromGroup() async {
    isLoading = true;
    if (mounted) {
      setState(() {});
    }
    bool result = await ApiService().removeMemberFromGroupChat(
        widget.contactsDetails.id, widget.group.groupId);
    if (result) {
      contactPresent.id = null;
    }
    isLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    if (widget.groupUsers != null) {
      contactPresent = widget.groupUsers!.firstWhere(
          (element) => element.id == widget.contactsDetails.id,
          orElse: () => ContactsDetails());
    }
    getProfileImageThroughApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      margin: const EdgeInsets.only(
        left: 20,
        bottom: 5,
        top: 15,
        right: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              imageData == null
                  ? ExtendedImage.asset(
                      'assets/icons/personavator.png',
                      height: 45,
                      width: 45,
                      shape: BoxShape.circle,
                    )
                  : ExtendedImage.memory(
                      imageData!,
                      height: 45,
                      width: 45,
                      shape: BoxShape.circle,
                    ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 12.0,
                ),
                child: SizedBox(
                  width: width / 2.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.contactsDetails.firstName ?? ''} ${widget.contactsDetails.lastName ?? ''}",
                        style: TextStyles.customerNameOnContacts,
                      ),
                      Text(
                        "@${widget.contactsDetails.userName}",
                        style: TextStyles.customerUserNameOnContacts,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          contactPresent.id != null
              ? ButtonOne(
                  width: width / 3,
                  height: height / 20,
                  onTap: () {
                    removeUserFromGroup();
                  },
                  showShadow: false,
                  isLoading: isLoading,
                  title: 'Remove User',
                  textStyle: TextStyles.buttonOneSmallestFontBlue,
                  backgroundColor: Palette.buttonIconColor.withOpacity(0.5),
                )
              : ButtonOne(
                  width: width / 3,
                  height: height / 20,
                  onTap: () {
                    addUserToGroup();
                  },
                  isLoading: isLoading,
                  title: "Add User",
                  textStyle: TextStyles.buttonOneSmallFont,
                )
        ],
      ),
    );
  }
}
