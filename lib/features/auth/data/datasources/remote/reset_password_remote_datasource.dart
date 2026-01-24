import 'package:dio/dio.dart';
import 'package:yuksalish_mobile/core/error/exceptions.dart';
import '../../models/reset_password/reset_password_request_model.dart';
import '../../models/reset_password/reset_password_response_model.dart';

abstract class ResetPasswordRemoteDataSource {
  Future<ResetPasswordResponseModel> resetPassword({
    required String phone,
    required String code,
    required String newPassword,
  });
}

class ResetPasswordRemoteDataSourceImpl implements ResetPasswordRemoteDataSource {
  final Dio _dio;

  ResetPasswordRemoteDataSourceImpl(this._dio);

  @override
  Future<ResetPasswordResponseModel> resetPassword({
    required String phone,
    required String code,
    required String newPassword,
  }) async {
    final request = ResetPasswordRequestModel(
      phone: phone,
      code: code,
      newPassword: newPassword,
    );

    try {
      final response = await _dio.post(
        'users/reset-password/',
        data: request.toJson(),
      );
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return ResetPasswordResponseModel.fromJson(data);
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
