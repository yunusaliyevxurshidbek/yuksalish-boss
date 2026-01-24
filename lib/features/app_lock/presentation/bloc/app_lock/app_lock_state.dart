import 'package:equatable/equatable.dart';
import 'package:easy_localization/easy_localization.dart';

enum AppLockMode {
  setup, // Setting up new PIN
  confirm, // Confirming PIN during setup
  verify, // Verifying PIN to unlock
  unlocked, // App is unlocked
  changeVerify, // Verifying current PIN before change
  changeSetup, // Setting up new PIN during change
  changeConfirm, // Confirming new PIN during change
}

class AppLockState extends Equatable {
  final AppLockMode mode;
  final String currentPin;
  final String? firstPin; // Stored during setup for confirmation
  final bool isPinConfigured;
  final bool isBiometricEnabled;
  final bool isBiometricAvailable;
  final bool isLoading;
  final bool isInitialized; // True after initial lock status is loaded
  final String? error;
  final int failedAttempts;
  final int maxAttempts;
  final Duration? lockoutRemaining;
  final bool isLockedOut;
  final bool biometricPromptShowing;

  const AppLockState({
    this.mode = AppLockMode.setup,
    this.currentPin = '',
    this.firstPin,
    this.isPinConfigured = false,
    this.isBiometricEnabled = false,
    this.isBiometricAvailable = false,
    this.isLoading = false,
    this.isInitialized = false,
    this.error,
    this.failedAttempts = 0,
    this.maxAttempts = 5,
    this.lockoutRemaining,
    this.isLockedOut = false,
    this.biometricPromptShowing = false,
  });

  /// Initial state
  factory AppLockState.initial() => const AppLockState(isLoading: true, isInitialized: false);

  /// Convenience getters
  bool get canEnterDigit => currentPin.length < 4 && !isLockedOut && !isLoading;
  bool get canDeleteDigit => currentPin.isNotEmpty && !isLoading;
  bool get isPinComplete => currentPin.length == 4;
  int get remainingDigits => 4 - currentPin.length;

  String get title {
    switch (mode) {
      case AppLockMode.setup:
        return 'auth_lock_title_setup'.tr();
      case AppLockMode.confirm:
        return 'auth_lock_title_confirm'.tr();
      case AppLockMode.verify:
        return 'auth_lock_title_verify'.tr();
      case AppLockMode.unlocked:
        return 'auth_lock_title_unlocked'.tr();
      case AppLockMode.changeVerify:
        return 'auth_lock_title_change_verify'.tr();
      case AppLockMode.changeSetup:
        return 'auth_lock_title_change_setup'.tr();
      case AppLockMode.changeConfirm:
        return 'auth_lock_title_change_confirm'.tr();
    }
  }

  String get subtitle {
    if (isLockedOut && lockoutRemaining != null) {
      return 'auth_lock_subtitle_locked_out'.tr(namedArgs: {'time': _formatDuration(lockoutRemaining!)});
    }
    if (error != null) {
      return error!;
    }
    switch (mode) {
      case AppLockMode.setup:
        return 'auth_lock_subtitle_setup'.tr();
      case AppLockMode.confirm:
        return 'auth_lock_subtitle_confirm'.tr();
      case AppLockMode.verify:
        if (failedAttempts > 0) {
          return 'auth_lock_subtitle_verify_error'.tr(namedArgs: {'count': '${maxAttempts - failedAttempts}'});
        }
        return 'auth_lock_subtitle_verify'.tr();
      case AppLockMode.unlocked:
        return '';
      case AppLockMode.changeVerify:
        if (failedAttempts > 0) {
          return 'auth_lock_subtitle_change_verify_error'.tr(namedArgs: {'count': '${maxAttempts - failedAttempts}'});
        }
        return 'auth_lock_subtitle_change_verify'.tr();
      case AppLockMode.changeSetup:
        return 'auth_lock_subtitle_change_setup'.tr();
      case AppLockMode.changeConfirm:
        return 'auth_lock_subtitle_change_confirm'.tr();
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds % 60}s';
    }
    return '${duration.inSeconds}s';
  }

  AppLockState copyWith({
    AppLockMode? mode,
    String? currentPin,
    String? firstPin,
    bool? isPinConfigured,
    bool? isBiometricEnabled,
    bool? isBiometricAvailable,
    bool? isLoading,
    bool? isInitialized,
    String? error,
    int? failedAttempts,
    int? maxAttempts,
    Duration? lockoutRemaining,
    bool? isLockedOut,
    bool? biometricPromptShowing,
    bool clearFirstPin = false,
    bool clearError = false,
    bool clearLockout = false,
  }) {
    return AppLockState(
      mode: mode ?? this.mode,
      currentPin: currentPin ?? this.currentPin,
      firstPin: clearFirstPin ? null : (firstPin ?? this.firstPin),
      isPinConfigured: isPinConfigured ?? this.isPinConfigured,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      isBiometricAvailable: isBiometricAvailable ?? this.isBiometricAvailable,
      isLoading: isLoading ?? this.isLoading,
      isInitialized: isInitialized ?? this.isInitialized,
      error: clearError ? null : (error ?? this.error),
      failedAttempts: failedAttempts ?? this.failedAttempts,
      maxAttempts: maxAttempts ?? this.maxAttempts,
      lockoutRemaining:
          clearLockout ? null : (lockoutRemaining ?? this.lockoutRemaining),
      isLockedOut: isLockedOut ?? this.isLockedOut,
      biometricPromptShowing:
          biometricPromptShowing ?? this.biometricPromptShowing,
    );
  }

  @override
  List<Object?> get props => [
        mode,
        currentPin,
        firstPin,
        isPinConfigured,
        isBiometricEnabled,
        isBiometricAvailable,
        isLoading,
        isInitialized,
        error,
        failedAttempts,
        maxAttempts,
        lockoutRemaining,
        isLockedOut,
        biometricPromptShowing,
      ];
}
