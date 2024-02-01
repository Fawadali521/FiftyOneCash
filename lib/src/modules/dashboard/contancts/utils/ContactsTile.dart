import 'package:extended_image/extended_image.dart';
import 'package:fifty_one_cash/src/models/get-contacts.dart';
import 'package:fifty_one_cash/src/modules/ProviderStateManagementViewModel/ContactViewModel.dart';
import 'package:fifty_one_cash/src/modules/dashboard/ProfileOfContact/ContactProfile.dart';
import 'package:fifty_one_cash/src/modules/ProviderStateManagementViewModel/ContactTileViewModel.dart';
import 'package:fifty_one_cash/src/modules/ProviderStateManagementViewModel/SearchContactsViewModel.dart';
import 'package:fifty_one_cash/src/services/ApiService.dart';
import 'package:fifty_one_cash/src/widgets/button-one.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class ContactsTile extends StatefulWidget {
  const ContactsTile({
    super.key,
    required this.contact,
    required this.filter,
    this.navigationFromSearch = false,
  });

  final ContactsDetails? contact;

  final bool? navigationFromSearch;
  final String filter;

  @override
  State<ContactsTile> createState() => _ContactsTileState();
}

class _ContactsTileState extends State<ContactsTile> {
  Uint8List? imageData;
  getProfileImageThroughApi(ContactsDetails? contact) async {
    if (contact != null) {
      if (contact.profilePicUrl != null) {
        imageData = await ApiService().getProfileImage(contact.profilePicUrl!);
        if (mounted) {
          setState(() {});
        }
      }
    }
  }

  @override
  void initState() {
    getProfileImageThroughApi(widget.contact);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider(
      create: (context) => ContactTileViewModel(
          context: context, navigationFromSearch: widget.navigationFromSearch),
      child: Consumer<ContactTileViewModel>(builder: (context, model, child) {
        return Container(
          margin: const EdgeInsets.only(left: 20, bottom: 5, top: 15),
          width: width,
          child: InkWell(
            onTap: () async {
              await pushNewScreen(
                context,
                screen: ContactProfile(
                  contact: widget.contact,
                  imageData: imageData,
                ),
                withNavBar: false, // OPTIONAL VALUE. True by default.
                pageTransitionAnimation: PageTransitionAnimation.slideUp,
              );
              if (widget.navigationFromSearch == true) {
                Provider.of<SearchContactsViewModel>(context, listen: false)
                    .clearAndRefetchData();
              } else {
                model.updateList();
              }
            },
            child: (widget.navigationFromSearch == true ||
                    (widget.contact?.friendStatus == 'FRIEND' ||
                        widget.contact?.friendStatus == 'FRIENDS' ||
                        (widget.filter == 'myContacts')))
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                width: width / 1.8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${widget.contact?.firstName ?? ''} ${widget.contact?.lastName ?? ''}",
                                      style: TextStyles.customerNameOnContacts,
                                    ),
                                    Text(
                                      "@${widget.contact?.userName}",
                                      style:
                                          TextStyles.customerUserNameOnContacts,
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (widget.navigationFromSearch == false) ...[
                          Padding(
                            padding: const EdgeInsets.only(right: 10, top: 8),
                            child: InkWell(
                              onTap: () {
                                Provider.of<ContactViewModel>(context,
                                        listen: false)
                                    .showBottomSheet(widget.contact);
                              },
                              child: const Icon(
                                Icons.more_vert_rounded,
                                size: 23,
                                color: Palette.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.only(right: 20),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderStyles.norm2,
                        boxShadow: [
                          BoxShadow(
                              color: Palette.grey,
                              spreadRadius: 1,
                              blurRadius: 0.1)
                        ]),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: SizedBox(
                                    width: width / 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${widget.contact?.firstName ?? ''} ${widget.contact?.lastName ?? ''}",
                                          style:
                                              TextStyles.customerNameOnContacts,
                                        ),
                                        Text(
                                          "@${widget.contact?.userName}",
                                          style: TextStyles
                                              .customerTimeRequestContacts,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (widget.navigationFromSearch == false) ...[
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Provider.of<ContactViewModel>(context,
                                              listen: false)
                                          .showBottomSheet(widget.contact);
                                    },
                                    child: const Icon(
                                      Icons.more_vert_rounded,
                                      size: 23,
                                      color: Palette.primaryColor,
                                    ),
                                  ),
                                  if (widget.contact?.friendStatus ==
                                          'REQUEST_PRESENT' &&
                                      widget.filter == 'contactRequest') ...[
                                    const Text(
                                      "3W",
                                      style: TextStyles
                                          .customerTimeRequestContacts,
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ],
                        ),
                        if ((widget.contact?.friendStatus ==
                                    'REQUEST_PRESENT' &&
                                widget.filter == 'contactRequest') &&
                            widget.navigationFromSearch == false) ...[
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 15.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ButtonOne(
                                    height: 40,
                                    width: (width - 40 - 20 - 25) / 2,
                                    textStyle: TextStyles.buttonOnSmallFont,
                                    isLoading: model.isLoadingAccept,
                                    onTap: () {
                                      model.acceptRequest(widget.contact);
                                    },
                                    title: "Accept"),
                                ButtonOne(
                                    height: 40,
                                    width: (width - 40 - 20 - 25) / 2,
                                    circularProgressColor:
                                        Palette.secondaryColor,
                                    showShadow: false,
                                    textStyle:
                                        TextStyles.buttonOneSmallFontBlue,
                                    isLoading: model.isLoadingReject,
                                    backgroundColor: Palette.grey,
                                    onTap: () {
                                      model.rejectRequest(widget.contact);
                                    },
                                    title: "Decline"),
                              ],
                            ),
                          )
                        ] else if ((widget.contact?.friendStatus ==
                                    'REQUESTED' &&
                                widget.filter == 'sentRequest') &&
                            widget.navigationFromSearch == false) ...[
                          Padding(
                              padding: const EdgeInsets.only(
                                top: 15.0,
                              ),
                              child: ButtonOne(
                                  height: 40,
                                  textStyle: TextStyles.buttonOnSmallFont,
                                  isLoading: model.isLoading,
                                  onTap: () {
                                    model.unsendContact(widget.contact);
                                  },
                                  title: "Cancel Request")),
                        ] else if (((widget.contact?.friendStatus ==
                                        'BLOCKED_BY_PRINCIPAL' ||
                                    widget.contact?.friendStatus ==
                                        'BLOCKED') &&
                                widget.filter == 'blocked') &&
                            widget.navigationFromSearch == false) ...[
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: ButtonOne(
                              isLoading: model.isLoading,
                              textStyle: TextStyles.buttonOnSmallFont,
                              height: 40,
                              onTap: () {
                                model.unBlockAccount(widget.contact);
                              },
                              title: 'Unblock',
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
          ),
        );
      }),
    );
  }
}

class SimpleTextButton extends StatelessWidget {
  const SimpleTextButton({
    super.key,
    this.backgroundColor,
    this.buttonText,
    this.onTap,
    this.paddingVertical,
    this.isLoading = false,
    this.textStyle,
  });

  final VoidCallback? onTap;
  final String? buttonText;
  final Color? backgroundColor;
  final double? paddingVertical;
  final bool isLoading;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: 42, vertical: paddingVertical ?? 8),
          margin: const EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
              color: backgroundColor ?? Palette.grey,
              borderRadius: BorderStyles.norm2),
          child: isLoading == true
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Palette.secondaryColor,
                  ),
                )
              : Text(
                  buttonText ?? "Decline",
                  textAlign: TextAlign.center,
                  style: textStyle ?? TextStyles.chatUiNameSecondaryColor,
                )),
    );
  }
}
