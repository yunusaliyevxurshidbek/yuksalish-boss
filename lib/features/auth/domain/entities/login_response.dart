import 'package:equatable/equatable.dart';

class LoginResponseEntity extends Equatable {
  final String message;
  final LoginUserEntity user;
  final String accessToken;
  final String refreshToken;

  const LoginResponseEntity({
    required this.message,
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  @override
  List<Object?> get props => [message, user, accessToken, refreshToken];
}

class LoginUserEntity extends Equatable {
  final int id;
  final String phone;
  final String firstName;
  final String lastName;
  final String role;

  const LoginUserEntity({
    required this.id,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.role,
  });

  String get fullName {
    if (firstName.isEmpty && lastName.isEmpty) return '';
    return '$firstName $lastName'.trim();
  }

  @override
  List<Object?> get props => [id, phone, firstName, lastName, role];
}
