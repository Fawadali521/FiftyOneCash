import 'package:intl/intl.dart';

class StreamChatMessageResponse {
  String? messagestatus;
  String? message;
  String? messagetype;
  String? chattype;
  String? receivermobilenumber;
  int? receiveruserid;
  String? sendermobilenumber;
  int? senderuserid;
  // String? time;

  StreamChatMessageResponse.fromJson(Map<String, dynamic> json) {
    messagestatus = json['messagestatus'];
    message = json['message'];
    messagetype = json['messagetype'];
    chattype = json['chattype'];
    receivermobilenumber = json['receivermobilenumber'];
    receiveruserid = json['receiveruserid'];
    sendermobilenumber = json['sendermobilenumber'];
    senderuserid = json['senderuserid'];
    // time = json['createdtime'];
  }
}
