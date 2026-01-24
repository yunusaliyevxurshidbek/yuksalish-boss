import '../../../domain/entities/login_response.dart';

class LoginResponseModel {
  final String message;
  final LoginUserModel user;
  final String accessToken;
  final String refreshToken;

  const LoginResponseModel({
    required this.message,
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final accessToken = _readAccessToken(json);
    final refreshToken = _readRefreshToken(json);
    return LoginResponseModel(
      message: json['message'] as String? ?? '',
      user: LoginUserModel.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  LoginResponseEntity toEntity() {
    return LoginResponseEntity(
      message: message,
      user: user.toEntity(),
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

class LoginUserModel {
  final int id;
  final String phone;
  final String firstName;
  final String lastName;
  final String role;

  const LoginUserModel({
    required this.id,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.role,
  });

  factory LoginUserModel.fromJson(Map<String, dynamic> json) {
    return LoginUserModel(
      id: json['id'] as int,
      phone: json['phone'] as String? ?? '',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      role: json['role'] as String? ?? '',
    );
  }

  LoginUserEntity toEntity() {
    return LoginUserEntity(
      id: id,
      phone: phone,
      firstName: firstName,
      lastName: lastName,
      role: role,
    );
  }
}
