import 'package:fifty_one_cash/src/models/StreamChatMessageResponse.dart';
import 'package:intl/intl.dart';

class PersonalChat {
  List<Messages> messages = [];

  PersonalChat.fromJson(Map<String, dynamic> json) {
    json['messages'].forEach((element) {
      messages.add(Messages.fromJson(element));
    });
  }
}

class Messages {
  int? fromUser;
  int? toUser;
  String? message;
  String? messageType;
  String? createdTime;

  Messages.fromJson(Map<String, dynamic> json) {
    fromUser = json['fromuser'];
    toUser = json['touser'];
    message = json['message'];
    messageType = json['messagetype'];
    createdTime = json['createdtime'];
  }
 final time = DateFormat.jm().format(DateTime.parse(DateTime.now().toString()));
  Messages.fromStream(StreamChatMessageResponse streamResponse) {
    
    fromUser = streamResponse.senderuserid;
    toUser = streamResponse.receiveruserid;
    message = streamResponse.message;
    messageType = streamResponse.messagetype;
    createdTime = null;
  }
}
