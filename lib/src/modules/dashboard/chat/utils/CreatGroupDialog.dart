import 'dart:io';

import 'package:fifty_one_cash/src/models/CreateGroupChatResponse.dart';
import 'package:fifty_one_cash/src/modules/dashboard/chat/utils/AddUsersToGroupChat.dart';
import 'package:fifty_one_cash/src/services/ApiService.dart';
import 'package:fifty_one_cash/src/widgets/button-one.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';

class CreateGroupDialog extends StatefulWidget {
  const CreateGroupDialog({super.key});

  @override
  State<CreateGroupDialog> createState() => _CreateGroupDialogState();
}

class _CreateGroupDialogState extends State<CreateGroupDialog> {
  String groupName = '';

  bool isLoading = false;

  XFile? pickedImage;

  createGroup() async {
    if (groupName.isNotEmpty && groupName.trim() != '') {
      isLoading = true;
      if (mounted) {
        setState(() {});
      }
      CreateGroupChatResponse? result =
          await ApiService().createChatGroup(groupName);
      isLoading = false;
      if (mounted) {
        setState(() {});
      }
      if (result != null) {
        if (pickedImage != null && result.groupId != null) {
          await ApiService()
              .uploadChatGroupImage(pickedImage!, result.groupId!);
        }
        if (mounted) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: AddUsersToGroupChat(
                group: result,
              ),
            ),
          );
        }
      }
    }
  }

  getImage() async {
    ImagePicker picker = ImagePicker();
    pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white, borderRadius: BorderStyles.alertDialogRadius),
      padding: const EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width - 40,
      child: ListView(
        shrinkWrap: true,
        children: [
          UnconstrainedBox(
            child: GestureDetector(
              onTap: () {
                getImage();
              },
              child: Stack(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: pickedImage != null
                          ? DecorationImage(
                              image: FileImage(File(pickedImage!.path)),
                              fit: BoxFit.fill,
                            )
                          : const DecorationImage(
                              image:
                                  AssetImage("assets/icons/personavator.png"),
                              fit: BoxFit.fill,
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 3,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                            colors: [Palette.bgBlue1, Palette.bgBlue2]),
                        border: Border.all(color: Colors.white),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              "Please create group",
              style: TextStyles.alertDialogTitle,
              textAlign: TextAlign.center,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 3.0, left: 5, right: 5),
            child: Text(
              "Enter a name to your chat which will make your chat group unique",
              style: TextStyles.appBarTabBlack,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: TextField(
              onChanged: (value) {
                groupName = value;
              },
              style: TextStyles.textAreaAlertDialog,
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                hintText: 'Enter a unique name',
                hintStyle: TextStyles.textAreaAlertDialog,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xffE7E7E7),
                  ),
                  borderRadius: BorderStyles.alertDialogRadius,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xffE7E7E7),
                  ),
                  borderRadius: BorderStyles.alertDialogRadius,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xffE7E7E7),
                  ),
                  borderRadius: BorderStyles.alertDialogRadius,
                ),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ButtonOne(
                  height: 40,
                  textStyle: TextStyles.buttonOnSmallFont,
                  isLoading: isLoading,
                  onTap: () {
                    createGroup();
                  },
                  title: "Create Group"))
        ],
      ),
    );
  }
}
