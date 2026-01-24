import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../models/logout_all_request_model.dart';
import '../models/register_device_request_model.dart';
import '../models/user_device_model.dart';

/// Abstract data source for device management API operations.
abstract class DeviceRemoteDataSource {
  /// Registers or updates the current device.
  ///
  /// POST /users/devices/
  Future<UserDeviceModel> registerDevice(RegisterDeviceRequestModel request);

  /// Gets all devices for the current user.
  ///
  /// GET /users/devices/
  /// Headers: X-Device-ID
  Future<List<UserDeviceModel>> getUserDevices(String currentDeviceId);

  /// Terminates a specific device session.
  ///
  /// DELETE /users/devices/{id}/
  Future<void> terminateSession(int deviceId);

  /// Logs out from all devices.
  ///
  /// POST /users/devices/logout-all/
  /// Headers: X-Device-ID
  Future<void> logoutAllDevices({
    required String currentDeviceId,
    required LogoutAllRequestModel request,
  });
}

class DeviceRemoteDataSourceImpl implements DeviceRemoteDataSource {
  final Dio _dio;

  DeviceRemoteDataSourceImpl(this._dio);

  @override
  Future<UserDeviceModel> registerDevice(
    RegisterDeviceRequestModel request,
  ) async {
    try {
      final response = await _dio.post(
        'users/devices/',
        data: request.toJson(),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return UserDeviceModel.fromJson(data);
      }

      throw ServerExceptions(
        message: 'Unexpected response format.',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<List<UserDeviceModel>> getUserDevices(String currentDeviceId) async {
    try {
      final response = await _dio.get(
        'users/devices/',
        options: Options(
          headers: {'X-Device-ID': currentDeviceId},
        ),
      );

      final data = response.data;

      // Handle paginated response
      if (data is Map<String, dynamic>) {
        final results = data['results'];
        if (results is List) {
          return results
              .whereType<Map<String, dynamic>>()
              .map((json) => UserDeviceModel.fromJson(json))
              .toList();
        }
      }

      // Handle direct list response
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map((json) => UserDeviceModel.fromJson(json))
            .toList();
      }

      return [];
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> terminateSession(int deviceId) async {
    try {
      await _dio.delete('users/devices/$deviceId/');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> logoutAllDevices({
    required String currentDeviceId,
    required LogoutAllRequestModel request,
  }) async {
    try {
      await _dio.post(
        'users/devices/logout-all/',
        data: request.toJson(),
        options: Options(
          headers: {'X-Device-ID': currentDeviceId},
        ),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    if (e.response == null) {
      return NetworkException('Please check your internet connection.');
    }

    final message = _extractMessage(e.response?.data);
    return ServerExceptions(
      message: message,
      statusCode: e.response?.statusCode,
    );
  }

  String _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      // Check for 'message' field
      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }

      // Check for 'detail' field
      final detail = data['detail'];
      if (detail is String && detail.isNotEmpty) {
        return detail;
      }

      // Check for 'errors' field
      final errors = data['errors'];
      final errorMessage = _firstErrorFrom(errors);
      if (errorMessage != null) {
        return errorMessage;
      }
    }

    if (data is List) {
      final errorMessage = _firstErrorFrom(data);
      if (errorMessage != null) {
        return errorMessage;
      }
    }

    return 'Something went wrong. Please try again.';
  }

  String? _firstErrorFrom(dynamic errors) {
    if (errors is List && errors.isNotEmpty) {
      final first = errors.first;
      if (first is String && first.isNotEmpty) {
        return first;
      }
    }

    if (errors is Map) {
      for (final value in errors.values) {
        if (value is List && value.isNotEmpty) {
          final first = value.first;
          if (first is String && first.isNotEmpty) {
            return first;
          }
        } else if (value is String && value.isNotEmpty) {
          return value;
        }
      }
    }

    return null;
  }
}
