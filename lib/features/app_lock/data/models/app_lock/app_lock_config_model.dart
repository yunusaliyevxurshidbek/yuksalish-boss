import '../../../domain/entities/app_lock_config.dart';

/// Data model for AppLockConfig
class AppLockConfigModel extends AppLockConfig {
  const AppLockConfigModel({
    required super.isPinConfigured,
    required super.isBiometricEnabled,
    super.lastBackgroundedAt,
    super.failedAttempts,
    super.lockoutTier,
    super.lockoutEndTime,
  });

  factory AppLockConfigModel.fromEntity(AppLockConfig entity) {
    return AppLockConfigModel(
      isPinConfigured: entity.isPinConfigured,
      isBiometricEnabled: entity.isBiometricEnabled,
      lastBackgroundedAt: entity.lastBackgroundedAt,
      failedAttempts: entity.failedAttempts,
      lockoutTier: entity.lockoutTier,
      lockoutEndTime: entity.lockoutEndTime,
    );
  }

  AppLockConfig toEntity() {
    return AppLockConfig(
      isPinConfigured: isPinConfigured,
      isBiometricEnabled: isBiometricEnabled,
      lastBackgroundedAt: lastBackgroundedAt,
      failedAttempts: failedAttempts,
      lockoutTier: lockoutTier,
      lockoutEndTime: lockoutEndTime,
    );
  }
}
