import 'package:fifty_one_cash/src/modules/dashboard/payment/search-contact-tile.dart';
import 'package:fifty_one_cash/src/widgets/text-field-history.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class SendToContact extends StatefulWidget {
  const SendToContact({super.key});

  @override
  State<SendToContact> createState() => _SendToContactState();
}

class _SendToContactState extends State<SendToContact> {
  Duration listDelay = const Duration(milliseconds: 350);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 10),
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.1),
              radius: 10,
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: TextFieldHistory(
            hint: "Enter Ph Number Or User Id",
            onChanged: (x) {},
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Palette.primaryColor, Palette.secondaryColor],
              end: Alignment.centerRight,
              begin: Alignment.centerLeft,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Palette.primaryColor, Palette.secondaryColor],
            end: Alignment.centerRight,
            begin: Alignment.centerLeft,
          ),
        ),
        // child: ListView(
        //     padding: const EdgeInsets.only(top: 10, bottom: 100),
        //     children: List.generate(
        //       20,
        //       (index) => SendContactTile(isContact: (index > 3) ? false : true),
        //     )),
        child: ListView.builder(
          itemCount: 20,
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 10, bottom: 100),
          itemBuilder: (BuildContext context, int index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: listDelay,
              child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                      child: SendContactTile(
                          isContact: (index > 3) ? false : true))),
            );
          },
        ),
      ),
    );
  }
}
