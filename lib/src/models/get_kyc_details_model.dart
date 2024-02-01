//created by mhk-motovlogs

class GetKycDetailsModel {
  int? id;
  String? name;
  String? gender;
  String? nationality;
  String? dob;
  String? address;
  String? kycSelfie;
  String? kycFrontImage;
  String? kycBackImage;
  String? tnx;
  String? kycStatus;

  GetKycDetailsModel.fromJson(json) {
    id = json['id'];
    name = json['name'];
    gender = json['gender'];
    nationality = json['nationality'];
    dob = json['dob'];
    address = json['address'];
    kycSelfie = json['kycSelfieUrl'];
    kycFrontImage = json['kycFrontPhotoIdUrl'];
    kycBackImage = json['kycBackPhotoIdUrl'];
    tnx = json['tnx'];
    kycStatus = json['kycStatus'];
  }
}
