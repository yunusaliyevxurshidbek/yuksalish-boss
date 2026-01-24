import 'package:dio/dio.dart';
import 'package:yuksalish_mobile/core/error/exceptions.dart';
import '../../models/logout/logout_request_model.dart';
import '../../models/logout/logout_response_model.dart';

abstract class LogoutRemoteDataSource {
  Future<LogoutResponseModel> logout({
    required String refreshToken,
  });
}

class LogoutRemoteDataSourceImpl implements LogoutRemoteDataSource {
  final Dio _dio;

  LogoutRemoteDataSourceImpl(this._dio);

  @override
  Future<LogoutResponseModel> logout({
    required String refreshToken,
  }) async {
    final request = LogoutRequestModel(refresh: refreshToken);

    try {
      final response = await _dio.post(
        'users/logout/',
        data: request.toJson(),
      );
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return LogoutResponseModel.fromJson(data);
      }
      throw ServerExceptions(
        message: 'Unexpected response format.',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      if (e.response == null) {
        throw NetworkException('Please check your internet connection.');
      }
      final message = _extractMessage(e.response?.data);
      throw ServerExceptions(
        message: message,
        statusCode: e.response?.statusCode,
      );
    }
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
