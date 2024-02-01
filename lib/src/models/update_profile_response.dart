class UpdateProfileResponse {
  String? message;
  int? id;
  String? firstname;
  String? lastname;
  String? username;
  String? email;
  String? mobilenumber;
  String? gender;
  String? dob;
  String? kyc;
  int? kycid;
  String? profilepicurl;

  UpdateProfileResponse.fromJson(var json) {
    message = json['message'];
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    username = json['username'];
    email = json['email'];
    mobilenumber = json['mobilenumber'];
    gender = json['gender'];
    dob = json['dob'];
    kyc = json['kyc'];
    kycid = json['kycid'];
    profilepicurl = json['profilepicurl'];
  }
}
