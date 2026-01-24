class ResetPasswordRequestModel {
  final String phone;
  final String code;
  final String newPassword;

  const ResetPasswordRequestModel({
    required this.phone,
    required this.code,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'code': code,
      'new_password': newPassword,
    };
  }
}
