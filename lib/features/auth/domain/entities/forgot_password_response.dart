import 'package:equatable/equatable.dart';

class ForgotPasswordResponseEntity extends Equatable {
  final String message;
  final int expiresIn;

  const ForgotPasswordResponseEntity({
    required this.message,
    required this.expiresIn,
  });

  @override
  List<Object?> get props => [message, expiresIn];
}
