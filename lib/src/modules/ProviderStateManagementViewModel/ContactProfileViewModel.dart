import 'package:fifty_one_cash/src/models/get-contacts.dart';
import 'package:flutter/material.dart';

class ContactProfileViewModel extends ChangeNotifier {
  bool isRemovingAccount = false;
  bool isBlockingAccount = false;

  ContactsDetails? actionableContact;

  BuildContext context;

  ContactProfileViewModel({required this.context, this.actionableContact});
}
