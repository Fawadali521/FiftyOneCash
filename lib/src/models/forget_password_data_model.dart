// created by MHK-MotoVlog

class ForgetPasswordResponseData {
  final int? id;
  final String? message;
  final String? token;
  final String? firstname;
  final String? lastname;
  final String? username;
  final String? email;
  final String? mobilenumber;
  final String? gender;
  final String? dob;
  final String? kyc;
  final int? kycid;

  ForgetPasswordResponseData({
    this.id,
    this.token,
    this.kyc,
    this.kycid,
    required this.message,
    this.firstname,
    this.lastname,
    this.username,
    this.email,
    this.mobilenumber,
    this.gender,
    this.dob,
  });

  factory ForgetPasswordResponseData.fromJson(Map<String, dynamic> json) {
    return ForgetPasswordResponseData(
      id: json['id'],
      token: json['token'],
      kycid: json['kycid'],
      message: json['message'],
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      mobilenumber: json['mobilenumber'] as String?,
      gender: json['gender'] as String?,
      dob: json['dob'] as String?,
      kyc: json['kyc'] as String?,
    );
  }
}
