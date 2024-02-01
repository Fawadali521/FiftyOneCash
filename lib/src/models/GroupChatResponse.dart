import 'package:fifty_one_cash/src/models/StreamChatMessageResponse.dart';

class GroupChatResponse {
  List<GroupChatMessage> messages = [];

  GroupChatResponse.fromJson(Map<String, dynamic> json) {
    json['messages'].forEach((element) {
      messages.add(GroupChatMessage.fromJson(element));
    });
  }
}

class GroupChatMessage {
  int? fromUser;
  int? toUser;
  String? message;
  String? messageType;
  String? createdTime;

  GroupChatMessage.fromJson(Map<String, dynamic> json) {
    fromUser = json['fromuser'];
    toUser = json['touser'];
    message = json['message'];
    messageType = json['messagetype'];
    createdTime = json['createdtime'];
  }

  GroupChatMessage.fromStream(StreamChatMessageResponse streamResponse) {
    fromUser = streamResponse.senderuserid;
    toUser = streamResponse.receiveruserid;
    message = streamResponse.message;
    messageType = streamResponse.messagetype;
    createdTime = null;
  }
}
