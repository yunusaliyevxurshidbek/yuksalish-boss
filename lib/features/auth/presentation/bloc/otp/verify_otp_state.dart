import 'package:equatable/equatable.dart';
import '../../../domain/entities/verify_otp_response.dart';

abstract class VerifyOtpState extends Equatable {
  const VerifyOtpState();

  @override
  List<Object?> get props => [];
}

class VerifyOtpInitial extends VerifyOtpState {
  const VerifyOtpInitial();
}

class VerifyOtpLoading extends VerifyOtpState {
  const VerifyOtpLoading();
}

class VerifyOtpSuccess extends VerifyOtpState {
  final String message;
  final VerifyOtpUserEntity user;
  final bool needsPassword;

  const VerifyOtpSuccess({
    required this.message,
    required this.user,
    required this.needsPassword,
  });

  @override
  List<Object?> get props => [message, user, needsPassword];
}

class VerifyOtpError extends VerifyOtpState {
  final String message;

  const VerifyOtpError(this.message);

  @override
  List<Object?> get props => [message];
}
