import 'dart:convert';
import 'dart:io';

import 'package:fifty_one_cash/constants.dart';
import 'package:fifty_one_cash/src/models/CreateGroupChatResponse.dart';
import 'package:fifty_one_cash/src/models/OTPResponse.dart';
import 'package:fifty_one_cash/src/models/PersonalChatList.dart';
import 'package:fifty_one_cash/src/models/PersonalChatResponse.dart';
import 'package:fifty_one_cash/src/models/SignInResponse.dart';
import 'package:fifty_one_cash/src/models/UserUpdateResponse.dart';
import 'package:fifty_one_cash/src/models/forget_password_data_model.dart';
import 'package:fifty_one_cash/src/models/get-contacts.dart';
import 'package:fifty_one_cash/src/models/get_kyc_details_model.dart';
import 'package:fifty_one_cash/src/models/kyc_response_model.dart';
import 'package:fifty_one_cash/src/models/search_user_response.dart';
import 'package:fifty_one_cash/src/models/update_profile_response.dart';
import 'package:fifty_one_cash/src/services/SharedData.dart';
import 'package:fifty_one_cash/src/services/toast-msg.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class ApiService {
//edited by mhk-motovlogs
  static const String root = "http://165.232.152.201:8080";
//end
  Map<String, String> buildHeader() {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
    };
  }

  Map<String, String> buildAuthHeader(token) {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

// Edited by MHK-MotoVlogs
  Map<String, String> buildFileTypeAuthHeader(token) {
    return {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $token',
    };
  }

  //end

  Future<bool?> userSignUp({
    required String email,
    required String mobileNumber,
    required String password,
    required String countryCode,
  }) async {
    // Build request body

    final body = {
      'email': email,
      'mobilenumber': mobileNumber,
      'password': password,
      'countrycode': countryCode,
    };

    try {
      final response = await http.post(
        Uri.parse(Consts.signup),
        headers: buildHeader(),
        body: jsonEncode(body),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['message'].toString() == "otp sent") {
          return true;
        } else {
          ToastMsg().sendErrorMsg("OTP issue detected.");
          return false;
        }
      } else {
        var responseBody = jsonDecode(response.body);
        if (responseBody['message'] != null) {
          throw Exception(responseBody['message']);
        } else {
          throw Exception("Failed to send otp. Error: ${response.body}");
        }
      }
    } catch (error) {
      ToastMsg().sendErrorMsg("Error: $error");
      throw Exception("Error: $error");
    }
  }

  Future<bool?> verifyMobileOtp({
    required String mobileNumber,
    required String otp,
    bool? isVerificationForMasterPin,
  }) async {
    final body = {
      'mobilenumber': mobileNumber,
      'otp': otp,
    };

    try {
      final response = await http.post(
        Uri.parse(Consts.verifyOtp),
        headers: buildHeader(),
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        OTPResponse otpResponse = OTPResponse.fromJson(responseBody);
        if (otpResponse.message == "otp verified") {
          if (isVerificationForMasterPin != true) {
            await SharedData().storeDataInSharedPreferences(otpResponse);
          }
          return true;
        } else {
          ToastMsg().sendErrorMsg(otpResponse.message);
          return false;
        }
      } else {
        ToastMsg().sendErrorMsg(response.body);
        throw Exception("Failed to verify OTP. Error: ${response.body}");
      }
    } catch (error) {
      ToastMsg().sendErrorMsg(error.toString());
      return null;
    }
  }

  Future<bool?> resendMobileOtp({
    required String mobileNumber,
    required String countryCode,
  }) async {
    final body = {
      'mobilenumber': mobileNumber,
      'countrycode': countryCode,
    };

    try {
      final response = await http.post(
        Uri.parse(Consts.resendOtp),
        headers: buildHeader(),
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['message'].toString() == "otp sent") {
          return true;
        } else {
          return false;
        }
      } else {
        var errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['message']);
      }
    } catch (error) {
      ToastMsg().sendErrorMsg("Error: $error");
      return null;
    }
  }

// Edited by MHK-MotoVlogs

  Future<bool?> sendMobileOtp({
    required String mobileNumber,
  }) async {
    final body = {
      'mobilenumber': mobileNumber,
    };

    try {
      final response = await http.post(
        Uri.parse(Consts.resendOtp),
        headers: buildHeader(),
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);

        if (responseBody['message'].toString() == "otp sent") {
          ToastMsg().sendSuccessMsg(responseBody['message']);
          return true;
        } else {
          return false;
        }
      } else {
        var errorResponse = jsonDecode(response.body);
        ToastMsg().sendErrorMsg("Error: $errorResponse");
        throw Exception(errorResponse['message']);
      }
    } catch (error) {
      ToastMsg().sendErrorMsg("Error: $error");
      return null;
    }
  }

  //end

  Future<bool?> checkUserNameAvailability(String username) async {
    try {
      final response = await http.get(
        Uri.parse(Consts.checkUserName + username),
      );

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['message'].toString() == "user not exists") {
          return true;
        } else if (responseBody['message'].toString() == "user exists") {
          return false;
        }
      } else {
        var errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['message']);
      }
    } catch (error) {
      ToastMsg().sendErrorMsg("Error: $error");
      return null;
    }
    return null;
  }

  Future<bool> updateUser({
    String? firstname,
    String? lastname,
    String? username,
    String? gender,
    String? dob,
  }) async {
    try {
      String? token = await SharedData.getToken();

      if (token == null) {
        throw Exception("Token is missing.");
      }

      final body = jsonEncode({
        if (firstname != null) 'firstname': firstname,
        if (lastname != null) 'lastname': lastname,
        if (username != null) 'username': username,
        if (gender != null) 'gender': gender,
        if (dob != null) 'dob': dob,
      });

      final response = await http.patch(
        Uri.parse(Consts.updateUser),
        headers: buildAuthHeader(token),
        body: body,
      );
      final responseData = jsonDecode(response.body);

      if (responseData['message'] == 'updated successfully') {
        UserUpdateResponse userUpdateResponse =
            UserUpdateResponse.fromJson(jsonDecode(response.body));

        SharedData().storeUserDataInSharedPreferences(userUpdateResponse);
        return true;
      } else {
        var errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['message']);
      }
    } catch (error) {
      ToastMsg().sendErrorMsg("Error: $error");
      return false;
    }
  }

  // Future<String>
  signIn({
    required String mobilenumber,
    required String password,
  }) async {
    try {
      final body = jsonEncode({
        'mobilenumber': mobilenumber,
        'password': password,
      });
      final response = await http.post(
        Uri.parse(Consts.signIn),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: body,
      );
      if (response.statusCode == 200) {
        SignInResponse signInResponse =
            SignInResponse.fromJson(jsonDecode(response.body));
        await SharedData().storeSignInDataInSharedPreferences(signInResponse);
        if (signInResponse.token != null &&
            (signInResponse.username == null ||
                signInResponse.username!.trim().isEmpty)) {
          return "UPDATE_REQUIRED";
        } else if ((signInResponse.token != null &&
                signInResponse.username != null &&
                signInResponse.username!.trim().isNotEmpty) &&
            (signInResponse.isMasterPinSetted == null ||
                signInResponse.isMasterPinSetted == false)) {
          return "SETUPMASTERPIN";
        } else if ((signInResponse.token != null &&
                signInResponse.username != null &&
                signInResponse.username!.trim().isNotEmpty) &&
            signInResponse.isMasterPinSetted == true) {
          return "DASHBOARD";
        } else {
          throw Exception("Unexpected response");
        }
      } else {
        var errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['message']);
      }
    } catch (error) {
      ToastMsg().sendErrorMsg("Error: $error");
      return error.toString();
    }
  }

// Edited by MHK-MotoVlogs

  Future<bool?> chagnePassword(
      {required String mobileNumber,
      required String otp,
      required String newPassword}) async {
    final body = {
      'mobilenumber': mobileNumber,
      "newpassword": newPassword,
      "otp": otp
    };

    try {
      final response = await http.post(
        Uri.parse(Consts.changePassword),
        headers: buildHeader(),
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['message'].toString() == "password updated") {
          ToastMsg().sendSuccessMsg(responseBody['message']);
          SharedData().storeDataInSharedPreferencesOfForgetPassword(
              ForgetPasswordResponseData.fromJson(responseBody));
          return true;
        } else {
          return false;
        }
      } else {
        var errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['message']);
      }
    } catch (error) {
      ToastMsg().sendErrorMsg("Error: $error");
      return null;
    }
  }

  Future<bool> updateProfileImage({File? image}) async {
    try {
      String? token = await SharedData.getToken();
      if (token == null) {
        throw Exception("Token is missing.");
      }

      var request =
          http.MultipartRequest('PATCH', Uri.parse(Consts.updateUserProfile));
      request.headers['Content-Type'] = 'multipart/form-data';
      var authToken = token;
      request.headers['Authorization'] = 'Bearer $authToken';

      var file = await http.MultipartFile.fromPath(
          'profile_picture', image!.path,
          contentType: MediaType('image', image.path.split('.').last),
          filename: "profile_picture");
      request.files.add(file);

      var response = await request.send();
      var buffer = StringBuffer();
      await for (var chunk in response.stream) {
        buffer.write(utf8.decode(chunk));
      }
      String responseBody = buffer.toString();
      var data = jsonDecode(responseBody);
      UpdateProfileResponse updateProfileResponse =
          UpdateProfileResponse.fromJson(data);
      if (response.statusCode != 200) {
        ToastMsg().sendErrorMsg(responseBody);
        return false;
      } else {
        SharedData().storeProfilePicUrl(updateProfileResponse.profilepicurl);
        return true;
      }
    } catch (error) {
      ToastMsg().sendErrorMsg("Error: $error");
      return false;
    }
  }

  Future<bool> doKyc({
    XFile? selfiePic,
    XFile? kycFontPic,
    XFile? kycBackImage,
    String? name,
    String? address,
    int? tnx,
    String? nationality,
    String? gender,
    String? dob,
  }) async {
    try {
      String? token = await SharedData.getToken();
      if (token == null) {
        throw Exception("Token is missing.");
      }

      var request = http.MultipartRequest("POST", Uri.parse(Consts.doKyc));
      request.headers['Content-Type'] = 'multipart/form-data';
      request.headers['Authorization'] = 'Bearer $token';

      var selfiePicMultiPartFile = await http.MultipartFile.fromPath(
          "selfie_picture", selfiePic!.path,
          contentType: MediaType('image', 'jpeg'), filename: "selfie_picture");
      var kycFrontPicMultiPartFile = await http.MultipartFile.fromPath(
          "kyc_front_photo_id", kycFontPic!.path,
          contentType: MediaType(
            'image',
            kycFontPic.path.split('.').last,
          ),
          filename: "kyc_front_picture");
      if (kycBackImage != null) {
        var kycBackPicMultiPartFile = await http.MultipartFile.fromPath(
          "kyc_back_photo_id",
          kycBackImage!.path,
          filename: 'kyc_back_picture',
          contentType: MediaType('image', kycBackImage.path.split('.').last),
        );
        request.files.add(kycBackPicMultiPartFile);
      }

      request.files.add(selfiePicMultiPartFile);
      request.files.add(kycFrontPicMultiPartFile);

      request.fields['name'] = name!;
      request.fields['address'] = address!;
      request.fields['tnx'] = tnx.toString();
      request.fields['nationality'] = nationality!;
      request.fields['dob'] = dob!;
      request.fields['gender'] = gender!;

      var response = await request.send();
      var buffer = StringBuffer();
      await for (var chunk in response.stream) {
        buffer.write(utf8.decode(chunk));
      }
      String responseBody = buffer.toString();
      var data = jsonDecode(responseBody);
      KYCResponse kycReponse = KYCResponse.fromJson(data);

      if (response.statusCode == 200) {
        SharedData().storeKycId(kycReponse.id);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      ToastMsg().sendErrorMsg(e.toString());
      return false;
    }
  }

  getProfileImage(String imageUrl) async {
    try {
      String? token = await SharedData.getToken();
      if (token == null) {
        throw Exception("Token is missing.");
      }

      final response = await http.get(
        Uri.parse(imageUrl),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token}',
        },
      );

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        // Handle error
        print('Failed to fetch image: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or other errors
      print('Error: $e');
    }
  }

  getKycDetails() async {
    try {
      String? token = await SharedData.getToken();
      String? kycId = await SharedData.getKycId();
      if (token == null) {
        // throw Exception("Token is missing.");
        throw Exception("");
      }
      if (kycId != null) {
        final response = await http.get(
          Uri.parse("${Consts.getKyc}$kycId"),
          headers: buildAuthHeader(token),
        );
        if (response.statusCode == 200) {
          var responseBody = jsonDecode(response.body);
          return GetKycDetailsModel.fromJson(responseBody);
        } else {
          ToastMsg()
              .sendErrorMsg("Some thing went wrong while fetching KYC details");
          return;
        }
      }
      return;
    } catch (e) {
      // Handle network or other errors
      print('Error: $e');
    }
  }

  getContacts() async {
    try {
      String? token = await SharedData.getToken();
      if (token == null) {
        throw Exception("Token is missing.");
      }
      final response = await http.get(
        Uri.parse(Consts.getContacts),
        headers: buildAuthHeader(token),
      );

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        return GetContacts.fromJson(responseBody);
      } else {
        ToastMsg()
            .sendErrorMsg("Some thing went wrong while fetching KYC details");
        return;
      }
    } catch (e) {
      // Handle network or other errors
      print('Error: $e');
    }
  }

  blockContact(int? contactUserId) async {
    print("block contact id si: $contactUserId");
    if (contactUserId != null) {
      try {
        String? token = await SharedData.getToken();
        if (token == null) {
          throw Exception("Token is missing.");
        }
        final response = await http.post(Uri.parse(Consts.blockContact),
            headers: buildAuthHeader(token),
            body: jsonEncode({
              'contactuserid': contactUserId,
            }));

        var responseBody = jsonDecode(response.body);
        if (response.statusCode == 200) {
          ToastMsg().sendSuccessMsg(responseBody['message']);
          return true;
        } else {
          ToastMsg().sendErrorMsg(responseBody['message']);
          return false;
        }
      } catch (e) {
        // Handle network or other errors
        print('Error: $e');
        return false;
      }
    } else {
      ToastMsg().sendErrorMsg("Contact don't have identity number");
      return false;
    }
  }

  unBlockContact(int? contactUserId) async {
    if (contactUserId != null) {
      try {
        String? token = await SharedData.getToken();
        if (token == null) {
          throw Exception("Token is missing.");
        }
        final response = await http.post(Uri.parse(Consts.unBlockContact),
            headers: buildAuthHeader(token),
            body: jsonEncode({
              'contactuserid': contactUserId,
            }));

        var responseBody = jsonDecode(response.body);
        if (response.statusCode == 200) {
          ToastMsg().sendSuccessMsg(responseBody['message']);
          return true;
        } else {
          ToastMsg().sendErrorMsg(responseBody['message']);
          return false;
        }
      } catch (e) {
        // Handle network or other errors
        print('Error: $e');
        return false;
      }
    } else {
      ToastMsg().sendErrorMsg("Contact don't have identity number");
      return false;
    }
  }

  removeContact(int? contactUserId) async {
    if (contactUserId != null) {
      try {
        String? token = await SharedData.getToken();
        if (token == null) {
          throw Exception("Token is missing.");
        }
        final response = await http.delete(
          Uri.parse(Consts.removeContact),
          headers: buildAuthHeader(token),
          body: jsonEncode({
            'contactuserid': contactUserId,
          }),
        );

        print("removed data response is: ${response.body}");

        var responseBody = jsonDecode(response.body);
        if (response.statusCode == 200) {
          ToastMsg().sendSuccessMsg(responseBody['message']);
          return true;
        } else {
          ToastMsg().sendErrorMsg(responseBody['message']);
          return false;
        }
      } catch (e) {
        // Handle network or other errors
        print('Error: $e');
        return false;
      }
    } else {
      ToastMsg().sendErrorMsg("Contact don't have identity number");
      return false;
    }
  }

  addContact(int? contactUserId) async {
    if (contactUserId != null) {
      try {
        String? token = await SharedData.getToken();
        if (token == null) {
          throw Exception("Token is missing.");
        }
        final response = await http.post(Uri.parse(Consts.addContact),
            headers: buildAuthHeader(token),
            body: jsonEncode({
              'contactuserid': contactUserId,
            }));

        var responseBody = jsonDecode(response.body);
        if (response.statusCode == 200) {
          ToastMsg().sendSuccessMsg(responseBody['message']);
          return true;
        } else {
          ToastMsg().sendErrorMsg(responseBody['message']);
          return false;
        }
      } catch (e) {
        // Handle network or other errors
        print('Error: $e');
        return false;
      }
    } else {
      ToastMsg().sendErrorMsg("Contact don't have identity number");
      return false;
    }
  }

  unSendRequest(int? contactUserId) async {
    if (contactUserId != null) {
      try {
        String? token = await SharedData.getToken();
        if (token == null) {
          throw Exception("Token is missing.");
        }
        final response = await http.post(Uri.parse(Consts.unSendRequest),
            headers: buildAuthHeader(token),
            body: jsonEncode({
              'contactuserid': contactUserId,
            }));

        var responseBody = jsonDecode(response.body);
        if (response.statusCode == 200) {
          ToastMsg().sendSuccessMsg(responseBody['message']);
          return true;
        } else {
          ToastMsg().sendErrorMsg(responseBody['message']);
          return false;
        }
      } catch (e) {
        // Handle network or other errors
        print('Error: $e');
        return false;
      }
    } else {
      ToastMsg().sendErrorMsg("Contact don't have identity number");
      return false;
    }
  }

  Future<bool> acceptContactRequest(int? contactUserId) async {
    if (contactUserId != null) {
      try {
        String? token = await SharedData.getToken();
        if (token == null) {
          throw Exception("Token is missing.");
        }
        final response = await http.post(Uri.parse(Consts.acceptRequest),
            headers: buildAuthHeader(token),
            body: jsonEncode({
              'contactuserid': contactUserId,
            }));

        var responseBody = jsonDecode(response.body);
        if (response.statusCode == 200) {
          ToastMsg().sendSuccessMsg(responseBody['message']);
          return true;
        } else {
          ToastMsg().sendErrorMsg(responseBody['message']);
          return false;
        }
      } catch (e) {
        // Handle network or other errors
        print('Error: $e');
        return false;
      }
    } else {
      ToastMsg().sendErrorMsg("Contact don't have identity number");
      return false;
    }
  }

  rejectContactRequest(int? contactUserId) async {
    if (contactUserId != null) {
      try {
        String? token = await SharedData.getToken();
        if (token == null) {
          throw Exception("Token is missing.");
        }
        final response = await http.post(Uri.parse(Consts.rejectRequest),
            headers: buildAuthHeader(token),
            body: jsonEncode({
              'contactuserid': contactUserId,
            }));

        var responseBody = jsonDecode(response.body);
        if (response.statusCode == 200) {
          ToastMsg().sendSuccessMsg(responseBody['message']);
          return true;
        } else {
          ToastMsg().sendErrorMsg(responseBody['message']);
          return false;
        }
      } catch (e) {
        // Handle network or other errors
        print('Error: $e');
        return false;
      }
    } else {
      ToastMsg().sendErrorMsg("Contact don't have identity number");
      return false;
    }
  }

  Future<SearchUserResponse?> searchUser(
      String userName, BuildContext context, bool searchByFirstName) async {
    try {
      String? token = await SharedData.getToken();
      if (token == null) {
        throw Exception("Token is missing.");
      }
      Response searchResponse;
      if (searchByFirstName == true) {
        searchResponse = await http.get(
          Uri.parse(
              "$root/api/user/contacts/search?page=0&size=20&sort=name,DESC&name=$userName&username="),
          headers: buildAuthHeader(token),
        );
      } else {
        searchResponse = await http.get(
          Uri.parse(
              "$root/api/user/contacts/search?page=0&size=20&sort=name,DESC&name=&username=${userName.substring(1)}"),
          headers: buildAuthHeader(token),
        );
      }

      var responseBody = jsonDecode(searchResponse.body);
      SearchUserResponse searchedResponse =
          SearchUserResponse.fromJson(responseBody, context);

      if (searchResponse.statusCode == 200) {
        return searchedResponse;
      } else {
        ToastMsg().sendErrorMsg("User contact not found");
        return null;
      }
    } catch (e) {
      // Handle network or other errors
      print('Error: $e');
      return null;
    }
  }

  Future<SearchUserResponse?> getConnectionRequests(
      BuildContext context) async {
    try {
      String? token = await SharedData.getToken();
      if (token == null) {
        throw Exception("Token is missing.");
      }
      print(token);
      final response = await http.get(
        Uri.parse(Consts.connectionRequests),
        headers: buildAuthHeader(token),
      );
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        print("response is $responseBody");
        return SearchUserResponse.fromJson(responseBody, context);
      } else {
        ToastMsg().sendErrorMsg("Some thing went wrong");
        return null;
      }
    } catch (e) {
      // Handle network or other errors
      print('Error: $e');
      return null;
    }
  }

  Future<SearchUserResponse?> getSentRequest(BuildContext context) async {
    try {
      String? token = await SharedData.getToken();
      if (token == null) {
        throw Exception("Token is missing.");
      }
      final response = await http.get(
        Uri.parse(Consts.sentRequests),
        headers: buildAuthHeader(token),
      );
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        return SearchUserResponse.fromJson(responseBody, context);
      } else {
        ToastMsg().sendErrorMsg("Some thing went wrong.");
        return null;
      }
    } catch (e) {
      // Handle network or other errors
      print('Error: $e');
      return null;
    }
  }

  Future<bool> saveMasterPin(String? masterPin) async {
    if (masterPin != null) {
      try {
        String? token = await SharedData.getToken();
        if (token == null) {
          throw Exception("Token is missing.");
        }
        final response = await http.post(Uri.parse(Consts.saveMasterPin),
            headers: buildAuthHeader(token),
            body: jsonEncode({
              'masterpin': masterPin,
            }));

        var responseBody = jsonDecode(response.body);
        if (response.statusCode == 200) {
          ToastMsg().sendSuccessMsg(responseBody['message']);
          await SharedData.setMasterPinStatus();
          return true;
        } else {
          ToastMsg().sendErrorMsg(responseBody['message']);
          return false;
        }
      } catch (e) {
        print('Error: $e');
        return false;
      }
    } else {
      ToastMsg().sendErrorMsg("Contact don't have identity number");
      return false;
    }
  }

  Future<bool> verifyMasterPin(String? masterPin) async {
    if (masterPin != null) {
      try {
        String? token = await SharedData.getToken();
        if (token == null) {
          throw Exception("Token is missing.");
        }
        final response = await http.post(Uri.parse(Consts.verifyMasterPin),
            headers: buildAuthHeader(token),
            body: jsonEncode({
              'masterpin': masterPin,
            }));
        var responseBody = jsonDecode(response.body);
        if (responseBody['message'] == 'correct master pin') {
          ToastMsg().sendSuccessMsg(responseBody['message']);
          return true;
        } else {
          ToastMsg().sendErrorMsg(responseBody['message']);
          return false;
        }
      } catch (e) {
        // Handle network or other errors
        print('Error: $e');
        return false;
      }
    } else {
      ToastMsg().sendErrorMsg("Contact don't have identity number");
      return false;
    }
  }

  Future<bool> updateMasterPin(String? masterPin, String? otp) async {
    if (masterPin != null && otp != null) {
      try {
        String? token = await SharedData.getToken();
        if (token == null) {
          throw Exception("Token is missing.");
        }
        final response = await http.patch(Uri.parse(Consts.saveMasterPin),
            headers: buildAuthHeader(token),
            body: jsonEncode({
              'masterpin': masterPin,
              'otp': otp,
            }));
        var responseBody = jsonDecode(response.body);
        if (responseBody['message'] == 'master pin updated') {
          ToastMsg().sendSuccessMsg(responseBody['message']);
          return true;
        } else {
          ToastMsg().sendErrorMsg(responseBody['message']);
          return false;
        }
      } catch (e) {
        // Handle network or other errors
        ToastMsg().sendErrorMsg(e.toString());
        return false;
      }
    } else {
      ToastMsg().sendErrorMsg("Look Like There is Otp Missing or new Pin");
      return false;
    }
  }

  Future<PersonalChat?> getPersonalChat(
      ContactsDetails receiverDetails, int page) async {
        print('Qaiser : ${receiverDetails.id}');
    try {
      String? token = await SharedData.getToken();
      if (token == null) {
        throw Exception("Token is missing.");
      }

      // http://165.232.152.201:8080/api/chat/personal?page=2&size=10&to_user=29
      final response = await http.get(
        Uri.parse(
            "$root/api/chat/personal?page=$page&size=10&to_user=${receiverDetails.id}"),
        headers: buildAuthHeader(token),
      );
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        return PersonalChat.fromJson(responseBody);
      } else {
        // ToastMsg().sendErrorMsg("Some thing went wrong.");
        return null;
      }
    } catch (e) {
      // Handle network or other errors
      print('Error: $e');
      return null;
    }
  }

  Future<PersonalChat?> getGroupChat(int groupId, int page) async {
    try {
      String? token = await SharedData.getToken();
      if (token == null) {
        throw Exception("Token is missing.");
      }
      final response = await http.get(
        Uri.parse("$root/api/chat/group?page=$page&size=10&to_group=$groupId"),
        headers: buildAuthHeader(token),
      );
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        return PersonalChat.fromJson(responseBody);
      } else {
        ToastMsg().sendErrorMsg("Some thing went wrong.");
        return null;
      }
    } catch (e) {
      // Handle network or other errors
      print('Error: $e');
      return null;
    }
  }

  Future<PersonalChatList?> getListOfPersonalChat(int page) async {
    try {
      String? token = await SharedData.getToken();
      if (token == null) {
        throw Exception("Token is missing.");
      }
      final response = await http.get(
        Uri.parse("$root/api/chat/heads?page=$page&size=10"),
        headers: buildAuthHeader(token),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseBody = jsonDecode(response.body);
        return PersonalChatList.fromJson(responseBody);
      } else {
        ToastMsg().sendErrorMsg("Some thing went wrong.");
        return null;
      }
    } catch (e) {
      // Handle network or other errors
      print('Error: $e');
      return null;
    }
  }

  Future<CreateGroupChatResponse?> createChatGroup(String? groupName) async {
    if (groupName != null) {
      try {
        String? token = await SharedData.getToken();
        if (token == null) {
          throw Exception("Token is missing.");
        }
        final Map<String, dynamic> queryParameters = {'group_name': groupName};
        final response = await http.post(
          Uri.parse(Consts.createChatGroup)
              .replace(queryParameters: queryParameters),
          headers: buildAuthHeader(token),
        );
        var responseBody = jsonDecode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          ToastMsg().sendSuccessMsg("Group created successfuly");

          return CreateGroupChatResponse.fromJson(responseBody);
        } else {
          ToastMsg().sendErrorMsg("Some thing went wrong.");
          return null;
        }
      } catch (e) {
        // Handle network or other errors
        print('Error: $e');
        return null;
      }
    } else {
      ToastMsg().sendErrorMsg("You didn't enter group name");
      return null;
    }
  }

  Future<bool> uploadChatGroupImage(XFile file, int groupId) async {
    try {
      String? token = await SharedData.getToken();
      if (token == null) {
        throw Exception("Token is missing.");
      }
      var request = http.MultipartRequest(
          "PATCH", Uri.parse(Consts.uploadChatGroupImage));
      request.headers['Content-Type'] = 'multipart/form-data';
      request.headers['Authorization'] = 'Bearer $token';

      var chatImage = await http.MultipartFile.fromPath(
          "group_picture", file.path,
          contentType: MediaType('image', 'jpeg'), filename: "chatImage");
      request.files.add(chatImage);
      request.fields['group_id'] = groupId.toString();
      var response = await request.send();
      var buffer = StringBuffer();
      await for (var chunk in response.stream) {
        buffer.write(utf8.decode(chunk));
      }
      String responseBody = buffer.toString();
      var data = jsonDecode(responseBody);
      if (data['groupid'] != null) {
        ToastMsg().sendSuccessMsg(data['message']);
        return true;
      } else {
        ToastMsg().sendErrorMsg(data['message']);
        return false;
      }
    } catch (e) {
      // Handle network or other errors
      ToastMsg().sendErrorMsg(e.toString());
      return false;
    }
  }

  Future<bool> addMemberToChatGroup(int? userId, int? groupId) async {
    if (userId != null && groupId != null) {
      try {
        String? token = await SharedData.getToken();
        if (token == null) {
          throw Exception("Token is missing.");
        }
        final response = await http.post(
          Uri.parse(
              '$root/api/group/add-member?group_id=$groupId&user_id=$userId'),
          headers: buildAuthHeader(token),
        );
        var responseBody = jsonDecode(response.body);
        print("response of create chat group is: ${responseBody.toString()}");
        if (responseBody['message'] == 'member added') {
          ToastMsg().sendSuccessMsg(responseBody['message']);
          return true;
        } else {
          ToastMsg().sendErrorMsg("Some thing went wrong.");
          return false;
        }
      } catch (e) {
        // Handle network or other errors
        print('Error: $e');
        return false;
      }
    } else {
      ToastMsg().sendErrorMsg("Some thing went wrong.");
      return false;
    }
  }

  Future<bool> removeMemberFromGroupChat(int? userId, int? groupId) async {
    if (userId != null && groupId != null) {
      try {
        String? token = await SharedData.getToken();
        if (token == null) {
          throw Exception("Token is missing.");
        }
        final Map<String, dynamic> queryParameters = {
          'group_id': groupId,
          'user_id': userId
        };
        final response = await http.post(
          Uri.parse(
              '$root/api/group/remove-member?group_id=$groupId&user_id=$userId'),
          headers: buildAuthHeader(token),
        );
        var responseBody = jsonDecode(response.body);
        print("response of create chat group is: ${responseBody.toString()}");
        if (responseBody['message'] == 'member removed') {
          ToastMsg().sendSuccessMsg(responseBody['message']);
          return true;
        } else {
          ToastMsg().sendErrorMsg("Some thing went wrong.");
          return false;
        }
      } catch (e) {
        // Handle network or other errors
        print('Error: $e');
        return false;
      }
    } else {
      ToastMsg().sendErrorMsg("Some thing went wrong");
      return false;
    }
  }

  Future<CreateGroupChatResponse?> getChatGroupDetails(int? groupId) async {
    try {
      String? token = await SharedData.getToken();
      if (token == null) {
        throw Exception("Token is missing.");
      }

      final Map<String, dynamic> queryParameters = {'group_id': groupId};
      final response = await http.post(
        Uri.parse(Consts.getGroupChatData)
            .replace(queryParameters: queryParameters),
        headers: buildAuthHeader(token),
      );
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        return CreateGroupChatResponse.fromJson(responseBody);
      } else {
        ToastMsg().sendErrorMsg("Some thing went wrong.");
        return null;
      }
    } catch (e) {
      // Handle network or other errors
      print('Error: $e');
      return null;
    }
  }

  signOut() {
    return SharedData.clearAllData;
  }

  //end
}
