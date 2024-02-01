import 'package:fifty_one_cash/src/models/search_user_response.dart';
import 'package:fifty_one_cash/src/services/ApiService.dart';
import 'package:flutter/material.dart';

class ChatSearchViewModel extends ChangeNotifier {
  bool isLoading = false;

  SearchUserResponse? searchedUsers;

  String? searchValue;

  Duration listDelay = const Duration(milliseconds: 350);
  Duration upRowDelay = const Duration(milliseconds: 500);

  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();

  BuildContext context;

  ChatSearchViewModel({required this.context});

  searchUser() async {
    bool searchedByFirstName = false;
    if (searchValue != null &&
        (searchValue!.trim().isNotEmpty || searchValue!.trim() != '')) {
      isLoading = true;
      notifyListeners();
      if (searchValue![0] != '@') {
        searchedByFirstName = true;
      }
      searchedUsers = await ApiService()
          .searchUser(searchValue!.trim(), context, searchedByFirstName);
      isLoading = false;
    } else {
      clearSearchData();
    }
    notifyListeners();
  }

  clearSearchData() {
    searchedUsers = null;
    searchValue = '';
    searchController.clear();
    notifyListeners();
  }

  clearAndFetch() {
    searchedUsers = null;
    searchUser();
  }
}
