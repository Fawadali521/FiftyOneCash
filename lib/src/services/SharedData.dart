import 'package:fifty_one_cash/src/models/OTPResponse.dart';
import 'package:fifty_one_cash/src/models/SignInResponse.dart';
import 'package:fifty_one_cash/src/models/UserUpdateResponse.dart';
import 'package:fifty_one_cash/src/models/forget_password_data_model.dart';
import 'package:fifty_one_cash/src/modules/ProviderStateManagementViewModel/GlobalViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedData {
  Future<void> storeDataInSharedPreferences(OTPResponse otpResponse) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', otpResponse.token);
    await prefs.setString('email', otpResponse.email);
    await prefs.setString('mobileNumber', otpResponse.mobilenumber);
    if (otpResponse.firstname != null) {
      await prefs.setString('firstname', otpResponse.firstname!);
    }
    if (otpResponse.lastname != null) {
      await prefs.setString('lastname', otpResponse.lastname!);
    }
    if (otpResponse.username != null) {
      await prefs.setString('username', otpResponse.username!);
    }
    if (otpResponse.id != null) {
      await prefs.setString('userId', otpResponse.id!.toString());
    }
    if (otpResponse.dob != null) await prefs.setString('dob', otpResponse.dob!);
    if (otpResponse.gender != null) {
      await prefs.setString('gender', otpResponse.gender!);
    }

    if (otpResponse.kyc != null) await prefs.setString('kyc', otpResponse.kyc!);
  }

  Future<void> storeUserDataInSharedPreferences(
      UserUpdateResponse userUpdateResponse) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (userUpdateResponse.email != null) {
      await prefs.setString('email', userUpdateResponse.email!);
    }
    if (userUpdateResponse.mobilenumber != null) {
      await prefs.setString('mobileNumber', userUpdateResponse.mobilenumber!);
    }
    if (userUpdateResponse.firstname != null) {
      await prefs.setString('firstname', userUpdateResponse.firstname!);
    }
    if (userUpdateResponse.lastname != null) {
      await prefs.setString('lastname', userUpdateResponse.lastname!);
    }
    if (userUpdateResponse.username != null) {
      await prefs.setString('username', userUpdateResponse.username!);
    }
    if (userUpdateResponse.dob != null) {
      await prefs.setString('dob', userUpdateResponse.dob!);
    }
    if (userUpdateResponse.gender != null) {
      await prefs.setString('gender', userUpdateResponse.gender!);
    }
    if (userUpdateResponse.kyc != null) {
      await prefs.setString('kyc', userUpdateResponse.kyc!);
    }

    if (userUpdateResponse.masterPinStatus != null) {
      await prefs.setBool(
          'masterPinStatus', userUpdateResponse.masterPinStatus!);
    }

    if (userUpdateResponse.id != null) {
      await prefs.setString('userId', userUpdateResponse.id.toString());
    }
  }

  //Edited by MHK-MotoVlogs

  Future<void> storeDataInSharedPreferencesOfForgetPassword(
      ForgetPasswordResponseData userUpdateResponse) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (userUpdateResponse.email != null) {
      await prefs.setString('email', userUpdateResponse.email!);
    }
    if (userUpdateResponse.token != null) {
      await prefs.setString('token', userUpdateResponse.token!);
    }
    if (userUpdateResponse.mobilenumber != null) {
      await prefs.setString('mobileNumber', userUpdateResponse.mobilenumber!);
    }
    if (userUpdateResponse.firstname != null) {
      await prefs.setString('firstname', userUpdateResponse.firstname!);
    }
    if (userUpdateResponse.lastname != null) {
      await prefs.setString('lastname', userUpdateResponse.lastname!);
    }
    if (userUpdateResponse.username != null) {
      await prefs.setString('username', userUpdateResponse.username!);
    }
    if (userUpdateResponse.dob != null) {
      await prefs.setString('dob', userUpdateResponse.dob!);
    }
    if (userUpdateResponse.gender != null) {
      await prefs.setString('gender', userUpdateResponse.gender!);
    }
    if (userUpdateResponse.kyc != null) {
      await prefs.setString('kyc', userUpdateResponse.kyc!);
    }
    if (userUpdateResponse.kycid != null) {
      await prefs.setString('kycId', userUpdateResponse.kycid!.toString());
    }
    if (userUpdateResponse.id != null) {
      await prefs.setString('userId', userUpdateResponse.id!.toString());
    }
  }

  storeProfilePicUrl(String? url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (url != null) {
      await prefs.setString("profile_picture", url);
      return;
    }
  }

  // end

  Future<void> storeSignInDataInSharedPreferences(
      SignInResponse signInResponse) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (signInResponse.token != null) {
      await prefs.setString('token', signInResponse.token!);
    }
    if (signInResponse.email != null) {
      await prefs.setString('email', signInResponse.email!);
    }
    if (signInResponse.mobilenumber != null) {
      await prefs.setString('mobilenumber', signInResponse.mobilenumber!);
    }
    if (signInResponse.firstname != null) {
      await prefs.setString('firstname', signInResponse.firstname!);
    }
    if (signInResponse.lastname != null) {
      await prefs.setString('lastname', signInResponse.lastname!);
    }
    if (signInResponse.username != null) {
      await prefs.setString('username', signInResponse.username!);
    }
    if (signInResponse.dob != null) {
      await prefs.setString('dob', signInResponse.dob!);
    }
    if (signInResponse.gender != null) {
      await prefs.setString('gender', signInResponse.gender!);
    }
    if (signInResponse.kyc != null) {
      await prefs.setString('kyc', signInResponse.kyc!);
    }
    if (signInResponse.id != null) {
      await prefs.setString('userId', signInResponse.id!.toString());
    }

//edited by mhk-motovlogs

    if (signInResponse.kycId != null) {
      await prefs.setString('kycId', signInResponse.kycId!.toString());
    }
    if (signInResponse.isMasterPinSetted != null) {
      await prefs.setBool('masterPinStatus', signInResponse.isMasterPinSetted!);
    }
  }

  updateKyc(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'kyc', Provider.of<GlobalViewModel>(context, listen: false).kycStatus!);
  }

  storeKycId(int? kycId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (kycId != null) {
      await prefs.setString('kycId', kycId.toString());
    }
  }

  //end

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  static Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  static Future<String?> getPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('mobilenumber');
  }

  static clearAllData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }

  // Edited by MHK-MotoVlogs

  static getFirstName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('firstname');
  }

  static getMasterPinStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('masterPinStatus');
  }

  static setMasterPinStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('masterPinStatus', true);
  }

  static Future<String?> getLastName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('lastname');
  }

  static Future<String?> getDob() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('dob');
  }

  static Future<String?> getProfilePicture() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('profile_picture');
  }

  static Future<String?> getGender() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('gender');
  }

  static Future<String?> getKyc() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('kyc');
  }

  static Future<String?> getKycId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  //end
}
