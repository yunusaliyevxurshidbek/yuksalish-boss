import '../../../domain/entities/reset_password_response.dart';

class ResetPasswordResponseModel {
  final String message;
  final ResetPasswordUserModel user;

  const ResetPasswordResponseModel({
    required this.message,
    required this.user,
  });

  factory ResetPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponseModel(
      message: json['message'] as String? ?? '',
      user: ResetPasswordUserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  ResetPasswordResponseEntity toEntity() {
    return ResetPasswordResponseEntity(
      message: message,
      user: user.toEntity(),
    );
  }
}

class ResetPasswordUserModel {
  final int id;
  final String phone;
  final String role;

  const ResetPasswordUserModel({
    required this.id,
    required this.phone,
    required this.role,
  });

  factory ResetPasswordUserModel.fromJson(Map<String, dynamic> json) {
    return ResetPasswordUserModel(
      id: json['id'] as int,
      phone: json['phone'] as String? ?? '',
      role: json['role'] as String? ?? '',
    );
  }

  ResetPasswordUserEntity toEntity() {
    return ResetPasswordUserEntity(
      id: id,
      phone: phone,
      role: role,
    );
  }
}
