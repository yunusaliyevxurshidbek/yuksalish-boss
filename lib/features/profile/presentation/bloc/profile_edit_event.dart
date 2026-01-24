part of 'profile_edit_bloc.dart';

/// Base event for ProfileEditBloc.
abstract class ProfileEditEvent extends Equatable {
  const ProfileEditEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load user profile.
class LoadProfile extends ProfileEditEvent {
  const LoadProfile();
}

/// Event to update basic user information.
class UpdateBasicInfo extends ProfileEditEvent {
  final String firstName;
  final String lastName;
  final String email;

  const UpdateBasicInfo({
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  @override
  List<Object?> get props => [firstName, lastName, email];
}

/// Event to request phone number change.
class RequestPhoneChange extends ProfileEditEvent {
  final String newPhone;

  const RequestPhoneChange({required this.newPhone});

  @override
  List<Object?> get props => [newPhone];
}

/// Event to verify phone number change with OTP.
class VerifyPhoneChange extends ProfileEditEvent {
  final String code;

  const VerifyPhoneChange({required this.code});

  @override
  List<Object?> get props => [code];
}

/// Event to change password.
class ChangePassword extends ProfileEditEvent {
  final String oldPassword;
  final String newPassword;

  const ChangePassword({
    required this.oldPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [oldPassword, newPassword];
}

/// Event to upload avatar image.
class UploadAvatar extends ProfileEditEvent {
  final String imagePath;

  const UploadAvatar({required this.imagePath});

  @override
  List<Object?> get props => [imagePath];
}
