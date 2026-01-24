class VerifyOtpRequestModel {
  final String phone;
  final String code;
  final String name;

  const VerifyOtpRequestModel({
    required this.phone,
    required this.code,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'code': code,
      'name': name,
    };
  }
}
