import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';

class SendContactTile extends StatefulWidget {
  final bool isContact;
  const SendContactTile({super.key, this.isContact = true});

  @override
  State<SendContactTile> createState() => _SendContactTileState();
}

class _SendContactTileState extends State<SendContactTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 15),
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: Palette.sky,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage("assets/image/me.jpg"),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "@s_paradox",
                    style: TextStyles.paraBigBoldWhite,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: Opacity(
                      opacity: 0.7,
                      child: Text(
                        "Shiva Kumar",
                        style: TextStyles.bodyWhite,
                      ),
                    ),
                  ),
                  if (widget.isContact == true)
                    const Padding(
                      padding: EdgeInsets.only(top: 1),
                      child: Opacity(
                        opacity: 0.7,
                        child: Text(
                          "Contacts",
                          style: TextStyles.bodyWhite,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          if (!widget.isContact)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Palette.chatBg2,
              ),
              child: const Padding(
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 3.0, bottom: 4),
                child: Text(
                  "Request",
                  style: TextStyles.bodyWhite,
                ),
              ),
            )
        ],
      ),
    );
  }
}
