import 'dart:io';

import 'package:fifty_one_cash/src/models/CreateGroupChatResponse.dart';
import 'package:fifty_one_cash/src/models/get-contacts.dart';
import 'package:fifty_one_cash/src/modules/dashboard/chat/utils/GroupContactsTile.dart';
import 'package:fifty_one_cash/src/services/ApiService.dart';
import 'package:fifty_one_cash/src/widgets/ShimmerTile.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddUsersToGroupChat extends StatefulWidget {
  const AddUsersToGroupChat({
    super.key,
    required this.group,
  });
  final CreateGroupChatResponse group;
  // final

  @override
  State<AddUsersToGroupChat> createState() => _AddUsersToGroupChatState();
}

class _AddUsersToGroupChatState extends State<AddUsersToGroupChat> {
  List<ContactsDetails> generalContacts = [];

  CreateGroupChatResponse? groupDetails;

  bool isLoading = false;

  getContacts() async {
    generalContacts = [];
    isLoading = true;
    if (mounted) {
      setState(() {});
    }
    GetContacts? contacts = await ApiService().getContacts();
    if (contacts != null) {
      generalContacts = contacts.generalContacts;
    }

    isLoading = false;
    if (context.mounted) {
      setState(() {});
    }
  }

  getGroupDetails() async {
    if (widget.group.groupId != null) {
      groupDetails =
          await ApiService().getChatGroupDetails(widget.group.groupId);
    }
  }

  @override
  void initState() {
    getGroupDetails();
    getContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: Platform.isIOS
            ? const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark)
            : const SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Palette.primaryColor,
                Palette.secondaryColor,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        title: Text(
          widget.group.groupName ?? 'Group Name',
          style: TextStyles.appBarTitleWhite,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 20,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: MediaQuery.removePadding(
          context: context,
          child: isLoading
              ? ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) => ShimmerTile(width: width))
              : ListView.builder(
                  itemCount: generalContacts.length,
                  itemBuilder: (context, index) => GroupContactsTile(
                        contactsDetails: generalContacts[index],
                        groupUsers: groupDetails?.members,
                        group: widget.group,
                      ))),
    );
  }
}
