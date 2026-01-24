import '../../../domain/entities/forgot_password_response.dart';

class ForgotPasswordResponseModel {
  final String message;
  final int expiresIn;

  const ForgotPasswordResponseModel({
    required this.message,
    required this.expiresIn,
  });

  factory ForgotPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponseModel(
      message: json['message'] as String? ?? '',
      expiresIn: json['expires_in'] as int? ?? 300,
    );
  }

  ForgotPasswordResponseEntity toEntity() {
    return ForgotPasswordResponseEntity(
      message: message,
      expiresIn: expiresIn,
    );
  }
}
