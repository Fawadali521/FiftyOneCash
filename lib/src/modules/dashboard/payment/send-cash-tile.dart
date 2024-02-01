import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SendCashTile extends StatefulWidget {
  final String image;
  final String name;
  final String time;
  final bool isSend;
  final String amount;
  const SendCashTile(
      {super.key,
      this.image = "assets/image/me.jpg",
      this.name = "Shivay Kumar",
      this.time = "11:54 AM",
      this.isSend = true,
      this.amount = "453.45"
          ""});

  @override
  State<SendCashTile> createState() => _SendCashTileState();
}

class _SendCashTileState extends State<SendCashTile> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 27,
            backgroundColor: Palette.primaryColor.withOpacity(0.2),
            child: Center(
              child: CircleAvatar(
                radius: 26,
                backgroundColor: Colors.white,
                child: Center(
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Palette.primaryColor,
                    backgroundImage: AssetImage(widget.image),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: SizedBox(
              width: width - 60 - 54,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: width - 60 - 54 - 100,
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    widget.name,
                                    style: TextStyles.chatName,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Opacity(
                            opacity: 0.5,
                            child: Text(
                              widget.time,
                              style: TextStyles.chatTime,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: width - 60 - 54 - 30,
                              child: Row(
                                children: [
                                  Flexible(
                                      child: RichText(
                                    overflow: TextOverflow.visible,
                                    text: TextSpan(
                                      children: [
                                        const WidgetSpan(
                                            child: Padding(
                                          padding:
                                              EdgeInsets.only(top: 2, right: 2),
                                          child: Icon(
                                            CupertinoIcons.arrow_turn_left_up,
                                            color: Colors.black,
                                            size: 15,
                                          ),
                                        )),
                                        TextSpan(
                                          text:
                                              '\$${widget.amount} - ${widget.isSend ? "Received Instantly" : "Sent Securely"}',
                                          style: TextStyles.chatMsg,
                                        ),
                                      ],
                                    ),
                                  )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: -15,
                    child: Container(
                      width: width - 60 - 54,
                      height: 1,
                      decoration:
                          BoxDecoration(color: Colors.black.withOpacity(0.05)),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
