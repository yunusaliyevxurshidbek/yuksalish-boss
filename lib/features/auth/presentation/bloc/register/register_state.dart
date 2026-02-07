import 'package:equatable/equatable.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

class RegisterLoading extends RegisterState {
  const RegisterLoading();
}

class RegisterSuccess extends RegisterState {
  final String message;
  final String phone;
  final int expiresIn;

  const RegisterSuccess({
    required this.message,
    required this.phone,
    required this.expiresIn,
  });

  @override
  List<Object?> get props => [message, phone, expiresIn];
}

class RegisterError extends RegisterState {
  final String message;

  const RegisterError(this.message);

  @override
  List<Object?> get props => [message];
}

class RegisterPhoneExists extends RegisterState {
  final String message;
  final String phone;

  const RegisterPhoneExists({
    required this.message,
    required this.phone,
  });

  @override
  List<Object?> get props => [message, phone];
}
