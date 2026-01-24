import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:yuksalish_mobile/core/constants/app_lock_constants.dart';
import 'package:yuksalish_mobile/core/error/exceptions.dart';

/// Local data source for secure PIN storage and app lock metadata.
/// Uses flutter_secure_storage for encrypted storage.
abstract class AppLockLocalDataSource {
  /// Store PIN hash and salt
  Future<void> storePinHash(String hash, String salt);

  /// Get stored PIN hash
  Future<String?> getPinHash();

  /// Get stored salt
  Future<String?> getSalt();

  /// Check if PIN is configured
  Future<bool> isPinConfigured();

  /// Get/Set biometric enabled flag
  Future<bool> isBiometricEnabled();
  Future<void> setBiometricEnabled(bool enabled);

  /// Failed attempts management
  Future<int> getFailedAttempts();
  Future<void> setFailedAttempts(int count);
  Future<void> resetFailedAttempts();

  /// Lockout management
  Future<int> getLockoutTier();
  Future<void> setLockoutTier(int tier);
  Future<DateTime?> getLockoutEndTime();
  Future<void> setLockoutEndTime(DateTime? time);

  /// Background timestamp
  Future<DateTime?> getLastBackgroundedAt();
  Future<void> setLastBackgroundedAt(DateTime? time);

  /// Clear all data
  Future<void> clearAll();
}

class AppLockLocalDataSourceImpl implements AppLockLocalDataSource {
  final FlutterSecureStorage _secureStorage;

  AppLockLocalDataSourceImpl({
    required FlutterSecureStorage secureStorage,
  }) : _secureStorage = secureStorage;

  @override
  Future<void> storePinHash(String hash, String salt) async {
    try {
      await _secureStorage.write(
          key: AppLockConstants.keyPinHash, value: hash);
      await _secureStorage.write(key: AppLockConstants.keySalt, value: salt);
      await _secureStorage.write(
          key: AppLockConstants.keyPinConfigured, value: 'true');
    } catch (e) {
      throw CacheException('Failed to store PIN: ${e.toString()}');
    }
  }

  @override
  Future<String?> getPinHash() async {
    try {
      return await _secureStorage.read(key: AppLockConstants.keyPinHash);
    } catch (e) {
      throw CacheException('Failed to read PIN hash: ${e.toString()}');
    }
  }

  @override
  Future<String?> getSalt() async {
    try {
      return await _secureStorage.read(key: AppLockConstants.keySalt);
    } catch (e) {
      throw CacheException('Failed to read salt: ${e.toString()}');
    }
  }

  @override
  Future<bool> isPinConfigured() async {
    try {
      final configured =
          await _secureStorage.read(key: AppLockConstants.keyPinConfigured);
      return configured == 'true';
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> isBiometricEnabled() async {
    try {
      final enabled =
          await _secureStorage.read(key: AppLockConstants.keyBiometricEnabled);
      return enabled == 'true';
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> setBiometricEnabled(bool enabled) async {
    try {
      await _secureStorage.write(
        key: AppLockConstants.keyBiometricEnabled,
        value: enabled.toString(),
      );
    } catch (e) {
      throw CacheException(
          'Failed to set biometric enabled: ${e.toString()}');
    }
  }

  @override
  Future<int> getFailedAttempts() async {
    try {
      final attempts =
          await _secureStorage.read(key: AppLockConstants.keyFailedAttempts);
      return int.tryParse(attempts ?? '0') ?? 0;
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<void> setFailedAttempts(int count) async {
    try {
      await _secureStorage.write(
        key: AppLockConstants.keyFailedAttempts,
        value: count.toString(),
      );
    } catch (e) {
      throw CacheException(
          'Failed to set failed attempts: ${e.toString()}');
    }
  }

  @override
  Future<void> resetFailedAttempts() async {
    await setFailedAttempts(0);
  }

  @override
  Future<int> getLockoutTier() async {
    try {
      final tier =
          await _secureStorage.read(key: AppLockConstants.keyLockoutTier);
      return int.tryParse(tier ?? '0') ?? 0;
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<void> setLockoutTier(int tier) async {
    try {
      await _secureStorage.write(
        key: AppLockConstants.keyLockoutTier,
        value: tier.toString(),
      );
    } catch (e) {
      throw CacheException(
          'Failed to set lockout tier: ${e.toString()}');
    }
  }

  @override
  Future<DateTime?> getLockoutEndTime() async {
    try {
      final timeStr =
          await _secureStorage.read(key: AppLockConstants.keyLockoutEndTime);
      if (timeStr == null) return null;
      return DateTime.tryParse(timeStr);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> setLockoutEndTime(DateTime? time) async {
    try {
      if (time == null) {
        await _secureStorage.delete(key: AppLockConstants.keyLockoutEndTime);
      } else {
        await _secureStorage.write(
          key: AppLockConstants.keyLockoutEndTime,
          value: time.toIso8601String(),
        );
      }
    } catch (e) {
      throw CacheException(
          'Failed to set lockout end time: ${e.toString()}');
    }
  }

  @override
  Future<DateTime?> getLastBackgroundedAt() async {
    try {
      final timeStr = await _secureStorage.read(
          key: AppLockConstants.keyLastBackgroundedAt);
      if (timeStr == null) return null;
      return DateTime.tryParse(timeStr);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> setLastBackgroundedAt(DateTime? time) async {
    try {
      if (time == null) {
        await _secureStorage.delete(
            key: AppLockConstants.keyLastBackgroundedAt);
      } else {
        await _secureStorage.write(
          key: AppLockConstants.keyLastBackgroundedAt,
          value: time.toIso8601String(),
        );
      }
    } catch (e) {
      throw CacheException(
          'Failed to set last backgrounded time: ${e.toString()}');
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      await _secureStorage.delete(key: AppLockConstants.keyPinHash);
      await _secureStorage.delete(key: AppLockConstants.keySalt);
      await _secureStorage.delete(key: AppLockConstants.keyPinConfigured);
      await _secureStorage.delete(key: AppLockConstants.keyBiometricEnabled);
      await _secureStorage.delete(key: AppLockConstants.keyFailedAttempts);
      await _secureStorage.delete(key: AppLockConstants.keyLockoutTier);
      await _secureStorage.delete(key: AppLockConstants.keyLockoutEndTime);
      await _secureStorage.delete(key: AppLockConstants.keyLastBackgroundedAt);
    } catch (e) {
      throw CacheException(
          'Failed to clear app lock data: ${e.toString()}');
    }
  }
}
