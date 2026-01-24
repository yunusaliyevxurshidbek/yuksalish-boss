import 'package:equatable/equatable.dart';

class VerifyOtpResponseEntity extends Equatable {
  final String message;
  final VerifyOtpUserEntity user;
  final bool needsPassword;

  const VerifyOtpResponseEntity({
    required this.message,
    required this.user,
    required this.needsPassword,
  });

  @override
  List<Object?> get props => [message, user, needsPassword];
}

class VerifyOtpUserEntity extends Equatable {
  final int id;
  final String phone;
  final String role;

  const VerifyOtpUserEntity({
    required this.id,
    required this.phone,
    required this.role,
  });

  @override
  List<Object?> get props => [id, phone, role];
}
