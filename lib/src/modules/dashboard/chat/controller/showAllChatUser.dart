

import 'dart:convert';

import 'package:fifty_one_cash/src/models/showAllChatUser.dart';
import 'package:fifty_one_cash/src/services/SharedData.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ShowAllChatUserController extends GetxController{

 var isme=false.obs;
 var isLoading = false.obs;
String? token;
 ShowAllChatUser? showAllChatUser;
 
 

  @override
  void onInit() {
    // TODO: implement onInit
    FetchData();
    super.onInit();
  }

   FetchData() async {
token = await SharedData.getToken();
//  print("Qaiser fetch data : ${myId}");
    try {
      isLoading(true);
      var response = await http.get(
          Uri.parse(
            "http://165.232.152.201:8080/api/chat/heads?page=0&size=2",
          ),
          headers: {
            'Authorization': 'Bearer ${token}',
          });
      if (response.statusCode == 200) {
     
        var result = jsonDecode(response.body.toString());
       
      
        showAllChatUser = ShowAllChatUser.fromJson(result);
     

         
      } else {}
    } catch (e) {
      // print(" ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }
  

}