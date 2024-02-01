import 'package:fifty_one_cash/src/models/get-contacts.dart';
import 'package:fifty_one_cash/src/services/ApiService.dart';
import 'package:flutter/material.dart';

class BottomSheetViewModel extends ChangeNotifier {
  bool isBlockingAccount = false;
  bool isRemovingAccount = false;
  bool isLoading = false;
  BuildContext context;
  BottomSheetViewModel({required this.context});
  Future<bool> blockAccount(ContactsDetails? actionableContact) async {
    if (actionableContact != null) {
      isBlockingAccount = true;
      isLoading = true;
      if (context.mounted) {
        notifyListeners();
      }
      bool result = await ApiService().blockContact(actionableContact.id);
      if (result) {
        return true;
      }
      isLoading = false;
      isBlockingAccount = false;
      if (context.mounted) {
        notifyListeners();
      }
      return false;
    }
    return false;
  }

  Future<bool> removeContact(ContactsDetails? contactsDetails) async {
    if (contactsDetails != null) {
      isRemovingAccount = true;
      isLoading = true;
      if (context.mounted) {
        notifyListeners();
      }
      bool isContactRemoved =
          await ApiService().removeContact(contactsDetails.id);
      if (isContactRemoved) {
        return true;
      }
      isLoading = true;
      isRemovingAccount = false;
      if (context.mounted) {
        notifyListeners();
      }
      return false;
    }
    return false;
  }
}
