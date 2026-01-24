import '../../../domain/entities/lock_status.dart';

/// Data model for LockStatus
class LockStatusModel extends LockStatus {
  const LockStatusModel({
    required super.state,
    super.lockoutRemaining,
    super.failedAttempts,
    super.maxAttempts,
    super.canUseBiometrics,
  });

  LockStatus toEntity() {
    return LockStatus(
      state: state,
      lockoutRemaining: lockoutRemaining,
      failedAttempts: failedAttempts,
      maxAttempts: maxAttempts,
      canUseBiometrics: canUseBiometrics,
    );
  }
}
