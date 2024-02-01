import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';

class NotificationTile extends StatefulWidget {
  const NotificationTile({super.key});

  @override
  State<NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: 110,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 27,
              backgroundColor: Palette.primaryColor.withOpacity(0.2),
              child: const Center(
                child: CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.white,
                  child: Center(
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Palette.primaryColor,
                      backgroundImage: AssetImage("assets/image/me.jpg"),
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
                              child: const Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Notification Heading",
                                      style: TextStyles.chatName,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Opacity(
                              opacity: 0.5,
                              child: Text(
                                "11:54 AM",
                                style: TextStyles.chatTime,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: width - 60 - 54 - 30,
                                height: 50,
                                child: Row(
                                  children: [
                                    Flexible(
                                        child: RichText(
                                      overflow: TextOverflow.visible,
                                      text: const TextSpan(
                                        children: [
                                          // WidgetSpan(
                                          //     child: Padding(
                                          //   padding: const EdgeInsets.only(
                                          //       top: 2, right: 2),
                                          //   child: Image.asset(
                                          //     "assets/icons/double-check.png",
                                          //     width: 18,
                                          //     fit: BoxFit.contain,
                                          //   ),
                                          // )),
                                          TextSpan(
                                            text:
                                                'In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document',
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
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.05)),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
