import 'package:dartz/dartz.dart';

import 'package:yuksalish_mobile/core/error/failures.dart';
import '../entities/app_lock_config.dart';
import '../entities/lock_status.dart';

/// Repository interface for App Lock operations.
/// Follows the existing project pattern using Either for error handling.
abstract class AppLockRepository {
  /// Store a new PIN (hashed with salt using PBKDF2)
  Future<Either<Failure, Unit>> setupPin(String pin);

  /// Verify entered PIN against stored hash
  Future<Either<Failure, bool>> verifyPin(String pin);

  /// Check if PIN is configured
  Future<Either<Failure, bool>> isPinConfigured();

  /// Get current app lock configuration
  Future<Either<Failure, AppLockConfig>> getConfig();

  /// Update configuration (biometric toggle, timestamps, etc.)
  Future<Either<Failure, Unit>> updateConfig(AppLockConfig config);

  /// Check if biometric authentication is available on device
  Future<Either<Failure, bool>> isBiometricAvailable();

  /// Check if biometrics are enrolled on device
  Future<Either<Failure, bool>> isBiometricEnrolled();

  /// Perform biometric authentication
  Future<Either<Failure, bool>> authenticateWithBiometric();

  /// Record a failed authentication attempt (for lockout tracking)
  Future<Either<Failure, LockStatus>> recordFailedAttempt();

  /// Reset failed attempts counter (after successful auth)
  Future<Either<Failure, Unit>> resetFailedAttempts();

  /// Get current lock status
  Future<Either<Failure, LockStatus>> getLockStatus();

  /// Clear all app lock data (for logout/reset)
  Future<Either<Failure, Unit>> clearAppLockData();
}
