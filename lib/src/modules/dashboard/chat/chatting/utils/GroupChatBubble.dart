import 'package:extended_image/extended_image.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/cupertino.dart';

class GroupChatBubble extends StatefulWidget {
  final String messageType;
  final String messageContent;
  const GroupChatBubble(
      {super.key, required this.messageType, required this.messageContent});

  @override
  State<GroupChatBubble> createState() => _GroupChatBubbleState();
}

class _GroupChatBubbleState extends State<GroupChatBubble> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(left: 7, right: 7, top: 5, bottom: 5),
      child: Align(
        alignment: (widget.messageType == "receiver"
            ? Alignment.topLeft
            : Alignment.topRight),
        child: Row(
          children: [
            // ExtendedImage(image: image),
            Container(
              constraints: BoxConstraints(
                maxWidth: width * 0.8,
              ),
              decoration: BoxDecoration(
                borderRadius: (widget.messageType == "receiver")
                    ? const BorderRadius.only(
                        topRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25))
                    : const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25)),
                color: (widget.messageType == "receiver")
                    ? Palette.primaryColor
                    : Palette.chatBg2,
              ),
              padding: const EdgeInsets.all(12),
              child: Text(widget.messageContent, style: TextStyles.chatTypeMsg),
            ),
          ],
        ),
      ),
    );
  }
}
