import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatefulWidget {
  final String messageType;
  final String messageContent;
  final String time;
  const ChatBubble(
      {super.key, required this.messageType, required this.messageContent,required this.time});

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
   
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
  //     var timeStamp24HR = widget.time;
  // var  timeFormate=DateFormat.jm().format(DateTime.parse(timeStamp24HR));
    return Padding(
      padding: const EdgeInsets.only(left: 7, right: 7, top: 5, bottom: 5),
      child: Align(
        alignment: (widget.messageType == "receiver"
            ? Alignment.topLeft
            : Alignment.topRight),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: width * 0.8,
          ),
          decoration: BoxDecoration(
            borderRadius: (widget.messageType == "receiver")
                ? const BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15))
                : const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15)),
            color: (widget.messageType == "receiver")
                ? Palette.primaryColor
                : Palette.chatBg2,
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.messageContent, style: TextStyles.chatTypeMsg),
             
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     // Text(DateFormat('h:mm a')
            //     //                         .format(DateTime.parse(widget
            //     //                             .time))
            //     //                         .toString(), style:TextStyles.chatTypeMsgTime),
            //   ],
            // ),
            ],
          ),
        ),
      ),
    );
  }
}
