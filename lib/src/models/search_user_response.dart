//created by mhk-motovlogs
import 'package:fifty_one_cash/src/modules/ProviderStateManagementViewModel/GlobalViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchUserResponse {
  List<SearchedUsers> users = [];

  SearchUserResponse.fromJson(Map<String, dynamic> json, BuildContext context) {
    json['users'].forEach((element) {
      if (element['username'] !=
          Provider.of<GlobalViewModel>(context, listen: false).userName) {
        users.add(SearchedUsers.fromJson(element));
      }
    });
  }
}

class SearchedUsers {
  int? id;
  int? kycId;

  String? message;
  String? firstName;
  String? lastName;
  String? userName;
  String? email;
  String? mobileNumber;
  String? gender;
  String? dob;
  String? kyc;
  String? profilePicUrl;
  String? connectionStatus;

  SearchedUsers();

  SearchedUsers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    kycId = json['kycid'];
    message = json['message'];
    firstName = json['firstname'];
    lastName = json['lastname'];
    userName = json['username'];
    email = json['email'];
    mobileNumber = json['mobilenumber'];
    gender = json['gender'];
    dob = json['dob'];
    kyc = json['kyc'];
    profilePicUrl = json['profilepicurl'];
    connectionStatus = json['connectionstatus'];
  }
}
