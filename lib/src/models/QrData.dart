// qr_data_model.dart

class QrData {
  String company;
  String userName;
  String name;
  int userId;

  QrData({
    required this.company,
    required this.userName,
    required this.name,
    required this.userId,
  });

  factory QrData.fromJson(Map<String, dynamic> json) {
    return QrData(
      company: json['company'],
      userName: json['userName'],
      name: json['name'],
      userId: json['user_id'],
    );
  }
}
