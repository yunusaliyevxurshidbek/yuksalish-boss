import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../models/overdue_payment_model.dart';

abstract class OverduePaymentsRemoteDataSource {
  Future<List<OverduePaymentModel>> getOverduePayments();
}

class OverduePaymentsRemoteDataSourceImpl
    implements OverduePaymentsRemoteDataSource {
  final Dio _dio;

  OverduePaymentsRemoteDataSourceImpl(this._dio);

  @override
  Future<List<OverduePaymentModel>> getOverduePayments() async {
    try {
      final response = await _dio.get('crm/payments/overdue/');

      final data = response.data;
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map((json) => OverduePaymentModel.fromJson(json))
            .toList();
      }

      throw ServerExceptions(
        message: 'Unexpected response format.',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      if (e.response == null) {
        throw NetworkException('Internetga ulanishni tekshiring.');
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
    return 'Xatolik yuz berdi. Iltimos, qayta urinib ko\'ring.';
  }
}
