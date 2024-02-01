import 'package:fifty_one_cash/src/models/get-contacts.dart';
import 'package:fifty_one_cash/src/modules/ProviderStateManagementViewModel/ChatSearchViewModel.dart';
import 'package:fifty_one_cash/src/services/ApiService.dart';
import 'package:fifty_one_cash/src/widgets/text_buttons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatSearchTileViewModel extends ChangeNotifier {
  bool isLoading = false;
  bool addContactRequestSend = false;

  ContactsDetails contact;

  BuildContext context;

  ChatSearchTileViewModel({required this.context, required this.contact});

  getText(ContactsDetails? contact) {
    switch (contact?.friendStatus) {
      case 'REQUEST_PRESENT':
        return 'Add Contact';
      case 'REQUESTED':
        return 'UnSend';
      case 'FRIENDS' || 'FRIEND':
        return 'Friend';
      case 'NO_CONTACT_RELATION':
        return 'Send Request';
      case 'BLOCKED_BY_PRINCIPAL':
        return 'Blocked';
      case 'BLOCKED_BY_SEARCHED_USER':
        return 'wait';
      case 'BLOCKED':
        return 'Blocked';
      default:
        return 'wait';
    }
  }

  blockAccount() async {
    isLoading = true;
    if (context.mounted) {
      notifyListeners();
    }
    bool isBlocakAccount = await ApiService().blockContact(contact.id);
    if (isBlocakAccount) {
      clearAndRefetchData();
    }
    isLoading = false;
    if (context.mounted) {
      notifyListeners();
    }
  }

  unBlockAccount() async {
    isLoading = true;
    if (context.mounted) {
      notifyListeners();
    }
    bool isUnBlockAccount = await ApiService().unBlockContact(contact.id);
    if (isUnBlockAccount) {
      clearAndRefetchData();
    }
    isLoading = false;
    if (context.mounted) {
      notifyListeners();
    }
  }

  removeContact() async {
    isLoading = true;
    if (context.mounted) {
      notifyListeners();
    }
    bool isRemoveContact = await ApiService().removeContact(contact.id);

    if (isRemoveContact) {
      clearAndRefetchData();
    }

    isLoading = false;
    if (context.mounted) {
      notifyListeners();
    }
  }

  addContact() async {
    isLoading = true;
    if (context.mounted) {
      notifyListeners();
    }
    addContactRequestSend = await ApiService().addContact(contact.id);
    if (addContactRequestSend) {
      clearAndRefetchData();
    }
    isLoading = false;
    if (context.mounted) {
      notifyListeners();
    }
  }

  rejectRequest(ContactsDetails? contact) async {
    if (contact != null) {
      isLoading = true;
      if (context.mounted) {
        notifyListeners();
      }
      bool isRequestRejected =
          await ApiService().rejectContactRequest(contact.id);
      if (isRequestRejected) {
        clearAndRefetchData();
      }
      isLoading = false;
      if (context.mounted) {
        notifyListeners();
      }
    }
  }

  acceptRequest(ContactsDetails? contact) async {
    if (contact != null) {
      isLoading = true;
      if (context.mounted) {
        notifyListeners();
      }
      bool isRequestAccepted =
          await ApiService().acceptContactRequest(contact.id);
      if (isRequestAccepted == true) {
        clearAndRefetchData();
      }
      isLoading = false;
      if (context.mounted) {
        notifyListeners();
      }
    }
  }

  unsendContact(ContactsDetails? contact) async {
    if (contact != null) {
      isLoading = true;
      if (context.mounted) {
        notifyListeners();
      }
      bool unSendRequest = await ApiService().unSendRequest(contact.id);
      if (unSendRequest) {
        clearAndRefetchData();
      }
      isLoading = false;
      if (context.mounted) {
        notifyListeners();
      }
    }
  }

  getIconWidget(ContactsDetails? contact) {
    switch (contact?.friendStatus) {
      case 'REQUESTED':
        return [
          TextButtons(
            isChatSearch: true,
            title: 'UnSend',
            onTap: () {
              unsendContact(contact);
            },
          ),
        ];
      case 'REQUEST_PRESENT':
        return [
          Column(
            children: [
              TextButtons(
                isChatSearch: true,
                title: 'Accept',
                onTap: () {
                  acceptRequest(contact);
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: TextButtons(
                  isChatSearch: true,
                  title: "Reject",
                  onTap: () {
                    rejectRequest(contact);
                  },
                ),
              )
            ],
          ),
        ];
      case 'FRIENDS' || 'FRIEND':
        return null;
      case 'NO_CONTACT_RELATION':
        return [
          TextButtons(
            title: "Send Request",
            isChatSearch: true,
            onTap: () {
              addContact();
            },
          )
        ];
      case 'BLOCKED_BY_PRINCIPAL':
        return null;
      case 'BLOCKED_BY_SEARCHED_USER':
        return null;
    }
  }

  clearAndRefetchData() {
    Provider.of<ChatSearchViewModel>(context, listen: false).clearAndFetch();
  }
}
