import 'package:equatable/equatable.dart';

class ResetPasswordResponseEntity extends Equatable {
  final String message;
  final ResetPasswordUserEntity user;

  const ResetPasswordResponseEntity({
    required this.message,
    required this.user,
  });

  @override
  List<Object?> get props => [message, user];
}

class ResetPasswordUserEntity extends Equatable {
  final int id;
  final String phone;
  final String role;

  const ResetPasswordUserEntity({
    required this.id,
    required this.phone,
    required this.role,
  });

  @override
  List<Object?> get props => [id, phone, role];
}
