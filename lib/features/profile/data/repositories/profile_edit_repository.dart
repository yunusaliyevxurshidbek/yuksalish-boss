import 'package:dartz/dartz.dart';

import '../datasources/profile_edit_remote_datasource.dart';
import '../models/models.dart';

/// Abstract interface for profile edit operations.
abstract class ProfileEditRepository {
  /// Get current user profile.
  Future<Either<Exception, UserProfile>> getProfile();

  /// Update basic user information.
  Future<Either<Exception, UserProfile>> updateBasicInfo({
    required String firstName,
    required String lastName,
    required String email,
  });

  /// Request phone number change.
  Future<Either<Exception, String>> requestPhoneChange({
    required String newPhone,
  });

  /// Verify phone number change.
  Future<Either<Exception, UserProfile>> verifyPhoneChange({
    required String code,
  });

  /// Change user password.
  Future<Either<Exception, void>> changePassword({
    required String oldPassword,
    required String newPassword,
  });

  /// Upload avatar image.
  Future<Either<Exception, String>> uploadAvatar({
    required String imagePath,
  });
}

/// Implementation of [ProfileEditRepository].
class ProfileEditRepositoryImpl implements ProfileEditRepository {
  final ProfileEditRemoteDataSource _remoteDataSource;

  const ProfileEditRepositoryImpl({
    required ProfileEditRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Exception, UserProfile>> getProfile() async {
    try {
      final profile = await _remoteDataSource.getProfile();
      return Right(profile);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, UserProfile>> updateBasicInfo({
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    try {
      final profile = await _remoteDataSource.updateBasicInfo(
        firstName: firstName,
        lastName: lastName,
        email: email,
      );
      return Right(profile);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, String>> requestPhoneChange({
    required String newPhone,
  }) async {
    try {
      final requestId = await _remoteDataSource.requestPhoneChange(
        newPhone: newPhone,
      );
      return Right(requestId);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, UserProfile>> verifyPhoneChange({
    required String code,
  }) async {
    try {
      final profile = await _remoteDataSource.verifyPhoneChange(code: code);
      return Right(profile);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, void>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      await _remoteDataSource.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, String>> uploadAvatar({
    required String imagePath,
  }) async {
    try {
      final url = await _remoteDataSource.uploadAvatar(imagePath: imagePath);
      return Right(url);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
