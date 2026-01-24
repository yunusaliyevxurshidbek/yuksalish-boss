import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../models/models.dart';

/// Remote data source for profile edit operations.
abstract class ProfileEditRemoteDataSource {
  /// Get current user profile.
  Future<UserProfile> getProfile();

  /// Update basic user information (first name, last name, email).
  Future<UserProfile> updateBasicInfo({
    required String firstName,
    required String lastName,
    required String email,
  });

  /// Request phone number change.
  Future<String> requestPhoneChange({
    required String newPhone,
  });

  /// Verify phone number change with OTP code.
  Future<UserProfile> verifyPhoneChange({
    required String code,
  });

  /// Change user password.
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  });

  /// Upload avatar image.
  Future<String> uploadAvatar({
    required String imagePath,
  });
}

/// Implementation of [ProfileEditRemoteDataSource].
class ProfileEditRemoteDataSourceImpl implements ProfileEditRemoteDataSource {
  final Dio _dio;

  const ProfileEditRemoteDataSourceImpl({
    required Dio dio,
  }) : _dio = dio;

  @override
  Future<UserProfile> getProfile() async {
    try {
      final response = await _dio.get('/users/me/');
      
      if (response.statusCode == 200) {
        return UserProfile.fromJson(response.data as Map<String, dynamic>);
      }
      
      throw ServerExceptions(
        message: 'Failed to get profile',
        statusCode: response.statusCode ?? 500,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<UserProfile> updateBasicInfo({
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    try {
      final response = await _dio.put(
        '/users/me/',
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
        },
      );

      if (response.statusCode == 200) {
        return UserProfile.fromJson(response.data as Map<String, dynamic>);
      }

      throw ServerExceptions(
        message: 'Failed to update profile',
        statusCode: response.statusCode ?? 500,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<String> requestPhoneChange({
    required String newPhone,
  }) async {
    try {
      final response = await _dio.post(
        '/users/me/phone/request/',
        data: {
          'phone': newPhone,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['request_id'] as String? ?? '';
      }

      throw ServerExceptions(
        message: 'Failed to request phone change',
        statusCode: response.statusCode ?? 500,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<UserProfile> verifyPhoneChange({
    required String code,
  }) async {
    try {
      final response = await _dio.post(
        '/users/me/phone/verify/',
        data: {
          'code': code,
        },
      );

      if (response.statusCode == 200) {
        return UserProfile.fromJson(response.data as Map<String, dynamic>);
      }

      throw ServerExceptions(
        message: 'Failed to verify phone change',
        statusCode: response.statusCode ?? 500,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.post(
        '/users/change-password/',
        data: {
          'old_password': oldPassword,
          'new_password': newPassword,
        },
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerExceptions(
          message: 'Failed to change password',
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<String> uploadAvatar({
    required String imagePath,
  }) async {
    try {
      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(imagePath),
      });

      final response = await _dio.post(
        '/users/me/avatar/',
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data['avatar_url'] as String? ?? '';
      }

      throw ServerExceptions(
        message: 'Failed to upload avatar',
        statusCode: response.statusCode ?? 500,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Handle Dio exceptions and convert to custom exceptions.
  Exception _handleDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return NetworkException('Ulanish vaqti tugadi');
    }

    if (e.response?.statusCode == 401) {
      return ServerExceptions(
        message: 'Autentifikatsiya xatosi',
        statusCode: 401,
      );
    }

    if (e.response?.statusCode == 400) {
      final errorData = e.response?.data as Map<String, dynamic>?;
      final message = errorData?['detail'] as String? ??
          errorData?['message'] as String? ??
          'Noto\'g\'ri so\'rov';
      return ServerExceptions(
        message: message,
        statusCode: 400,
      );
    }

    return NetworkException(e.message ?? 'Noma\'lum xatolik');
  }
}
