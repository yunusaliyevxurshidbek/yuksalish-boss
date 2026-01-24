import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  final String message;
  final int userId;
  final String phone;
  final String role;

  const LoginSuccess({
    required this.message,
    required this.userId,
    required this.phone,
    required this.role,
  });

  @override
  List<Object?> get props => [message, userId, phone, role];
}

class LoginError extends LoginState {
  final String message;

  const LoginError(this.message);

  @override
  List<Object?> get props => [message];
}
