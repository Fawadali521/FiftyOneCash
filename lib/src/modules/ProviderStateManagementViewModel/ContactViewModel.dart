import 'package:fifty_one_cash/src/models/get-contacts.dart';
import 'package:fifty_one_cash/src/models/search_user_response.dart';
import 'package:fifty_one_cash/src/modules/dashboard/Report/ReportAnIssue.dart';
import 'package:fifty_one_cash/src/modules/dashboard/chat/chatting/chat-ui.dart';
import 'package:fifty_one_cash/src/modules/ProviderStateManagementViewModel/BottomSheetViewModel.dart';
import 'package:fifty_one_cash/src/modules/dashboard/contancts/Contacts.dart';
import 'package:fifty_one_cash/src/modules/dashboard/contancts/utils/BottomSheet.dart';
import 'package:fifty_one_cash/src/services/ApiService.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class ContactViewModel extends ChangeNotifier {
  bool searchOpen = false;
  bool isLoading = false;
  bool isShowBottomSheet = false;
  bool isRemoveAccountLoading = false;
  bool isBlockAccountLoading = false;

  ContactsDetails? actionableContact;

  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();

  List<ContactsDetails> connectionRequestsUsersData = [];
  List<ContactsDetails> searchedUsers = [];
  List<ContactsDetails> blockedContacts = [];
  List<ContactsDetails> generalContacts = [];
  List<ContactsDetails> sentRequests = [];
  List<ContactsDetails> allContacts = [];

  SearchUserResponse? connectionRequestsUsers;
  SearchUserResponse? sendedRequests;

  String? searchValue;
  String filter = 'myContacts';

  GetContacts? contacts;

  Duration upRowDelay = const Duration(milliseconds: 500);

  BuildContext context;

  ContactViewModel(this.context) {
    getContacts(false);
  }

  showBottomSheet(ContactsDetails? contactsDetails) {
    isShowBottomSheet = !isShowBottomSheet;
    if (contactsDetails != null) {
      actionableContact = contactsDetails;
      displaySheet();
    }
    if (context.mounted) {
      notifyListeners();
    }
  }

  performAction(String filterName) {
    switch (filterName) {
      case 'myContacts':
        clearAllData();
        getContacts(false);
        break;
      case 'blocked':
        clearAllData();
        getContacts(true);
        break;
      case 'sentRequest':
        clearAllData();
        getSentRequests();
        break;
      case 'contactRequest':
        clearAllData();
        getConnectionRequests();
        break;
    }
  }

  searchContactsLocally() async {
    searchedUsers = [];
    if (searchValue != null &&
        (searchValue!.trim().isNotEmpty || searchValue!.trim() != '')) {
      searchOpen = true;
      if (context.mounted) {
        notifyListeners();
      }
      addFilteredDataToSearchedList();
    } else {
      searchOpen = false;
      if (context.mounted) {
        notifyListeners();
      }
    }

    notifyListeners();
  }

  selectFilter(String filterName) async {
    await performAction(filterName);
    filter = filterName;
    if (context.mounted) {
      notifyListeners();
    }
  }

  getLength() {
    switch (filter) {
      case 'myContacts':
        if (searchedUsers.isNotEmpty) {
          return searchedUsers.length;
        } else {
          return generalContacts.length;
        }

      case 'contactRequest':
        if (searchedUsers.isNotEmpty) {
          return searchedUsers.length;
        } else {
          return connectionRequestsUsersData.length;
        }
      case 'blocked':
        if (searchedUsers.isNotEmpty) {
          return searchedUsers.length;
        } else {
          return blockedContacts.length;
        }

      case 'sentRequest':
        if (searchedUsers.isNotEmpty) {
          return searchedUsers.length;
        } else {
          return sentRequests.length;
        }
    }
  }

  getList() {
    switch (filter) {
      case 'myContacts':
        if (searchedUsers.isNotEmpty) {
          return searchedUsers;
        } else {
          return generalContacts;
        }

      case 'contactRequest':
        if (searchedUsers.isNotEmpty) {
          return searchedUsers;
        } else {
          return connectionRequestsUsersData;
        }
      case 'blocked':
        if (searchedUsers.isNotEmpty) {
          return searchedUsers;
        } else {
          return blockedContacts;
        }

      case 'sentRequest':
        if (searchedUsers.isNotEmpty) {
          return searchedUsers;
        } else {
          return sentRequests;
        }
    }
  }

  addFilteredDataToSearchedList() {
    switch (filter) {
      case 'myContacts':
        if (searchValue![0] == '@') {
          generalContacts.forEach((element) {
            if (element.userName!
                .toLowerCase()
                .contains(searchValue!.substring(1).toLowerCase())) {
              searchedUsers.add(element);
            }
          });
        } else {
          generalContacts.forEach((element) {
            if (element.firstName != null &&
                element.firstName!
                    .toLowerCase()
                    .contains(searchValue!.toLowerCase())) {
              searchedUsers.add(element);
            }
          });
        }
        break;
      case 'blocked':
        if (searchValue![0] == '@') {
          blockedContacts.forEach((element) {
            if (element.userName!
                .toLowerCase()
                .contains(searchValue!.substring(1).toLowerCase())) {
              searchedUsers.add(element);
            }
          });
        } else {
          blockedContacts.forEach((element) {
            if (element.firstName != null &&
                element.firstName!
                    .toLowerCase()
                    .contains(searchValue!.toLowerCase())) {
              searchedUsers.add(element);
            }
          });
        }
        break;
      case 'sentRequest':
        if (searchValue![0] == '@') {
          sentRequests.forEach((element) {
            if (element.userName!
                .toLowerCase()
                .contains(searchValue!.substring(1).toLowerCase())) {
              searchedUsers.add(element);
            }
          });
        } else {
          sentRequests.forEach((element) {
            if (element.firstName != null &&
                element.firstName!
                    .toLowerCase()
                    .contains(searchValue!.toLowerCase())) {
              searchedUsers.add(element);
            }
          });
        }
        break;
      case 'contactRequest':
        if (searchValue![0] == '@') {
          connectionRequestsUsersData.forEach((element) {
            if (element.userName!
                .toLowerCase()
                .contains(searchValue!.substring(1).toLowerCase())) {
              searchedUsers.add(element);
            }
          });
        } else {
          connectionRequestsUsersData.forEach((element) {
            if (element.firstName != null &&
                element.firstName!
                    .toLowerCase()
                    .contains(searchValue!.toLowerCase())) {
              searchedUsers.add(element);
            }
          });
        }
        break;
    }
  }

  clearAllData() {
    allContacts = [];
    blockedContacts = [];
    generalContacts = [];
    sentRequests = [];
    connectionRequestsUsersData = [];
    searchedUsers = [];
    searchOpen = false;
    searchValue = '';
    searchController.clear();
    notifyListeners();
  }

  getConnectionRequests() async {
    connectionRequestsUsers = null;
    connectionRequestsUsersData = [];
    isLoading = true;
    notifyListeners();
    connectionRequestsUsers = await ApiService().getConnectionRequests(context);

    if (connectionRequestsUsers != null) {
      connectionRequestsUsers!.users.forEach((element) {
        ContactsDetails? contactsDetails = connectionRequestsUsersData
            .firstWhere((elements) => elements.id == element.id,
                orElse: () => ContactsDetails());

        if (contactsDetails.id == null) {
          connectionRequestsUsersData.add(ContactsDetails.fromSearchedUsers(
              element,
              friendStatus: 'REQUEST_PRESENT'));
        }
      });
    }
    isLoading = false;
    notifyListeners();
  }

  getSentRequests() async {
    sentRequests = [];
    sendedRequests = null;
    isLoading = true;
    notifyListeners();
    sendedRequests = await ApiService().getSentRequest(context);
    if (sendedRequests != null) {
      sendedRequests!.users.forEach((element) {
        ContactsDetails? contactsDetails = sentRequests.firstWhere(
            (elements) => elements.id == element.id,
            orElse: () => ContactsDetails());
        if (contactsDetails.id == null) {
          sentRequests.add(ContactsDetails.fromSearchedUsers(element,
              friendStatus: 'REQUESTED'));
        }
      });
    }
    isLoading = false;
    notifyListeners();
  }

  getContacts(bool? fetchingOnlyBlock) async {
    allContacts = [];
    blockedContacts = [];
    generalContacts = [];
    contacts = null;
    isLoading = true;
    if (context.mounted) {
      notifyListeners();
    }
    contacts = await ApiService().getContacts();
    if (contacts != null) {
      if (fetchingOnlyBlock == true) {
        blockedContacts = contacts!.blockedContacts;
      } else {
        allContacts = contacts!.allContacts;
        generalContacts = contacts!.generalContacts;
      }
    }
    isLoading = false;
    if (context.mounted) {
      notifyListeners();
    }
  }

  updateList() {
    performAction(filter);
  }

  displaySheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      useSafeArea: true,
      context: context,
      builder: (context) => ChangeNotifierProvider(
        create: (context) => BottomSheetViewModel(context: context),
        child: Consumer<BottomSheetViewModel>(
          builder: (context, model, child) => Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0)),
              color: Colors.white,
            ),
            child: ListView(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 30,
              ),
              shrinkWrap: true,
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 120),
                  width: 80,
                  height: 7,
                  decoration: BoxDecoration(
                    color: Palette.grey2.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                if (filter == 'myContacts' &&
                    (actionableContact?.friendStatus == 'FRIEND' ||
                        actionableContact?.friendStatus == 'FRIENDS')) ...[
                  BottomSheetButtons(
                    width: MediaQuery.of(context).size.width,
                    onTap: () {
                      if (actionableContact != null) {
                        if (context.mounted) {
                          pushNewScreen(
                            context,
                            screen: ChatUi(
                              receiverDetails: actionableContact!,
                            ),
                            withNavBar:
                                false, // OPTIONAL VALUE. True by default.
                            pageTransitionAnimation:
                                PageTransitionAnimation.slideUp,
                          );
                        }
                      }
                    },
                    isLoading: false,
                  ),
                ],
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: BottomSheetButtons(
                    width: MediaQuery.of(context).size.width,
                    isLoading: false,
                    buttonText: 'Send Money',
                    icon: Icons.attach_money,
                  ),
                ),
                if (filter == 'myContacts' &&
                    (actionableContact?.friendStatus == 'FRIEND' ||
                        actionableContact?.friendStatus == 'FRIENDS')) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: BottomSheetButtons(
                        width: MediaQuery.of(context).size.width,
                        isLoading: false,
                        buttonText: 'Request Money',
                        icon: Icons.money),
                  ),
                ],
                if ((filter == 'myContacts' || filter == 'block') &&
                    (actionableContact?.friendStatus == 'FRIEND' ||
                        actionableContact?.friendStatus == 'FRIENDS')) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: model.isBlockingAccount == true
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Palette.secondaryColor,
                            ),
                          )
                        : BottomSheetButtons(
                            width: MediaQuery.of(context).size.width,
                            onTap: () async {
                              bool result =
                                  await model.blockAccount(actionableContact);
                              if (result) {
                                updateList();
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              }
                            },
                            isLoading: false,
                            buttonText: 'Block Contact',
                            icon: Icons.person_off),
                  ),
                ],
                if (filter == 'myContacts' &&
                    (actionableContact?.friendStatus == 'FRIEND' ||
                        actionableContact?.friendStatus == 'FRIENDS')) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: model.isRemovingAccount == true
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Palette.secondaryColor,
                            ),
                          )
                        : BottomSheetButtons(
                            onTap: () async {
                              bool result =
                                  await model.removeContact(actionableContact);
                              if (result) {
                                updateList();
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              }
                            },
                            width: MediaQuery.of(context).size.width,
                            isLoading: false,
                            buttonText: 'Remove Contact',
                            icon: Icons.delete_sweep_outlined),
                  ),
                ],
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                  ),
                  child: BottomSheetButtons(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => const AlertDialog(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 0),
                                insetPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                content: ReportAnIssue(),
                              ));
                    },
                    width: MediaQuery.of(context).size.width,
                    buttonText: 'Report',
                    isLoading: false,
                    icon: Icons.info,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
