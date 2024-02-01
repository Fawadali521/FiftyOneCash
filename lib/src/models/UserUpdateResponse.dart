class UserUpdateResponse {
  final int? id;
  final String message;
  final String? firstname;
  final String? lastname;
  final String? username;
  final String? email;
  final String? mobilenumber;
  final String? gender;
  final String? dob;
  final String? kyc;
  final bool? masterPinStatus;

  UserUpdateResponse({
    required this.message,
    this.firstname,
    this.lastname,
    this.username,
    this.email,
    this.mobilenumber,
    this.gender,
    this.dob,
    this.kyc,
    this.masterPinStatus,
    this.id,
  });

  factory UserUpdateResponse.fromJson(Map<String, dynamic> json) {
    return UserUpdateResponse(
      message: json['message'],
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      mobilenumber: json['mobilenumber'] as String?,
      gender: json['gender'] as String?,
      dob: json['dob'] as String?,
      kyc: json['kyc'] as String?,
      id: json['id'],
    );
  }
}
