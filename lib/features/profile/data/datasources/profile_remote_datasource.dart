import 'dart:developer' as developer;

import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../models/models.dart';

/// Remote data source for profile operations.
abstract class ProfileRemoteDataSource {
  /// Get current user profile.
  Future<UserProfile> getProfile();

  /// Update user profile.
  Future<UserProfile> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
  });
}

/// Implementation of [ProfileRemoteDataSource].
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio _dio;

  const ProfileRemoteDataSourceImpl({
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
  Future<UserProfile> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
  }) async {
    try {
      final requestData = {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone': phone,
      };

      developer.log(
        'PUT /users/me/ - Request: $requestData',
        name: 'ProfileRemoteDataSource',
      );

      final response = await _dio.put(
        '/users/me/',
        data: requestData,
      );

      developer.log(
        'PUT /users/me/ - Response status: ${response.statusCode}, data: ${response.data}',
        name: 'ProfileRemoteDataSource',
      );

      if (response.statusCode == 200) {
        return UserProfile.fromJson(response.data as Map<String, dynamic>);
      }

      throw ServerExceptions(
        message: 'Failed to update profile',
        statusCode: response.statusCode ?? 500,
      );
    } on DioException catch (e) {
      developer.log(
        'PUT /users/me/ - DioException: ${e.message}, response: ${e.response?.data}',
        name: 'ProfileRemoteDataSource',
        error: e,
      );
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
      String message = 'Noto\'g\'ri so\'rov';

      if (errorData != null) {
        // Check for standard error messages
        if (errorData.containsKey('detail')) {
          message = errorData['detail'] as String;
        } else if (errorData.containsKey('message')) {
          message = errorData['message'] as String;
        } else {
          // Parse field validation errors like {email: [Enter a valid email address.]}
          final fieldErrors = <String>[];
          errorData.forEach((key, value) {
            if (value is List && value.isNotEmpty) {
              final fieldName = _getFieldDisplayName(key);
              fieldErrors.add('$fieldName: ${value.first}');
            } else if (value is String) {
              final fieldName = _getFieldDisplayName(key);
              fieldErrors.add('$fieldName: $value');
            }
          });
          if (fieldErrors.isNotEmpty) {
            message = fieldErrors.join('\n');
          }
        }
      }

      return ServerExceptions(
        message: message,
        statusCode: 400,
      );
    }

    return NetworkException(e.message ?? 'Noma\'lum xatolik');
  }

  /// Get user-friendly field name for validation errors.
  String _getFieldDisplayName(String fieldName) {
    const fieldNames = {
      'first_name': 'Ism',
      'last_name': 'Familiya',
      'email': 'Email',
      'phone': 'Telefon',
      'avatar': 'Rasm',
      'username': 'Foydalanuvchi nomi',
    };
    return fieldNames[fieldName] ?? fieldName;
  }
}
