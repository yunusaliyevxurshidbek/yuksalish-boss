import '../../../domain/entities/set_password_response.dart';

class SetPasswordResponseModel extends SetPasswordResponseEntity {
  const SetPasswordResponseModel({
    required super.message,
    required super.user,
    required super.accessToken,
    required super.refreshToken,
  });

  factory SetPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    final accessToken = _readAccessToken(json);
    final refreshToken = _readRefreshToken(json);
    return SetPasswordResponseModel(
      message: json['message'] as String? ?? '',
      user: SetPasswordUserModel.fromJson(
        json['user'] as Map<String, dynamic>? ?? {},
      ),
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  SetPasswordResponseEntity toEntity() {
    return SetPasswordResponseEntity(
      message: message,
      user: user,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}

String _readAccessToken(Map<String, dynamic> json) {
  final token = json['access'];
  if (token is String && token.isNotEmpty) {
    return token;
  }
  final accessToken = json['access_token'];
  if (accessToken is String && accessToken.isNotEmpty) {
    return accessToken;
  }
  final tokens = json['tokens'];
  if (tokens is Map<String, dynamic>) {
    final nestedAccess = tokens['access'];
    if (nestedAccess is String && nestedAccess.isNotEmpty) {
      return nestedAccess;
    }
    final nestedAccessToken = tokens['access_token'];
    if (nestedAccessToken is String && nestedAccessToken.isNotEmpty) {
      return nestedAccessToken;
    }
  }
  return '';
}

String _readRefreshToken(Map<String, dynamic> json) {
  final token = json['refresh'];
  if (token is String && token.isNotEmpty) {
    return token;
  }
  final refreshToken = json['refresh_token'];
  if (refreshToken is String && refreshToken.isNotEmpty) {
    return refreshToken;
  }
  final tokens = json['tokens'];
  if (tokens is Map<String, dynamic>) {
    final nestedRefresh = tokens['refresh'];
    if (nestedRefresh is String && nestedRefresh.isNotEmpty) {
      return nestedRefresh;
    }
    final nestedRefreshToken = tokens['refresh_token'];
    if (nestedRefreshToken is String && nestedRefreshToken.isNotEmpty) {
      return nestedRefreshToken;
    }
  }
  return '';
}

class SetPasswordUserModel extends SetPasswordUserEntity {
  const SetPasswordUserModel({
    required super.id,
    required super.phone,
    required super.role,
  });

  factory SetPasswordUserModel.fromJson(Map<String, dynamic> json) {
    return SetPasswordUserModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      phone: json['phone'] as String? ?? '',
      role: json['role'] as String? ?? '',
    );
  }
}
