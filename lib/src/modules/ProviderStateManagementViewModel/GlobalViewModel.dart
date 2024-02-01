//created by MHK-MotoVlogs

import 'package:fifty_one_cash/src/models/get_kyc_details_model.dart';
import 'package:fifty_one_cash/src/services/ApiService.dart';
import 'package:fifty_one_cash/src/services/SharedData.dart';
import 'package:flutter/material.dart';

class GlobalViewModel extends ChangeNotifier {
  String? kycStatus;
  String? userName;

  GlobalViewModel() {
    getKycStatusFromSharedPrefrences();
    getKycDetailsFromApi();
    getUserIdFromlocal();
  }

  getUserIdFromlocal() async {
    userName = await SharedData.getUserName();
  }

  getKycDetailsFromApi() async {
    GetKycDetailsModel? kycDetails = await ApiService().getKycDetails();
    if (kycDetails?.kycStatus != null) {
      kycStatus = kycDetails?.kycStatus;
      notifyListeners();
    }
  }

  getKycStatusFromSharedPrefrences() async {
    kycStatus = await SharedData.getKyc();
    notifyListeners();
  }

  updateStatus() {
    kycStatus = 'PENDING';
    notifyListeners();
  }

  updateLocalStorageKycStatus(BuildContext context) {
    SharedData().updateKyc(context);
  }
}
