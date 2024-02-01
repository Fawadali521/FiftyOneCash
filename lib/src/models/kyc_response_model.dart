//created by MHK-MotoVlogs
class KYCResponse {
  int? id;
  String? name;
  String? gender;
  String? nationality;
  String? dob;
  String? address;
  String? kycSelfieFilename;
  String? kycSelfieUrl;
  String? kycFrontPhotoIdFilename;
  String? kycFrontPhotoIdUrl;
  String? kycBackPhotoIdFilename;
  String? kycBackPhotoIdUrl;
  String? tnx;
  String? kycStatus;
  int? kycid;
  String? requestedTime;

  KYCResponse.fromJson(var json) {
    id = json['id'];
    name = json['name'];
    gender = json['gender'];
    nationality = json['nationality'];
    dob = json['dob'];
    address = json['address'];
    kycSelfieFilename = json['kycSelfieFilename'];
    kycSelfieUrl = json['kycSelfieUrl'];
    kycFrontPhotoIdFilename = json['kycFrontPhotoIdFilename'];
    kycFrontPhotoIdUrl = json['kycFrontPhotoIdUrl'];
    kycBackPhotoIdFilename = json['kycBackPhotoIdFilename'];
    kycBackPhotoIdUrl = json['kycBackPhotoIdUrl'];
    tnx = json['tnx'];
    kycStatus = json['kycStatus'];
    kycid = json['kycid'];
    requestedTime = json['requestedTime'];
  }
}
