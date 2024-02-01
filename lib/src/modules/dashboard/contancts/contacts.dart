// Created by MHK-MotoVlogs
import 'package:fifty_one_cash/src/modules/ProviderStateManagementViewModel/ContactViewModel.dart';
import 'package:fifty_one_cash/src/modules/dashboard/contancts/Contacts.dart';
import 'package:fifty_one_cash/src/modules/dashboard/contancts/utils/FilterButton.dart';
import 'package:fifty_one_cash/src/modules/dashboard/contancts/utils/ListViewOfContact.dart';
import 'package:fifty_one_cash/src/modules/dashboard/contancts/utils/NoContactImageWithOpacityAnimation.dart';
import 'package:fifty_one_cash/src/modules/dashboard/contancts/utils/SearchContacts.dart';
import 'package:fifty_one_cash/src/widgets/ShimmerTile.dart';
import 'package:fifty_one_cash/src/widgets/UserNameTextField.dart';
import 'package:fifty_one_cash/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    var theme = Theme.of(context);
    return ChangeNotifierProvider(
      create: (context) => ContactViewModel(context),
      child: Consumer<ContactViewModel>(
          builder: (context, model, child) => Scaffold(
                backgroundColor: Colors.white,
                resizeToAvoidBottomInset: true,
                floatingActionButton: InkWell(
                  onTap: () async {
                    if (mounted) {
                      await pushNewScreen(
                        context,
                        screen: const SearchContacts(),
                        withNavBar: false, // OPTIONAL VALUE. True by default.
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      );
                      model.performAction(model.filter);
                    }
                  },
                  child: Container(
                    width: 56,
                    height: 56,
                    padding: const EdgeInsets.all(14),
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Palette.primaryColor,
                            Palette.secondaryColor,
                          ],
                          end: Alignment.centerRight,
                          begin: Alignment.centerLeft,
                        ),
                        borderRadius: BorderStyles.floatingActionButtonRadius),
                    child: Image.asset(
                      "assets/icons/FloatinActionIcon.png",
                      width: 28,
                      height: 28,
                    ),
                  ),
                ),
                body: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle.dark,
                  child: SizedBox(
                    width: width,
                    height: height,
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 15, right: 20),
                          child: SizedBox(
                            width: width,
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      size: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                const Text(
                                  "Contacts",
                                  style: TextStyles.contactScreenTitle,
                                ),
                                const SizedBox(),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width,
                          height: 50,
                          child: ListView(
                            controller: model.scrollController,
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            scrollDirection: Axis.horizontal,
                            children: [
                              FilterButton(
                                isSelected: model.filter == 'myContacts',
                                onTap: () {
                                  model.selectFilter('myContacts');
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: FilterButton(
                                  isSelected: model.filter == 'contactRequest',
                                  onTap: () {
                                    model.selectFilter('contactRequest');
                                  },
                                  icon: Icons.group_add_sharp,
                                  buttonText: 'Contact Requests',
                                  iconBackgroundColor: Colors.blue[300],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: FilterButton(
                                  icon: Icons.send,
                                  isSelected: model.filter == 'sentRequest',
                                  buttonText: 'Sent Requests',
                                  onTap: () {
                                    model.selectFilter('sentRequest');
                                  },
                                  iconBackgroundColor: Colors.pink[200],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: FilterButton(
                                  icon: Icons.person_off,
                                  isSelected: model.filter == 'blocked',
                                  onTap: () {
                                    model.selectFilter('blocked');
                                  },
                                  buttonText: 'Blocked',
                                  iconBackgroundColor: Colors.blue[300],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: width,
                          height: height - 130,
                          child: ListView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, right: 15, top: 10),
                                child: UserNameTextField(
                                  hint: "Search Contacts",
                                  fillColor: Palette.lightGrey3,
                                  hintTextStyle:
                                      TextStyles.contactScreenInputStyle,
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
                                    model.searchContactsLocally();
                                  },
                                ),
                              ),
                              model.isLoading == false
                                  ? (model.blockedContacts.isNotEmpty ||
                                          model.generalContacts.isNotEmpty ||
                                          model.connectionRequestsUsersData
                                              .isNotEmpty ||
                                          model.sentRequests.isNotEmpty ||
                                          model.searchedUsers.isNotEmpty)
                                      ? (model.searchOpen == true &&
                                              model.searchedUsers.isEmpty)
                                          ? NoContactImageWithOpacityAnimation(
                                              height: height,
                                              targetOpacity: 1,
                                              width: width,
                                            )
                                          : ListViewOfContacts(
                                              contacts: model.getList(),
                                              filter: model.filter,
                                              width: width)
                                          
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
                      ],
                    ),
                  ),
                ),
              )),
    );
  }
}