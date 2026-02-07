class RegisterRequestModel {
  final String phone;
  final String source;

  const RegisterRequestModel({
    required this.phone,
    this.source = 'website',
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'source': source,
    };
  }
}
