class SignInResponse {
  final int? id;
  final String? message;
  final String? token;
  final String? firstname;
  final String? lastname;
  final String? username;
  final String? dob;
  final String? email;
  final String? mobilenumber;
  final String? gender;
  final String? kyc;
  final bool? isMasterPinSetted;
  // edited by mhk-motovlogs

  final int? kycId;

//end
  SignInResponse({
    this.message,
    this.token,
    this.firstname,
    this.lastname,
    this.username,
    this.dob,
    this.email,
    this.mobilenumber,
    this.gender,
    this.kyc,
    this.kycId,
    this.id,
    this.isMasterPinSetted,
  });

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    return SignInResponse(
      id: json['id'],
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
      kycId: json['kycid'],
      isMasterPinSetted: json['masterpinexists'],
    );
  }
}
