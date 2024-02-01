import 'package:fifty_one_cash/src/models/get-contacts.dart';
import 'package:fifty_one_cash/src/modules/ProviderStateManagementViewModel/ContactViewModel.dart';
import 'package:fifty_one_cash/src/modules/ProviderStateManagementViewModel/SearchContactsViewModel.dart';
import 'package:fifty_one_cash/src/services/ApiService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ContactTileViewModel extends ChangeNotifier {
  bool isLoading = false;
  bool addContactRequestSend = false;
  bool unSendRequest = false;
  bool isRequestRejected = false;
  bool isRequestAccepted = false;
  bool? navigationFromSearch;
  bool isLoadingAccept = false;
  bool isLoadingReject = false;

  Uint8List? imageData;

  BuildContext context;

  ContactTileViewModel(
      {required this.context, this.navigationFromSearch = false});

  blockAccount(ContactsDetails? contact) async {
    if (contact != null) {
      isLoading = true;
      if (context.mounted) {
        notifyListeners();
      }
      bool result = await ApiService().blockContact(contact.id);
      if (result) {
        contact.friendStatus = 'BLOCKED';
      }
      isLoading = false;
      if (context.mounted) {
        notifyListeners();
      }
    }
  }

  unBlockAccount(ContactsDetails? contact) async {
    if (contact != null) {
      isLoading = true;
      if (context.mounted) {
        notifyListeners();
      }
      bool result = await ApiService().unBlockContact(contact.id);
      if (result) {
        contact.friendStatus = 'FRIEND';
        if (navigationFromSearch == false) {
          updateList();
        } else {
          Provider.of<SearchContactsViewModel>(context, listen: false)
              .clearAndRefetchData();
        }
      }
      isLoading = false;
      if (context.mounted) {
        notifyListeners();
      }
    }
  }

  removeContact(ContactsDetails? contact) async {
    if (contact != null) {
      isLoading = true;
      if (context.mounted) {
        notifyListeners();
      }
      bool isContactRemoved = await ApiService().removeContact(contact.id);
      if (isContactRemoved) {
        if (navigationFromSearch == false) {
          updateList();
        } else {
          Provider.of<SearchContactsViewModel>(context, listen: false)
              .clearAndRefetchData();
        }
      }
      isLoading = false;
      if (context.mounted) {
        notifyListeners();
      }
    }
  }

  acceptRequest(ContactsDetails? contact) async {
    if (contact != null) {
      isLoadingAccept = true;
      if (context.mounted) {
        notifyListeners();
      }
      isRequestAccepted = await ApiService().acceptContactRequest(contact.id);
      if (isRequestAccepted == true) {
        contact.friendStatus = 'FRIEND';
        if (navigationFromSearch == false) {
          updateList();
        } else {
          Provider.of<SearchContactsViewModel>(context, listen: false)
              .clearAndRefetchData();
        }
      }
      isLoadingAccept = false;
      if (context.mounted) {
        notifyListeners();
      }
    }
  }

  rejectRequest(ContactsDetails? contact) async {
    if (contact != null) {
      isLoadingReject = true;
      if (context.mounted) {
        notifyListeners();
      }
      isRequestRejected = await ApiService().rejectContactRequest(contact.id);
      if (isRequestRejected) {
        if (navigationFromSearch == false) {
          updateList();
        } else {
          Provider.of<SearchContactsViewModel>(context, listen: false)
              .clearAndRefetchData();
        }
      }
      isLoadingReject = false;
      if (context.mounted) {
        notifyListeners();
      }
    }
  }

  addContact(ContactsDetails? contact) async {
    if (contact != null) {
      isLoading = true;
      if (context.mounted) {
        notifyListeners();
      }
      addContactRequestSend = await ApiService().addContact(contact.id);
      if (addContactRequestSend) {
        if (navigationFromSearch == false) {
          updateList();
        } else {
          Provider.of<SearchContactsViewModel>(context, listen: false)
              .clearAndRefetchData();
        }
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
      unSendRequest = await ApiService().unSendRequest(contact.id);
      if (unSendRequest == true) {
        if (navigationFromSearch == false) {
          updateList();
        } else {
          Provider.of<SearchContactsViewModel>(context, listen: false)
              .clearAndRefetchData();
        }
      }
      isLoading = false;
      if (context.mounted) {
        notifyListeners();
      }
    }
  }

  updateList() {
    Provider.of<ContactViewModel>(context, listen: false).updateList();
  }
}
