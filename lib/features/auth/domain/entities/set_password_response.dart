import 'package:equatable/equatable.dart';

class SetPasswordResponseEntity extends Equatable {
  final String message;
  final SetPasswordUserEntity user;
  final String accessToken;
  final String refreshToken;

  const SetPasswordResponseEntity({
    required this.message,
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  @override
  List<Object?> get props => [message, user, accessToken, refreshToken];
}

class SetPasswordUserEntity extends Equatable {
  final int id;
  final String phone;
  final String role;

  const SetPasswordUserEntity({
    required this.id,
    required this.phone,
    required this.role,
  });

  @override
  List<Object?> get props => [id, phone, role];
}
