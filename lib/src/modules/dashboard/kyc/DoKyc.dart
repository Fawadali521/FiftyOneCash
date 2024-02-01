// Created by MHK-MotoVlogs

import 'dart:io';

import 'package:fifty_one_cash/src/modules/ProviderStateManagementViewModel/GlobalViewModel.dart';
import 'package:fifty_one_cash/src/modules/dashboard/kyc/KycSuccessful.dart';
import 'package:fifty_one_cash/src/services/ApiService.dart';
import 'package:fifty_one_cash/src/services/SharedData.dart';
import 'package:fifty_one_cash/src/services/toast-msg.dart';
import 'package:fifty_one_cash/src/widgets/button-one.dart';
import 'package:fifty_one_cash/src/widgets/text-field-one.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'utils/KycImageContainer.dart';

class DoKyc extends StatefulWidget {
  const DoKyc({super.key});

  @override
  State<DoKyc> createState() => _DoKycState();
}

class _DoKycState extends State<DoKyc> {
  String? userName;
  String? gender;
  String? tnx;
  String? address;
  String? nationalityOption;
  String? documentType;

  DateTime? selectedDate;

  List<String> genderOptions = ['MALE', 'FEMALE', 'NOT_DISCLOSED'];
  List<String> nationalityOptions = ['India', 'Pakistan', 'Afghanistan'];
  List<String> documentTypes = ['Driving Licence'];

  Icon? usernameIcon;

  bool isLoading = false;

  int? integerTnx;

  TextEditingController userNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController tnxController = TextEditingController();

  XFile? selfieFile;
  XFile? kycFrontImage;
  XFile? kycBackImage;

  ImagePicker picker = ImagePicker();

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime(1900, 1),
        lastDate: DateTime(2101),
        initialDate: DateTime.now());
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> doKyc() async {
    // Validate required fields

    if (selfieFile == null) {
      ToastMsg().sendErrorMsg("Select selfie picture before proceeding.");
      return;
    }

    if (kycFrontImage == null) {
      ToastMsg().sendErrorMsg("Select KYC Front Image before proceeding.");
      return;
    }

    if (userName == null || userName!.trim().isEmpty) {
      ToastMsg().sendErrorMsg("Name is required");
      return;
    }

    if (userName!.length > 50) {
      ToastMsg().sendErrorMsg("Name length should not exceed 50 characters");
      return;
    }

    if (address == null || address!.trim().isEmpty) {
      ToastMsg().sendErrorMsg("Address field is required.");
      return;
    }

    if (tnx == null || tnx!.trim().isEmpty) {
      ToastMsg().sendErrorMsg("txn field is required.");
      return;
    } else {
      try {
        integerTnx = int.parse(tnx!);
      } catch (e) {
        ToastMsg().sendErrorMsg("Tnx should be numbers not alphabets");
        return;
      }
    }

    if (nationalityOption == null || nationalityOption!.trim().isEmpty) {
      ToastMsg().sendErrorMsg("Nationality field is required.");
      return;
    }

    if (selectedDate == null) {
      ToastMsg().sendErrorMsg("Date of birth is required");
      return;
    }
    if (gender == null) {
      ToastMsg().sendErrorMsg("Select Gender before proceeding.");
      return;
    }

    // Convert selectedDate to string in YYYY-MM-DD format
    String? dobStr;
    if (selectedDate != null) {
      dobStr =
          "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}";
    }

    try {
      setState(() {
        isLoading = true;
      });
      bool? isSuccess = await ApiService().doKyc(
        selfiePic: selfieFile,
        kycBackImage: kycBackImage,
        kycFontPic: kycFrontImage,
        address: address,
        nationality: nationalityOption,
        tnx: integerTnx,
        name: userName,
        dob: dobStr,
        gender: gender,
      );

      if (isSuccess != null && isSuccess) {
        setState(() {
          isLoading = false;
          Provider.of<GlobalViewModel>(context, listen: false).updateStatus();
          Provider.of<GlobalViewModel>(context, listen: false)
              .updateLocalStorageKycStatus(context);
        });
        ToastMsg().sendSuccessMsg("KYC added successfuly");
        if (mounted) {
          Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.fade, child: const KycSuccessful()));
        }
      } else {
        ToastMsg().sendErrorMsg("Failed to update user data");
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      // ToastMsg().sendErrorMsg("Error: $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  getSelfiePicture() async {
    selfieFile = await picker.pickImage(
        source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);
    if (selfieFile != null) {
      setState(() {});
    }
  }

  getKycFrontPicture() async {
    kycFrontImage = await picker.pickImage(source: ImageSource.gallery);
    if (kycFrontImage != null) {
      setState(() {});
    }
  }

  getKycBackPicture() async {
    kycBackImage = await picker.pickImage(source: ImageSource.gallery);
    if (kycBackImage != null) {
      setState(() {});
    }
  }

  getStoredUserProfile() async {
    userName = await SharedData.getUserName();
    gender = await SharedData.getGender();
    String? dob = await SharedData.getDob();

    if (userName != null && userName!.trim().isNotEmpty) {
      userNameController.text = userName!;
    }

    if (dob != null) {
      selectedDate = DateTime.parse(dob);
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
            "KYC",
            style: TextStyles.appBarTitleWhite,
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              size: 20,
              color: Colors.white,
            ),
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
                padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                getSelfiePicture();
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    height: 88,
                                    width: 88,
                                    decoration: const BoxDecoration(
                                      color: Palette.sky,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Container(
                                        height: 84,
                                        width: 84,
                                        decoration: const BoxDecoration(
                                            gradient: LinearGradient(colors: [
                                              Palette.bgBlue1,
                                              Palette.bgBlue2
                                            ]),
                                            shape: BoxShape.circle),
                                        child: Center(
                                          child: Container(
                                            height: 82,
                                            width: 82,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: selfieFile == null
                                                  ? const DecorationImage(
                                                      image: AssetImage(
                                                          "assets/icons/personavator.png"),
                                                      fit: BoxFit.cover)
                                                  : DecorationImage(
                                                      image: FileImage(
                                                        File(selfieFile!.path),
                                                      ),
                                                      fit: BoxFit.fill,
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
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
                                          Icons.file_upload_outlined,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Text(
                              "Take Selfie",
                              style: TextStyles.paraBlack,
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 5, top: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          getKycFrontPicture();
                                        },
                                        child: KycImageContainer(
                                          kycImage: kycFrontImage,
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Text(
                                          "KYC Front Picture",
                                          style: TextStyles.paraBlack,
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          getKycBackPicture();
                                        },
                                        child: KycImageContainer(
                                          isFront: false,
                                          kycImage: kycBackImage,
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Text(
                                          "KYC Back Picture",
                                          style: TextStyles.paraBlack,
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Opacity(
                              opacity: 0.4,
                              child: Text(
                                "Please enter your details same as official documents",
                                style: TextStyles.bodySmallBlack,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 5, top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Name",
                                    style: TextStyles.paraBlack,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: width - 40,
                              child: TextFieldOne(
                                controller: userNameController,
                                onChanged: (x) {
                                  setState(() {
                                    // firstName = x;
                                    userName = userNameController.text;
                                  });
                                },
                                hint: "Enter Your Name",
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
                                      "Address",
                                      style: TextStyles.paraBlack,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: width - 40,
                                child: TextFieldOne(
                                  controller: addressController,
                                  onChanged: (x) {
                                    setState(() {
                                      // lastName = x;
                                      address = addressController.text;
                                    });
                                  },
                                  hint: "Enter Your Official Address",
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
                                      "Tnx",
                                      style: TextStyles.paraBlack,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: width - 40,
                                child: TextFieldOne(
                                  controller: tnxController,
                                  onChanged: (x) {
                                    setState(() {
                                      // lastName = x;
                                      tnx = tnxController.text;
                                    });
                                  },
                                  hint: "Enter Your Tnx",
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: Text(
                                            "Nationality",
                                            style: TextStyles.paraBlack,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        InkWell(
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<String>(
                                                value: nationalityOption,
                                                isExpanded: true,
                                                hint: Text(
                                                  "Select Nationality",
                                                  style: TextStyles()
                                                      .bodySemiBlack,
                                                ),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    nationalityOption =
                                                        newValue;
                                                  });
                                                },
                                                items: nationalityOptions.map<
                                                        DropdownMenuItem<
                                                            String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value,
                                                        style: TextStyles
                                                            .bodyBlack),
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      "Document Types",
                                      style: TextStyles.paraBlack,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Container(
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
                                        value: documentType,
                                        isExpanded: true,
                                        hint: Text(
                                          "Document Types",
                                          style: TextStyles().bodySemiBlack,
                                        ),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            documentType = newValue;
                                          });
                                        },
                                        items: documentTypes
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
                                ],
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
                                  InkWell(
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
                                                        .format(selectedDate!),
                                                    style: TextStyles.bodyBlack,
                                                    textAlign: TextAlign.center,
                                                  ),
                                          ],
                                        ),
                                      )),
                                    ),
                                  ),
                                  Container(
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
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: SizedBox(
                            width: width - 40,
                            height: 45,
                            child: ButtonOne(
                              isLoading: isLoading,
                              onTap: () async {
                                await doKyc();
                              },
                              title: "Apply KYC".toUpperCase(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
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
