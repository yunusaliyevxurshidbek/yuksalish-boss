/// Constants for App Lock feature
class AppLockConstants {
  AppLockConstants._();

  /// PIN length requirement
  static const int pinLength = 4;

  /// Maximum failed attempts before lockout
  static const int maxFailedAttempts = 5;

  /// Lockout durations in seconds (exponential backoff)
  /// 30s, 1m, 5m
  static const List<int> lockoutDurations = [30, 60, 300];

  /// Background timeout before requiring re-authentication (seconds)
  static const int backgroundTimeoutSeconds = 15;

  /// PBKDF2 iteration count for PIN hashing
  static const int pbkdf2Iterations = 10000;

  /// Salt length in bytes
  static const int saltLength = 32;

  /// Hash length in bytes
  static const int hashLength = 32;

  /// Secure storage keys
  static const String keyPinHash = 'app_lock_pin_hash';
  static const String keySalt = 'app_lock_salt';
  static const String keyBiometricEnabled = 'app_lock_biometric_enabled';
  static const String keyFailedAttempts = 'app_lock_failed_attempts';
  static const String keyLockoutTier = 'app_lock_lockout_tier';
  static const String keyLockoutEndTime = 'app_lock_lockout_end';
  static const String keyLastBackgroundedAt = 'app_lock_last_backgrounded';
  static const String keyPinConfigured = 'app_lock_pin_configured';
}
