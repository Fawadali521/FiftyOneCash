// Created by MHK-MotoVlogs

import 'dart:io';

import 'package:fifty_one_cash/src/modules/dashboard/dashboard.dart';
import 'package:fifty_one_cash/src/services/ApiService.dart';
import 'package:fifty_one_cash/src/services/SharedData.dart';
import 'package:fifty_one_cash/src/services/toast-msg.dart';
import 'package:fifty_one_cash/src/widgets/UserNameTextField.dart';
import 'package:fifty_one_cash/src/widgets/button-one.dart';
import 'package:fifty_one_cash/src/widgets/text-field-one.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

class UpdateUserProfile extends StatefulWidget {
  const UpdateUserProfile({super.key});

  @override
  State<UpdateUserProfile> createState() => _UpdateUserProfileState();
}

class _UpdateUserProfileState extends State<UpdateUserProfile> {
  String? userName;
  String? gender;
  String? firstName;
  String? lastName;
  String? profilePictureUrl;
  String? updatedFirstName;
  String? updatedGender;
  String? updatedUserName;
  String? updatedLastName;
  String? updatedDob;

  Uint8List? imageData;

  DateTime? selectedDate;
  DateTime? updatedSelectedDate;

  List<String> genderOptions = ['MALE', 'FEMALE', 'NOT_DISCLOSED'];

  Icon? usernameIcon;

  File? choosenImage;

  bool isLoading = false;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime(1900, 1),
        lastDate: DateTime(2101),
        initialDate: DateTime.now());
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        updatedSelectedDate = picked;
      });
    }
  }

  checkUserName(value) async {
    if (value != "" && value.length > 4) {
      bool? isAvailable = await ApiService().checkUserNameAvailability(value);
      if (isAvailable == true) {
        setState(() {
          updatedUserName = value;
          usernameIcon = const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 20,
          );
        });
      } else if (isAvailable == false) {
        setState(() {
          updatedUserName =
              null; // You can choose to keep the entered value if you want
          usernameIcon = const Icon(
            Icons.error,
            color: Colors.red,
            size: 20,
          );
        });
      } else {
        setState(() {
          updatedUserName = null;
          usernameIcon = null;
        });
        ToastMsg().sendErrorMsg("Error checking username availability.");
      }
    } else {
      ToastMsg().sendErrorMsg("Username must be at least 5 characters long.");
      setState(() {
        updatedUserName = null;
        usernameIcon = null;
      });
    }
  }

  Future<void> handleUpdateUser() async {
    if (updatedSelectedDate != null) {
      updatedDob =
          "${updatedSelectedDate!.year}-${updatedSelectedDate!.month.toString().padLeft(2, '0')}-${updatedSelectedDate!.day.toString().padLeft(2, '0')}";
    }

    if (updatedFirstName != null ||
        updatedLastName != null ||
        updatedUserName != null ||
        updatedDob != null ||
        updatedGender != null) {
      try {
        setState(() {
          isLoading = true;
        });
        bool isSuccess = await ApiService().updateUser(
          firstname: updatedFirstName != null ? updatedFirstName!.trim() : null,
          lastname: updatedLastName != null ? updatedLastName!.trim() : null,
          username: updatedUserName != null ? updatedUserName!.trim() : null,
          gender: updatedGender,
          dob: updatedDob,
        );

        if (isSuccess) {
          setState(() {
            isLoading = false;
          });
          ToastMsg().sendSuccessMsg("User data updated successfully");
          if (mounted) {
            Navigator.pushReplacement(
                context,
                PageTransition(
                    type: PageTransitionType.fade, child: const DashBoard()));
          }
        } else {
          ToastMsg().sendErrorMsg("Failed to update user data");
          setState(() {
            isLoading = false;
          });
        }
      } catch (error) {
        ToastMsg().sendErrorMsg("Error: $error");
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  getStoredUserProfile() async {
    firstName = await SharedData.getFirstName();
    lastName = await SharedData.getLastName();
    userName = await SharedData.getUserName();
    gender = await SharedData.getGender();
    profilePictureUrl = await SharedData.getProfilePicture();
    String? dob = await SharedData.getDob();

    if (firstName != null && firstName!.trim().isNotEmpty) {
      firstNameController.text = firstName!;
    }

    if (lastName != null && lastName!.trim().isNotEmpty) {
      lastNameController.text = lastName!;
    }

    if (userName != null && userName!.trim().isNotEmpty) {
      userNameController.text = userName!;
    }

    if (dob != null) {
      selectedDate = DateTime.parse(dob);
    }

    if (profilePictureUrl != null) {
      imageData = await ApiService().getProfileImage(profilePictureUrl!);
    }
    setState(() {});
  }

  saveImage() async {
    if (choosenImage != null) {
      isLoading = true;
      setState(() {});
      bool? isSuccess =
          await ApiService().updateProfileImage(image: choosenImage!);
      if (isSuccess) {
        ToastMsg().sendSuccessMsg("Profile picture updated Successfuly");
        isLoading = false;
        setState(() {});
      } else {
        isLoading = false;
        setState(() {});
      }
    } else {
      ToastMsg().sendErrorMsg("Choose Image First");
    }
  }

  chooseImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      choosenImage = File(pickedImage.path);
    } else {
      choosenImage = null;
    }
    setState(() {});
  }

  @override
  void initState() {
    getStoredUserProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
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
          title: const Text(
            "Update Profile",
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
          removeTop: true,
          child: ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                chooseImageFromGallery();
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    height: 102,
                                    width: 102,
                                    decoration: BoxDecoration(
                                      color: Palette.sky,
                                      borderRadius: BorderRadius.circular(100),
                                    ),

                                    // Edited by MHK-MotoVlogs
                                    child: Center(
                                      child: Container(
                                        height: 98,
                                        width: 98,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                              colors: [
                                                Palette.bgBlue1,
                                                Palette.bgBlue2
                                              ]),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: Center(
                                          child: Container(
                                            height: 96,
                                            width: 96,
                                            decoration: BoxDecoration(
                                              image: choosenImage != null
                                                  ? DecorationImage(
                                                      image: FileImage(
                                                        File(
                                                            choosenImage!.path),
                                                      ),
                                                      fit: BoxFit.cover,
                                                    )
                                                  : imageData == null
                                                      ? const DecorationImage(
                                                          image: AssetImage(
                                                              "assets/icons/personavator.png"),
                                                          fit: BoxFit.cover)
                                                      : DecorationImage(
                                                          image: MemoryImage(
                                                            imageData!,
                                                          ),
                                                          fit: BoxFit.cover,
                                                        ),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    //end
                                  ),
                                  Positioned(
                                    bottom: 3,
                                    right: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: const LinearGradient(colors: [
                                          Palette.bgBlue1,
                                          Palette.bgBlue2
                                        ]),
                                        border: Border.all(color: Colors.white),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 5),
                              child: Row(
                                children: [
                                  Text(
                                    "First Name",
                                    style: TextStyles.paraBlack,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: width - 40,
                              child: TextFieldOne(
                                controller: firstNameController,
                                onChanged: (x) {
                                  setState(() {
                                    updatedFirstName = x;
                                  });
                                },
                                hint: "Enter Your First Name",
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Row(
                                  children: [
                                    Text(
                                      "Last Name",
                                      style: TextStyles.paraBlack,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: width - 40,
                                child: TextFieldOne(
                                  controller: lastNameController,
                                  onChanged: (x) {
                                    setState(() {
                                      updatedLastName = x;
                                    });
                                  },
                                  hint: "Enter Your Last Name",
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Row(
                                  children: [
                                    Text(
                                      "User Name",
                                      style: TextStyles.paraBlack,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: width - 40,
                                child: UserNameTextField(
                                  controller: userNameController,
                                  onChanged: (value) async {
                                    await checkUserName(value);
                                  },
                                  hint: "Enter Unique User Name",
                                  suffixIcon: usernameIcon,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Date Of Birth",
                                      style: TextStyles.paraBlack,
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      width: (width - 40 - 20) / 2,
                                      child: const Text(
                                        "Gender",
                                        style: TextStyles.paraBlack,
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                      width: (width - 40 - 20) / 2,
                                      child: InkWell(
                                        onTap: () {
                                          selectDate(context);
                                        },
                                        child: Container(
                                          width: (width - 40 - 20) / 2,
                                          height: 45,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderStyles.norm2,
                                            color: Palette.lightGrey3,
                                          ),
                                          child: Center(
                                              child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 12),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                (selectedDate == null)
                                                    ? Text(
                                                        "Select Your DOB",
                                                        style: TextStyles()
                                                            .bodySemiBlack,
                                                      )
                                                    : Text(
                                                        DateFormat.yMMMMd()
                                                            .format(
                                                                selectedDate!),
                                                        style: TextStyles
                                                            .bodyBlack,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                              ],
                                            ),
                                          )),
                                        ),
                                      )),
                                  SizedBox(
                                    width: (width - 40 - 20) / 2,
                                    child: Container(
                                      width: (width - 40 - 20) / 2,
                                      height: 45,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderStyles.norm2,
                                        color: Palette.lightGrey3,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: gender,
                                          isExpanded: true,
                                          hint: Text(
                                            "Select Gender",
                                            style: TextStyles().bodySemiBlack,
                                          ),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              gender = newValue;
                                              updatedGender = newValue;
                                            });
                                          },
                                          items: genderOptions
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value,
                                                  style: TextStyles.bodyBlack),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25),
                          child: SizedBox(
                            width: width - 40,
                            height: 45,
                            child: ButtonOne(
                              isLoading: isLoading,
                              onTap: () async {
                                if (choosenImage != null) {
                                  await saveImage();
                                }
                                await handleUpdateUser();
                              },
                              title: "Save".toUpperCase(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
