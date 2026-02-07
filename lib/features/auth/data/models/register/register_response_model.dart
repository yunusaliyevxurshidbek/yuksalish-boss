import '../../../domain/entities/register_response.dart';

class RegisterResponseModel {
  final String message;
  final String phone;
  final int expiresIn;

  const RegisterResponseModel({
    required this.message,
    required this.phone,
    required this.expiresIn,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      message: json['message'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      expiresIn: json['expires_in'] as int? ?? 60,
    );
  }

  RegisterResponseEntity toEntity() {
    return RegisterResponseEntity(
      message: message,
      phone: phone,
      expiresIn: expiresIn,
    );
  }
}
