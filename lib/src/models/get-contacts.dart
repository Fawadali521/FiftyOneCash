import 'package:fifty_one_cash/src/models/PersonalChatList.dart';
import 'package:fifty_one_cash/src/models/PersonalChatResponse.dart';
import 'package:fifty_one_cash/src/models/search_user_response.dart';

class GetContacts {
  List<ContactsDetails> blockedContacts = [];
  List<ContactsDetails> generalContacts = [];
  List<ContactsDetails> allContacts = [];

  GetContacts();

  GetContacts.fromJson(Map<String, dynamic> json) {
    json['blockedcontacts'].forEach((element) {
      blockedContacts
          .add(ContactsDetails.fromJson(element, friendStatus: 'BLOCKED'));
    });
    json['generalcontacts'].forEach((element) {
      generalContacts
          .add(ContactsDetails.fromJson(element, friendStatus: 'FRIEND'));
    });

    allContacts.addAll(generalContacts);
    allContacts.addAll(blockedContacts);
  }
}
// personal chat contact
class ContactsDetails {
  String? message;
  int? id;
  String? firstName;
  String? lastName;
  String? userName;
  String? email;
  String? mobileNumber;
  String? gender;
  String? dob;
  String? kyc;
  String? kycId;
  String? profilePicUrl;
  String? friendStatus;

  ContactsDetails();

  ContactsDetails.fromJson(Map<String, dynamic> json,
      {required this.friendStatus}) {
    message = json['message'];
    id = json['id'];
    firstName = json['firstname'];
    lastName = json['lastname'];
    userName = json['username'];
    email = json['email'];
    mobileNumber = json['mobilenumber'];
    gender = json['gender'];
    dob = json['dob'];
    kyc = json['kyc'].toString();
    kycId = json['kycid'].toString();
    profilePicUrl = json['profilepicurl'];
  }

  ContactsDetails.fromSearchedUsers(SearchedUsers? user, {this.friendStatus}) {
    message = user?.message;
    id = user?.id;
    firstName = user?.firstName;
    lastName = user?.lastName;
    userName = user?.userName;
    email = user?.email;
    mobileNumber = user?.mobileNumber;
    gender = user?.gender;
    dob = user?.dob;
    kyc = user?.kyc.toString();
    kycId = user?.kycId.toString();
    profilePicUrl = user?.profilePicUrl;
  }

  ContactsDetails.fromPersonalChat(ChatDetails chatDetails) {
    id = chatDetails.recipentUserId;
    profilePicUrl = chatDetails.profilePic;
    firstName = chatDetails.chatHeadName;
  }
}
