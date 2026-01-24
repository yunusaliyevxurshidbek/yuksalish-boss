class ForgotPasswordRequestModel {
  final String phone;
  final String source;

  const ForgotPasswordRequestModel({
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
