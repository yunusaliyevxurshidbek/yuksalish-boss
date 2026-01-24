import 'package:equatable/equatable.dart';
import '../../../domain/entities/set_password_response.dart';

abstract class SetPasswordState extends Equatable {
  const SetPasswordState();

  @override
  List<Object?> get props => [];
}

class SetPasswordInitial extends SetPasswordState {
  const SetPasswordInitial();
}

class SetPasswordLoading extends SetPasswordState {
  const SetPasswordLoading();
}

class SetPasswordSuccess extends SetPasswordState {
  final String message;
  final SetPasswordUserEntity user;

  const SetPasswordSuccess({
    required this.message,
    required this.user,
  });

  @override
  List<Object?> get props => [message, user];
}

class SetPasswordError extends SetPasswordState {
  final String message;

  const SetPasswordError(this.message);

  @override
  List<Object?> get props => [message];
}
