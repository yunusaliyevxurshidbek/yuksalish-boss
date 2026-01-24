import 'package:dartz/dartz.dart';

import 'package:yuksalish_mobile/core/constants/app_lock_constants.dart';
import 'package:yuksalish_mobile/core/error/exceptions.dart';
import 'package:yuksalish_mobile/core/error/failures.dart';
import 'package:yuksalish_mobile/core/services/crypto_service.dart';
import '../../domain/entities/app_lock_config.dart';
import '../../domain/entities/lock_status.dart';
import '../../domain/repositories/app_lock_repository.dart';
import '../datasources/local/app_lock_local_datasource.dart';
import '../datasources/local/biometric_datasource.dart';

class AppLockRepositoryImpl implements AppLockRepository {
  final AppLockLocalDataSource localDataSource;
  final BiometricDataSource biometricDataSource;
  final CryptoService cryptoService;

  AppLockRepositoryImpl({
    required this.localDataSource,
    required this.biometricDataSource,
    required this.cryptoService,
  });

  @override
  Future<Either<Failure, Unit>> setupPin(String pin) async {
    try {
      // Validate PIN length
      if (pin.length != AppLockConstants.pinLength) {
        return const Left(ValidationFailure('PIN must be 4 digits'));
      }

      // Generate salt and hash
      final salt = cryptoService.generateSalt();
      final hash = cryptoService.hashPin(pin, salt);

      // Store securely
      await localDataSource.storePinHash(hash, salt);
      await localDataSource.resetFailedAttempts();

      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to setup PIN: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyPin(String pin) async {
    try {
      final storedHash = await localDataSource.getPinHash();
      final salt = await localDataSource.getSalt();

      if (storedHash == null || salt == null) {
        return const Left(CacheFailure('PIN not configured'));
      }

      final isValid = cryptoService.verifyPin(pin, salt, storedHash);

      if (isValid) {
        // Reset failed attempts on successful verification
        await localDataSource.resetFailedAttempts();
        await localDataSource.setLockoutTier(0);
        await localDataSource.setLockoutEndTime(null);
      }

      return Right(isValid);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to verify PIN: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> isPinConfigured() async {
    try {
      final configured = await localDataSource.isPinConfigured();
      return Right(configured);
    } catch (e) {
      return const Right(false);
    }
  }

  @override
  Future<Either<Failure, AppLockConfig>> getConfig() async {
    try {
      final isPinConfigured = await localDataSource.isPinConfigured();
      final isBiometricEnabled = await localDataSource.isBiometricEnabled();
      final failedAttempts = await localDataSource.getFailedAttempts();
      final lockoutTier = await localDataSource.getLockoutTier();
      final lockoutEndTime = await localDataSource.getLockoutEndTime();
      final lastBackgroundedAt = await localDataSource.getLastBackgroundedAt();

      return Right(AppLockConfig(
        isPinConfigured: isPinConfigured,
        isBiometricEnabled: isBiometricEnabled,
        failedAttempts: failedAttempts,
        lockoutTier: lockoutTier,
        lockoutEndTime: lockoutEndTime,
        lastBackgroundedAt: lastBackgroundedAt,
      ));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Right(AppLockConfig.unconfigured());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateConfig(AppLockConfig config) async {
    try {
      await localDataSource.setBiometricEnabled(config.isBiometricEnabled);
      await localDataSource.setFailedAttempts(config.failedAttempts);
      await localDataSource.setLockoutTier(config.lockoutTier);
      await localDataSource.setLockoutEndTime(config.lockoutEndTime);
      await localDataSource.setLastBackgroundedAt(config.lastBackgroundedAt);
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to update config: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> isBiometricAvailable() async {
    try {
      final isSupported = await biometricDataSource.isDeviceSupported();
      return Right(isSupported);
    } catch (e) {
      return const Right(false);
    }
  }

  @override
  Future<Either<Failure, bool>> isBiometricEnrolled() async {
    try {
      final isEnrolled = await biometricDataSource.areBiometricsEnrolled();
      return Right(isEnrolled);
    } catch (e) {
      return const Right(false);
    }
  }

  @override
  Future<Either<Failure, bool>> authenticateWithBiometric() async {
    try {
      final authenticated = await biometricDataSource.authenticate(
        localizedReason: 'Authenticate to unlock the app',
      );

      if (authenticated) {
        // Reset failed attempts on successful biometric auth
        await localDataSource.resetFailedAttempts();
        await localDataSource.setLockoutTier(0);
        await localDataSource.setLockoutEndTime(null);
      }

      return Right(authenticated);
    } on BiometricException catch (e) {
      return Left(BiometricFailure(e.message));
    } catch (e) {
      return const Left(BiometricFailure('Biometric authentication failed'));
    }
  }

  @override
  Future<Either<Failure, LockStatus>> recordFailedAttempt() async {
    try {
      var failedAttempts = await localDataSource.getFailedAttempts();
      var lockoutTier = await localDataSource.getLockoutTier();

      failedAttempts++;
      await localDataSource.setFailedAttempts(failedAttempts);

      // Check if we hit the lockout threshold
      if (failedAttempts >= AppLockConstants.maxFailedAttempts) {
        // Calculate lockout duration based on tier
        final tierIndex =
            lockoutTier.clamp(0, AppLockConstants.lockoutDurations.length - 1);
        final lockoutSeconds = AppLockConstants.lockoutDurations[tierIndex];
        final lockoutEnd =
            DateTime.now().add(Duration(seconds: lockoutSeconds));

        await localDataSource.setLockoutEndTime(lockoutEnd);

        // Increment tier for next lockout (cap at max tier)
        if (lockoutTier < AppLockConstants.lockoutDurations.length - 1) {
          await localDataSource.setLockoutTier(lockoutTier + 1);
        }

        // Reset failed attempts counter for next round
        await localDataSource.setFailedAttempts(0);

        return Right(LockStatus(
          state: LockState.lockedOut,
          lockoutRemaining: Duration(seconds: lockoutSeconds),
          failedAttempts: 0,
          maxAttempts: AppLockConstants.maxFailedAttempts,
          canUseBiometrics: await localDataSource.isBiometricEnabled(),
        ));
      }

      return Right(LockStatus(
        state: LockState.locked,
        failedAttempts: failedAttempts,
        maxAttempts: AppLockConstants.maxFailedAttempts,
        canUseBiometrics: await localDataSource.isBiometricEnabled(),
      ));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to record attempt: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> resetFailedAttempts() async {
    try {
      await localDataSource.resetFailedAttempts();
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, LockStatus>> getLockStatus() async {
    try {
      final isPinConfigured = await localDataSource.isPinConfigured();

      if (!isPinConfigured) {
        return const Right(LockStatus(state: LockState.unconfigured));
      }

      // Check lockout status
      final lockoutEndTime = await localDataSource.getLockoutEndTime();
      if (lockoutEndTime != null) {
        final now = DateTime.now();
        if (now.isBefore(lockoutEndTime)) {
          final remaining = lockoutEndTime.difference(now);
          return Right(LockStatus(
            state: LockState.lockedOut,
            lockoutRemaining: remaining,
            failedAttempts: 0,
            maxAttempts: AppLockConstants.maxFailedAttempts,
            canUseBiometrics: false, // Can't use biometrics during lockout
          ));
        } else {
          // Lockout expired, clear it
          await localDataSource.setLockoutEndTime(null);
        }
      }

      final failedAttempts = await localDataSource.getFailedAttempts();
      final isBiometricEnabled = await localDataSource.isBiometricEnabled();

      return Right(LockStatus(
        state: LockState.locked,
        failedAttempts: failedAttempts,
        maxAttempts: AppLockConstants.maxFailedAttempts,
        canUseBiometrics: isBiometricEnabled,
      ));
    } catch (e) {
      return const Right(LockStatus(state: LockState.unconfigured));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearAppLockData() async {
    try {
      await localDataSource.clearAll();
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
