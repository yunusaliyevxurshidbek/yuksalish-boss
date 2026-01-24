import '../../../domain/entities/verify_otp_response.dart';

class VerifyOtpResponseModel extends VerifyOtpResponseEntity {
  const VerifyOtpResponseModel({
    required super.message,
    required super.user,
    required super.needsPassword,
  });

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    // Handle both 'needs_password' and 'has_password' keys
    // If 'needs_password' exists, use it directly
    // If 'has_password' exists, invert it (has_password: false means needsPassword: true)
    bool needsPassword = false;
    if (json.containsKey('needs_password')) {
      needsPassword = json['needs_password'] as bool? ?? false;
    } else if (json.containsKey('has_password')) {
      final hasPassword = json['has_password'] as bool? ?? true;
      needsPassword = !hasPassword;
    }

    return VerifyOtpResponseModel(
      message: json['message'] as String? ?? '',
      user: VerifyOtpUserModel.fromJson(
        json['user'] as Map<String, dynamic>? ?? const <String, dynamic>{},
      ),
      needsPassword: needsPassword,
    );
  }

  VerifyOtpResponseEntity toEntity() {
    return VerifyOtpResponseEntity(
      message: message,
      user: user,
      needsPassword: needsPassword,
    );
  }
}

class VerifyOtpUserModel extends VerifyOtpUserEntity {
  const VerifyOtpUserModel({
    required super.id,
    required super.phone,
    required super.role,
  });

  factory VerifyOtpUserModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpUserModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      phone: json['phone'] as String? ?? '',
      role: json['role'] as String? ?? '',
    );
  }
}
