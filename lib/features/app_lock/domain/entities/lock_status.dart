import 'package:equatable/equatable.dart';

/// Represents the current lock state of the application
enum LockState {
  /// No PIN configured, app is open
  unconfigured,

  /// PIN configured, app is unlocked
  unlocked,

  /// PIN configured, app is locked (requires authentication)
  locked,

  /// Too many failed attempts, temporarily locked out
  lockedOut,
}

/// Represents the current lock status of the application
class LockStatus extends Equatable {
  final LockState state;
  final Duration? lockoutRemaining;
  final int failedAttempts;
  final int maxAttempts;
  final bool canUseBiometrics;

  const LockStatus({
    required this.state,
    this.lockoutRemaining,
    this.failedAttempts = 0,
    this.maxAttempts = 5,
    this.canUseBiometrics = false,
  });

  bool get isLocked =>
      state == LockState.locked || state == LockState.lockedOut;
  bool get isLockedOut => state == LockState.lockedOut;

  @override
  List<Object?> get props =>
      [state, lockoutRemaining, failedAttempts, maxAttempts, canUseBiometrics];
}
