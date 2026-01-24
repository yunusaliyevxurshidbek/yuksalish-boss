class SetPasswordRequestModel {
  final String phone;
  final String password;

  const SetPasswordRequestModel({
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'password': password,
    };
  }
}
