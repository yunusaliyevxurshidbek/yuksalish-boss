part of 'profile_edit_bloc.dart';

/// Form status enum.
enum FormStatus {
  initial,
  submitting,
  success,
  failure,
  otpSent,
}

/// State for ProfileEditBloc.
class ProfileEditState extends Equatable {
  final UserProfile? profile;
  final bool isLoading;
  final bool isSubmitting;
  final bool isPhoneChangePending;
  final bool isVerifyingPhone;
  final bool isChangingPassword;
  final bool isUploadingAvatar;
  final FormStatus formStatus;
  final String? errorMessage;
  final String? pendingPhoneRequestId;

  const ProfileEditState({
    this.profile,
    this.isLoading = false,
    this.isSubmitting = false,
    this.isPhoneChangePending = false,
    this.isVerifyingPhone = false,
    this.isChangingPassword = false,
    this.isUploadingAvatar = false,
    this.formStatus = FormStatus.initial,
    this.errorMessage,
    this.pendingPhoneRequestId,
  });

  /// Creates a copy with updated fields.
  ProfileEditState copyWith({
    UserProfile? profile,
    bool? isLoading,
    bool? isSubmitting,
    bool? isPhoneChangePending,
    bool? isVerifyingPhone,
    bool? isChangingPassword,
    bool? isUploadingAvatar,
    FormStatus? formStatus,
    String? errorMessage,
    String? pendingPhoneRequestId,
  }) {
    return ProfileEditState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isPhoneChangePending: isPhoneChangePending ?? this.isPhoneChangePending,
      isVerifyingPhone: isVerifyingPhone ?? this.isVerifyingPhone,
      isChangingPassword: isChangingPassword ?? this.isChangingPassword,
      isUploadingAvatar: isUploadingAvatar ?? this.isUploadingAvatar,
      formStatus: formStatus ?? this.formStatus,
      errorMessage: errorMessage,
      pendingPhoneRequestId:
          pendingPhoneRequestId ?? this.pendingPhoneRequestId,
    );
  }

  @override
  List<Object?> get props => [
        profile,
        isLoading,
        isSubmitting,
        isPhoneChangePending,
        isVerifyingPhone,
        isChangingPassword,
        isUploadingAvatar,
        formStatus,
        errorMessage,
        pendingPhoneRequestId,
      ];
}
