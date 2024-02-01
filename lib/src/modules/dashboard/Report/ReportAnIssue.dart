import 'package:fifty_one_cash/src/widgets/button-one.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';

class ReportAnIssue extends StatelessWidget {
  const ReportAnIssue({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white, borderRadius: BorderStyles.alertDialogRadius),
      padding: const EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width - 40,
      child: ListView(
        shrinkWrap: true,
        children: [
          UnconstrainedBox(
            child: Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/icons/reportImage.png"),
                      fit: BoxFit.fill)),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              "Please send your report",
              style: TextStyles.alertDialogTitle,
              textAlign: TextAlign.center,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 3.0, left: 5, right: 5),
            child: Text(
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
              style: TextStyles.appBarTabBlack,
              textAlign: TextAlign.center,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: TextField(
              maxLines: 5,
              style: TextStyles.textAreaAlertDialog,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: 'Describe your expectation here',
                hintStyle: TextStyles.textAreaAlertDialog,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xffE7E7E7),
                  ),
                  borderRadius: BorderStyles.alertDialogRadius,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xffE7E7E7),
                  ),
                  borderRadius: BorderStyles.alertDialogRadius,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xffE7E7E7),
                  ),
                  borderRadius: BorderStyles.alertDialogRadius,
                ),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ButtonOne(
                  height: 40,
                  textStyle: TextStyles.buttonOnSmallFont,
                  isLoading: false,
                  onTap: () {},
                  title: "Cancel Request"))
        ],
      ),
    );
  }
}
