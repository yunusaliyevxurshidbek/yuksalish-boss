import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/models.dart';
import '../../data/repositories/profile_edit_repository.dart';

part 'profile_edit_event.dart';
part 'profile_edit_state.dart';

/// BLoC for profile edit operations.
class ProfileEditBloc extends Bloc<ProfileEditEvent, ProfileEditState> {
  final ProfileEditRepository _repository;

  ProfileEditBloc({
    required ProfileEditRepository repository,
  })  : _repository = repository,
        super(const ProfileEditState()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateBasicInfo>(_onUpdateBasicInfo);
    on<RequestPhoneChange>(_onRequestPhoneChange);
    on<VerifyPhoneChange>(_onVerifyPhoneChange);
    on<ChangePassword>(_onChangePassword);
    on<UploadAvatar>(_onUploadAvatar);
  }

  /// Handle LoadProfile event.
  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileEditState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _repository.getProfile();

    result.fold(
      (exception) => emit(
        state.copyWith(
          isLoading: false,
          errorMessage: exception.toString(),
        ),
      ),
      (profile) => emit(
        state.copyWith(
          isLoading: false,
          profile: profile,
        ),
      ),
    );
  }

  /// Handle UpdateBasicInfo event.
  Future<void> _onUpdateBasicInfo(
    UpdateBasicInfo event,
    Emitter<ProfileEditState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, formStatus: FormStatus.submitting));

    final result = await _repository.updateBasicInfo(
      firstName: event.firstName,
      lastName: event.lastName,
      email: event.email,
    );

    result.fold(
      (exception) => emit(
        state.copyWith(
          isSubmitting: false,
          formStatus: FormStatus.failure,
          errorMessage: exception.toString(),
        ),
      ),
      (profile) => emit(
        state.copyWith(
          isSubmitting: false,
          formStatus: FormStatus.success,
          profile: profile,
          errorMessage: null,
        ),
      ),
    );
  }

  /// Handle RequestPhoneChange event.
  Future<void> _onRequestPhoneChange(
    RequestPhoneChange event,
    Emitter<ProfileEditState> emit,
  ) async {
    emit(state.copyWith(
      isPhoneChangePending: true,
      formStatus: FormStatus.submitting,
    ));

    final result = await _repository.requestPhoneChange(
      newPhone: event.newPhone,
    );

    result.fold(
      (exception) => emit(
        state.copyWith(
          isPhoneChangePending: false,
          formStatus: FormStatus.failure,
          errorMessage: exception.toString(),
        ),
      ),
      (requestId) => emit(
        state.copyWith(
          isPhoneChangePending: false,
          formStatus: FormStatus.otpSent,
          pendingPhoneRequestId: requestId,
          errorMessage: null,
        ),
      ),
    );
  }

  /// Handle VerifyPhoneChange event.
  Future<void> _onVerifyPhoneChange(
    VerifyPhoneChange event,
    Emitter<ProfileEditState> emit,
  ) async {
    emit(state.copyWith(
      isVerifyingPhone: true,
      formStatus: FormStatus.submitting,
    ));

    final result = await _repository.verifyPhoneChange(code: event.code);

    result.fold(
      (exception) => emit(
        state.copyWith(
          isVerifyingPhone: false,
          formStatus: FormStatus.failure,
          errorMessage: exception.toString(),
        ),
      ),
      (profile) => emit(
        state.copyWith(
          isVerifyingPhone: false,
          formStatus: FormStatus.success,
          profile: profile,
          pendingPhoneRequestId: null,
          errorMessage: null,
        ),
      ),
    );
  }

  /// Handle ChangePassword event.
  Future<void> _onChangePassword(
    ChangePassword event,
    Emitter<ProfileEditState> emit,
  ) async {
    emit(state.copyWith(
      isChangingPassword: true,
      formStatus: FormStatus.submitting,
    ));

    final result = await _repository.changePassword(
      oldPassword: event.oldPassword,
      newPassword: event.newPassword,
    );

    result.fold(
      (exception) => emit(
        state.copyWith(
          isChangingPassword: false,
          formStatus: FormStatus.failure,
          errorMessage: exception.toString(),
        ),
      ),
      (_) => emit(
        state.copyWith(
          isChangingPassword: false,
          formStatus: FormStatus.success,
          errorMessage: null,
        ),
      ),
    );
  }

  /// Handle UploadAvatar event.
  Future<void> _onUploadAvatar(
    UploadAvatar event,
    Emitter<ProfileEditState> emit,
  ) async {
    emit(state.copyWith(isUploadingAvatar: true));

    final result = await _repository.uploadAvatar(imagePath: event.imagePath);

    result.fold(
      (exception) => emit(
        state.copyWith(
          isUploadingAvatar: false,
          errorMessage: exception.toString(),
        ),
      ),
      (url) {
        if (state.profile != null) {
          final updatedProfile = state.profile!.copyWith(avatarUrl: url);
          emit(state.copyWith(
            isUploadingAvatar: false,
            profile: updatedProfile,
            errorMessage: null,
          ));
        }
      },
    );
  }
}
