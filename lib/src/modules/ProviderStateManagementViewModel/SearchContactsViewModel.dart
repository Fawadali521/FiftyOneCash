import 'package:fifty_one_cash/src/models/search_user_response.dart';
import 'package:fifty_one_cash/src/services/ApiService.dart';
import 'package:flutter/material.dart';

class SearchContactsViewModel extends ChangeNotifier {
  bool isLoading = false;

  TextEditingController searchController = TextEditingController();

  SearchUserResponse? searchedUsers;

  String? searchValue;

  Duration upRowDelay = const Duration(milliseconds: 500);

  BuildContext context;

  SearchContactsViewModel({required this.context});

  searchUser() async {
    isLoading = true;
    if (context.mounted) {
      notifyListeners();
    }
    bool searchedByFirstName = false;
    if (searchValue != null &&
        (searchValue!.trim().isNotEmpty || searchValue!.trim() != '')) {
      isLoading = true;

      if (searchValue![0] != '@') {
        searchedByFirstName = true;
      }
      searchedUsers = await ApiService()
          .searchUser(searchValue!.trim(), context, searchedByFirstName);
      isLoading = false;
    } else {
      clearSearchData();
    }
    isLoading = false;
    if (context.mounted) {
      notifyListeners();
    }
  }

  clearAndRefetchData() {
    searchedUsers = null;
    searchUser();
  }

  clearSearchData() {
    searchedUsers = null;
    searchValue = '';
    searchController.clear();
    notifyListeners();
  }
}
