// Created by MHK-MotoVlogs

import 'package:fifty_one_cash/src/models/get-contacts.dart';
import 'package:fifty_one_cash/src/modules/dashboard/contancts/Contacts.dart';
import 'package:fifty_one_cash/src/modules/ProviderStateManagementViewModel/SearchContactsViewModel.dart';
import 'package:fifty_one_cash/src/modules/dashboard/contancts/utils/ContactsTile.dart';
import 'package:fifty_one_cash/src/modules/dashboard/contancts/utils/NoContactImageWithOpacityAnimation.dart';
import 'package:fifty_one_cash/src/widgets/ShimmerTile.dart';
import 'package:fifty_one_cash/src/widgets/UserNameTextField.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class SearchContacts extends StatefulWidget {
  const SearchContacts({super.key});

  @override
  State<SearchContacts> createState() => _SearchContactsState();
}

class _SearchContactsState extends State<SearchContacts> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return ChangeNotifierProvider(
      create: (context) => SearchContactsViewModel(context: context),
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarBrightness: Brightness.dark),
            title: const Text(
              "Search Users",
              style: TextStyles.contactScreenTitle,
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 15,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.dark,
            child: Consumer<SearchContactsViewModel>(
              builder: (context, model, child) => ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    child: SizedBox(
                      width: width / 1.1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UserNameTextField(
                            hint: "Search Contacts",
                            fillColor: Palette.lightGrey3,
                            hintTextStyle: TextStyles.contactScreenInputStyle,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.asset(
                                  height: 24,
                                  width: 24,
                                  'assets/icons/search.png'),
                            ),
                            controller: model.searchController,
                            onEditingComplete: () {
                              FocusScope.of(context).unfocus();
                            },
                            onChanged: (x) {
                              model.searchValue = x;
                              model.searchUser();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  model.isLoading == false
                      ? ((model.searchedUsers != null &&
                                  model.searchedUsers!.users.isNotEmpty) &&
                              (model.searchValue != null &&
                                  (model.searchValue!.trim().isNotEmpty ||
                                      model.searchValue != '')))
                          ? AnimationLimiter(
                              child: ListView.builder(
                                shrinkWrap: true,
                                controller: ScrollController(),
                                addAutomaticKeepAlives: false,
                                itemCount: model.searchedUsers?.users.length,
                                itemBuilder: (context, index) =>
                                    AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 1000),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: ContactsTile(
                                        navigationFromSearch: true,
                                        filter: 'null',
                                        contact:
                                            ContactsDetails.fromSearchedUsers(
                                                model.searchedUsers
                                                    ?.users[index],
                                                friendStatus: model
                                                    .searchedUsers
                                                    ?.users[index]
                                                    .connectionStatus),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : NoContactImageWithOpacityAnimation(
                              height: height,
                              targetOpacity: 1,
                              width: width,
                            )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: 7,
                          itemBuilder: (context, index) =>
                              ShimmerTile(width: width),
                        )
                ],
              ),
            ),
          )),
    );
  }
}
