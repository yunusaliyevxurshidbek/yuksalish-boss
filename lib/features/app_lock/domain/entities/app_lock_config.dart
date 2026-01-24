import 'package:equatable/equatable.dart';

/// Immutable configuration entity for app lock settings.
/// Stored securely, never exposes the actual PIN.
class AppLockConfig extends Equatable {
  /// Whether a PIN has been set up
  final bool isPinConfigured;

  /// Whether biometric authentication is enabled
  final bool isBiometricEnabled;

  /// Timestamp when the app was last backgrounded (for timeout calculation)
  final DateTime? lastBackgroundedAt;

  /// Number of consecutive failed attempts in current lockout period
  final int failedAttempts;

  /// Current lockout tier (0 = no lockout, 1 = 30s, 2 = 1m, 3 = 5m)
  final int lockoutTier;

  /// Timestamp when lockout ends (null if not locked out)
  final DateTime? lockoutEndTime;

  const AppLockConfig({
    required this.isPinConfigured,
    required this.isBiometricEnabled,
    this.lastBackgroundedAt,
    this.failedAttempts = 0,
    this.lockoutTier = 0,
    this.lockoutEndTime,
  });

  /// Factory for initial/unconfigured state
  factory AppLockConfig.unconfigured() => const AppLockConfig(
        isPinConfigured: false,
        isBiometricEnabled: false,
      );

  AppLockConfig copyWith({
    bool? isPinConfigured,
    bool? isBiometricEnabled,
    DateTime? lastBackgroundedAt,
    int? failedAttempts,
    int? lockoutTier,
    DateTime? lockoutEndTime,
    bool clearLastBackgroundedAt = false,
    bool clearLockoutEndTime = false,
  }) =>
      AppLockConfig(
        isPinConfigured: isPinConfigured ?? this.isPinConfigured,
        isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
        lastBackgroundedAt: clearLastBackgroundedAt
            ? null
            : (lastBackgroundedAt ?? this.lastBackgroundedAt),
        failedAttempts: failedAttempts ?? this.failedAttempts,
        lockoutTier: lockoutTier ?? this.lockoutTier,
        lockoutEndTime: clearLockoutEndTime
            ? null
            : (lockoutEndTime ?? this.lockoutEndTime),
      );

  @override
  List<Object?> get props => [
        isPinConfigured,
        isBiometricEnabled,
        lastBackgroundedAt,
        failedAttempts,
        lockoutTier,
        lockoutEndTime,
      ];
}
