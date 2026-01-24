import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/models.dart';
import '../../data/repositories/profile_repository.dart';
import 'profile_state.dart';

/// Cubit for managing profile state.
class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repository;

  ProfileCubit({
    required ProfileRepository repository,
  })  : _repository = repository,
        super(ProfileState.initial());

  /// Load user profile and related data.
  Future<void> loadProfile() async {
    emit(state.copyWith(status: ProfileStatus.loading));

    try {
      final profile = await _repository.getProfile();
      final cacheSize = await _repository.getCacheSize();

      // Debug log
      developer.log('Profile loaded: ${profile.firstName} ${profile.lastName}', name: 'ProfileCubit');

      emit(state.copyWith(
        status: ProfileStatus.loaded,
        profile: profile,
        statistics: ProfileStatistics.empty(),
        cacheSize: cacheSize,
      ));
    } catch (e, stackTrace) {
      // Debug log
      developer.log('Error loading profile: $e', name: 'ProfileCubit', error: e, stackTrace: stackTrace);

      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Refresh profile data.
  Future<void> refresh() async {
    if (state.isLoading) return;
    await loadProfile();
  }

  /// Update user profile.
  Future<bool> updateProfile(UserProfile profile) async {
    emit(state.copyWith(isUpdating: true, errorMessage: null));

    try {
      developer.log(
        'Updating profile: firstName=${profile.firstName}, lastName=${profile.lastName}, email=${profile.email}, phone=${profile.phone}',
        name: 'ProfileCubit',
      );

      final updatedProfile = await _repository.updateProfile(profile);

      developer.log(
        'Profile updated successfully: ${updatedProfile.firstName} ${updatedProfile.lastName}',
        name: 'ProfileCubit',
      );

      emit(state.copyWith(
        profile: updatedProfile,
        isUpdating: false,
        errorMessage: null,
      ));
      return true;
    } catch (e, stackTrace) {
      developer.log(
        'Error updating profile: $e',
        name: 'ProfileCubit',
        error: e,
        stackTrace: stackTrace,
      );

      emit(state.copyWith(
        isUpdating: false,
        errorMessage: e.toString(),
      ));
      return false;
    }
  }

  /// Update user settings.
  Future<void> updateSettings(UserSettings settings) async {
    if (state.profile == null) return;

    final updatedProfile = state.profile!.copyWith(settings: settings);
    emit(state.copyWith(profile: updatedProfile));

    try {
      await _repository.updateSettings(settings);
    } catch (e) {
      // Revert on error
      emit(state.copyWith(
        profile: state.profile,
        errorMessage: e.toString(),
      ));
    }
  }

  // =========================================================================
  // Security Settings
  // =========================================================================

  /// Toggle biometric authentication.
  Future<void> toggleBiometric(bool enabled) async {
    final newSettings = state.settings.copyWith(biometricEnabled: enabled);
    await updateSettings(newSettings);
  }

  /// Set session timeout.
  Future<void> setSessionTimeout(int minutes) async {
    final newSettings = state.settings.copyWith(sessionTimeoutMinutes: minutes);
    await updateSettings(newSettings);
  }

  // =========================================================================
  // Notification Settings
  // =========================================================================

  /// Toggle push notifications.
  Future<void> togglePushNotifications(bool enabled) async {
    final newSettings = state.settings.copyWith(pushNotifications: enabled);
    await updateSettings(newSettings);
  }

  /// Toggle email notifications.
  Future<void> toggleEmailNotifications(bool enabled) async {
    final newSettings = state.settings.copyWith(emailNotifications: enabled);
    await updateSettings(newSettings);
  }

  /// Toggle sound.
  Future<void> toggleSound(bool enabled) async {
    final newSettings = state.settings.copyWith(soundEnabled: enabled);
    await updateSettings(newSettings);
  }

  /// Toggle vibration.
  Future<void> toggleVibration(bool enabled) async {
    final newSettings = state.settings.copyWith(vibrationEnabled: enabled);
    await updateSettings(newSettings);
  }

  // =========================================================================
  // Notification Type Settings
  // =========================================================================

  /// Toggle new leads notifications.
  Future<void> toggleNewLeadsNotifications(bool enabled) async {
    final newSettings = state.settings.copyWith(newLeadsNotifications: enabled);
    await updateSettings(newSettings);
  }

  /// Toggle payments notifications.
  Future<void> togglePaymentsNotifications(bool enabled) async {
    final newSettings =
        state.settings.copyWith(paymentsNotifications: enabled);
    await updateSettings(newSettings);
  }

  /// Toggle overdue notifications.
  Future<void> toggleOverdueNotifications(bool enabled) async {
    final newSettings = state.settings.copyWith(overdueNotifications: enabled);
    await updateSettings(newSettings);
  }

  /// Toggle approvals notifications.
  Future<void> toggleApprovalsNotifications(bool enabled) async {
    final newSettings =
        state.settings.copyWith(approvalsNotifications: enabled);
    await updateSettings(newSettings);
  }

  /// Toggle contracts notifications.
  Future<void> toggleContractsNotifications(bool enabled) async {
    final newSettings =
        state.settings.copyWith(contractsNotifications: enabled);
    await updateSettings(newSettings);
  }

  // =========================================================================
  // App Settings
  // =========================================================================

  /// Set language.
  Future<void> setLanguage(String languageCode) async {
    final newSettings = state.settings.copyWith(language: languageCode);
    await updateSettings(newSettings);
  }

  /// Toggle dark mode.
  Future<void> toggleDarkMode(bool enabled) async {
    final newSettings = state.settings.copyWith(darkMode: enabled);
    await updateSettings(newSettings);
  }

  // =========================================================================
  // Device Management
  // =========================================================================

  /// Load authorized devices.
  Future<void> loadDevices() async {
    try {
      final devices = await _repository.getDevices();
      emit(state.copyWith(devices: devices));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  /// Remove a device.
  Future<void> removeDevice(String deviceId) async {
    try {
      await _repository.removeDevice(deviceId);
      final updatedDevices =
          state.devices.where((d) => d.id != deviceId).toList();
      emit(state.copyWith(devices: updatedDevices));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  /// Remove all devices except current.
  Future<void> removeAllDevices() async {
    try {
      await _repository.removeAllDevices();
      final updatedDevices =
          state.devices.where((d) => d.isCurrentDevice).toList();
      emit(state.copyWith(devices: updatedDevices));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  // =========================================================================
  // Cache Management
  // =========================================================================

  /// Clear cache.
  Future<void> clearCache() async {
    emit(state.copyWith(isUpdating: true));

    try {
      await _repository.clearCache();
      emit(state.copyWith(
        cacheSize: 0,
        isUpdating: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isUpdating: false,
        errorMessage: e.toString(),
      ));
    }
  }

  // =========================================================================
  // Logout
  // =========================================================================

  /// Set logging out state.
  void setLoggingOut(bool value) {
    emit(state.copyWith(isLoggingOut: value));
  }
}
