import 'package:dio/dio.dart';
import 'package:yuksalish_mobile/core/error/exceptions.dart';
import '../../models/register/register_request_model.dart';
import '../../models/register/register_response_model.dart';

abstract class RegisterRemoteDataSource {
  Future<RegisterResponseModel> sendRegisterCode({
    required String phone,
    required String source,
  });
}

class RegisterRemoteDataSourceImpl implements RegisterRemoteDataSource {
  final Dio _dio;

  RegisterRemoteDataSourceImpl(this._dio);

  @override
  Future<RegisterResponseModel> sendRegisterCode({
    required String phone,
    required String source,
  }) async {
    final request = RegisterRequestModel(
      phone: phone,
      source: source,
    );

    try {
      final response = await _dio.post(
        'users/send-otp/',
        data: request.toJson(),
      );
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return RegisterResponseModel.fromJson(data);
      }
      throw ServerExceptions(
        message: 'Unexpected response format.',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      if (e.response == null) {
        throw NetworkException('Please check your internet connection.');
      }
      final data = e.response?.data;
      final message = _extractMessage(data);
      final errorCode = _extractErrorCode(data, message);
      throw ServerExceptions(
        message: message,
        statusCode: e.response?.statusCode,
        errorCode: errorCode,
      );
    }
  }

  String? _extractErrorCode(dynamic data, String message) {
    if (data is Map<String, dynamic>) {
      final code = data['error_code'] ?? data['code'];
      if (code is String && code.isNotEmpty) {
        return code;
      }
    }
    final lower = message.toLowerCase();
    if (lower.contains('already registered') ||
        lower.contains('already exists') ||
        lower.contains('phone exists') ||
        lower.contains('phone_exists') ||
        lower.contains('user_exists') ||
        lower.contains('already_registered')) {
      return 'PHONE_EXISTS';
    }
    return null;
  }

  String _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
      final detail = data['detail'];
      if (detail is String && detail.isNotEmpty) {
        return detail;
      }
      final error = data['error'];
      if (error is String && error.isNotEmpty) {
        return error;
      }
      final errors = data['errors'];
      final errorMessage = _firstErrorFrom(errors);
      if (errorMessage != null) {
        return errorMessage;
      }
      final nonFieldErrors = data['non_field_errors'];
      final nonFieldMessage = _firstErrorFrom(nonFieldErrors);
      if (nonFieldMessage != null) {
        return nonFieldMessage;
      }
      final phoneErrors = data['phone'];
      final phoneMessage = _firstErrorFrom(phoneErrors);
      if (phoneMessage != null) {
        return phoneMessage;
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
