import 'package:equatable/equatable.dart';

class RegisterResponseEntity extends Equatable {
  final String message;
  final String phone;
  final int expiresIn;

  const RegisterResponseEntity({
    required this.message,
    required this.phone,
    required this.expiresIn,
  });

  @override
  List<Object?> get props => [message, phone, expiresIn];
}
