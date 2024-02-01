import 'package:fifty_one_cash/src/models/get-contacts.dart';

class CreateGroupChatResponse {
  int? groupId;
  String? groupName;
  List<ContactsDetails> members = [];
  int? createdBy;

  CreateGroupChatResponse.fromJson(Map<String, dynamic> json) {
    groupId = json['groupid'];
    groupName = json['groupname'];
    json['members'].forEach((element) {
      members.add(ContactsDetails.fromJson(element, friendStatus: 'Friend'));
    });
    createdBy = json['createdby'];
  }
}
