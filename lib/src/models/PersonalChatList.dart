class PersonalChatList {
  List<ChatDetails> chatDetails = [];
  PersonalChatList.fromJson(Map<String, dynamic> json) {
    json['chatheads']
        .forEach((element) => chatDetails.add(ChatDetails.fromJson(element)));
        
  }
}

class ChatDetails {
  String? chatId;
  String? chatType;
  String? chatHeadName;
  int? senderUserId;
  int? recipentUserId;
  int? groupId;
  String? profilePic;
  String? lastMessage;
  String? lastMessageTime;

  ChatDetails.fromJson(Map<String, dynamic> json) {
    chatId = json['chatid'];
    chatType = json['chatType'];
    chatHeadName = json['chatheadname'];
    senderUserId = json['senderUserId'];
    recipentUserId = json['recipientUserId'];
    groupId = json['groupid'];
    profilePic = json['profilepic'];
    lastMessage = json['lastmessage'];
    lastMessageTime = json['lastmessagetime'];
  }
}
