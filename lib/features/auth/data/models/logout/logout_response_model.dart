import '../../../domain/entities/logout_response.dart';

class LogoutResponseModel extends LogoutResponseEntity {
  const LogoutResponseModel({
    required super.message,
  });

  factory LogoutResponseModel.fromJson(Map<String, dynamic> json) {
    return LogoutResponseModel(
      message: json['message'] as String? ?? '',
    );
  }

  LogoutResponseEntity toEntity() {
    return LogoutResponseEntity(message: message);
  }
}
