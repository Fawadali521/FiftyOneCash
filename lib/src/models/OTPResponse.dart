class OTPResponse {
  final int? id;
  final String message;
  final String token;
  final String? firstname;
  final String? lastname;
  final String? username;
  final String? dob;
  final String email;
  final String mobilenumber;
  final String? gender;
  final String? kyc;

  OTPResponse(
      {required this.message,
      required this.token,
      this.firstname,
      this.lastname,
      this.username,
      this.dob,
      required this.email,
      required this.mobilenumber,
      this.gender,
      this.kyc,
      this.id});

  factory OTPResponse.fromJson(Map<String, dynamic> json) {
    return OTPResponse(
      message: json['message'],
      token: json['token'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      username: json['username'],
      dob: json['dob'],
      email: json['email'],
      mobilenumber: json['mobilenumber'],
      gender: json['gender'],
      kyc: json['kyc'],
      id: json['id'],
    );
  }
}
