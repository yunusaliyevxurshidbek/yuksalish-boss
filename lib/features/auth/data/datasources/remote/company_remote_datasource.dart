import 'package:dio/dio.dart';

import '../../../../../core/error/exceptions.dart';
import '../../models/company/company_model.dart';

abstract class CompanyRemoteDataSource {
  Future<List<CompanyModel>> getMyCompanies();
}

class CompanyRemoteDataSourceImpl implements CompanyRemoteDataSource {
  final Dio _dio;

  CompanyRemoteDataSourceImpl(this._dio);

  @override
  Future<List<CompanyModel>> getMyCompanies() async {
    try {
      final response = await _dio.get('companies/my_companies/');

      final data = response.data;
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map((json) => CompanyModel.fromJson(json))
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
