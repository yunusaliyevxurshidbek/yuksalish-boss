import 'package:dio/dio.dart';
import 'package:yuksalish_mobile/core/error/exceptions.dart';
import '../../models/forgot_password/forgot_password_request_model.dart';
import '../../models/forgot_password/forgot_password_response_model.dart';

abstract class ForgotPasswordRemoteDataSource {
  Future<ForgotPasswordResponseModel> sendForgotPasswordCode({
    required String phone,
    required String source,
  });
}

class ForgotPasswordRemoteDataSourceImpl implements ForgotPasswordRemoteDataSource {
  final Dio _dio;

  ForgotPasswordRemoteDataSourceImpl(this._dio);

  @override
  Future<ForgotPasswordResponseModel> sendForgotPasswordCode({
    required String phone,
    required String source,
  }) async {
    final request = ForgotPasswordRequestModel(
      phone: phone,
      source: source,
    );

    try {
      final response = await _dio.post(
        'users/forgot-password/',
        data: request.toJson(),
      );
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return ForgotPasswordResponseModel.fromJson(data);
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
    }
    return 'Something went wrong. Please try again.';
  }
}
