// To parse this JSON data, do
//
//     final showAllChatUser = showAllChatUserFromJson(jsonString);

import 'dart:convert';

ShowAllChatUser showAllChatUserFromJson(String str) => ShowAllChatUser.fromJson(json.decode(str));

String showAllChatUserToJson(ShowAllChatUser data) => json.encode(data.toJson());

class ShowAllChatUser {
    List<Chathead> chatheads;

    ShowAllChatUser({
        required this.chatheads,
    });

    factory ShowAllChatUser.fromJson(Map<String, dynamic> json) => ShowAllChatUser(
        chatheads: List<Chathead>.from(json["chatheads"].map((x) => Chathead.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "chatheads": List<dynamic>.from(chatheads.map((x) => x.toJson())),
    };
}

class Chathead {
    String chatid;
    String chatType;
    String chatheadname;
    int oponentuserid;
    int senderUserId;
    int recipientUserId;
    dynamic groupid;
    dynamic profilepic;
    String lastmessage;
    DateTime lastmessagetime;

    Chathead({
        required this.chatid,
        required this.chatType,
        required this.chatheadname,
        required this.oponentuserid,
        required this.senderUserId,
        required this.recipientUserId,
        required this.groupid,
        required this.profilepic,
        required this.lastmessage,
        required this.lastmessagetime,
    });

    factory Chathead.fromJson(Map<String, dynamic> json) => Chathead(
        chatid: json["chatid"],
        chatType: json["chatType"],
        chatheadname: json["chatheadname"],
        oponentuserid: json["oponentuserid"],
        senderUserId: json["senderUserId"],
        recipientUserId: json["recipientUserId"],
        groupid: json["groupid"],
        profilepic: json["profilepic"],
        lastmessage: json["lastmessage"],
        lastmessagetime: DateTime.parse(json["lastmessagetime"]),
    );

    Map<String, dynamic> toJson() => {
        "chatid": chatid,
        "chatType": chatType,
        "chatheadname": chatheadname,
        "oponentuserid": oponentuserid,
        "senderUserId": senderUserId,
        "recipientUserId": recipientUserId,
        "groupid": groupid,
        "profilepic": profilepic,
        "lastmessage": lastmessage,
        "lastmessagetime": lastmessagetime.toIso8601String(),
    };
}
