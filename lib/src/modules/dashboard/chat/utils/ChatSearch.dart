import 'dart:io';

import 'package:delayed_display/delayed_display.dart';
import 'package:fifty_one_cash/src/models/get-contacts.dart';
import 'package:fifty_one_cash/src/modules/dashboard/chat/utils/char-qr-scan.dart';
import 'package:fifty_one_cash/src/modules/ProviderStateManagementViewModel/ChatSearchViewModel.dart';
import 'package:fifty_one_cash/src/widgets/test-field-search.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import 'chat-search-tile.dart';

class ChatSearch extends StatefulWidget {
  const ChatSearch({super.key});

  @override
  State<ChatSearch> createState() => _ChatSearchState();
}

class _ChatSearchState extends State<ChatSearch> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ChangeNotifierProvider(
      create: (context) => ChatSearchViewModel(context: context),
      child: Consumer<ChatSearchViewModel>(
        builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarBrightness:
                    Platform.isIOS ? Brightness.dark : Brightness.light),
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
              child: TextFieldSearch(
                hint: "Search People Here",
                onChanged: (x) {
                  model.searchValue = x;
                  model.searchUser();
                },
                onTap: () {
                  pushNewScreen(
                    context,
                    screen: const ChatQrScan(),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.fade,
                  );
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
          body: ListView(shrinkWrap: true, children: [
            Container(
              height: height,
              width: width,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Palette.primaryColor, Palette.secondaryColor],
                  end: Alignment.centerRight,
                  begin: Alignment.centerLeft,
                ),
              ),
              child: model.searchedUsers?.users != null &&
                      model.searchedUsers!.users.isNotEmpty
                  ? ListView.separated(
                      itemCount: model.searchedUsers!.users.length,
                      shrinkWrap: true,
                      controller: model.scrollController,
                      padding: const EdgeInsets.only(top: 10, bottom: 150),
                      separatorBuilder: (context, index) => const Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Opacity(
                          opacity: 0.7,
                          child: Divider(
                            color: Colors.white,
                            height: 1,
                            indent: 20,
                            endIndent: 20,
                          ),
                        ),
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: model.listDelay,
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: ChatSearchTile(
                                // isContact: (index > 3) ? false : true,

                                contact: ContactsDetails.fromSearchedUsers(
                                    model.searchedUsers?.users[index],
                                    friendStatus: model.searchedUsers
                                        ?.users[index].connectionStatus),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Padding(
                      padding: EdgeInsets.only(top: height / 8),
                      child: DelayedDisplay(
                        delay: model.upRowDelay,
                        slidingBeginOffset: const Offset(0.0, -1.0),
                        slidingCurve: Curves.ease,
                        fadeIn: true,
                        child: Column(
                          children: [
                            Container(
                              width: width,
                              height: width / 1.5,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/icons/contact_search.png"),
                                    fit: BoxFit.fill),
                              ),
                            ),
                            const Text(
                              "Search Contacts",
                              textAlign: TextAlign.center,
                              style: TextStyles.emptyContactsStype,
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ]),
        ),
      ),
    );
  }
}
