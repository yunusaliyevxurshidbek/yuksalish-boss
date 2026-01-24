import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../models/crm_stats_model.dart';
import '../repositories/dashboard_repository.dart';

abstract class CrmStatsRemoteDataSource {
  Future<CrmStatsModel> getStats(DashboardPeriod period);
}

class CrmStatsRemoteDataSourceImpl implements CrmStatsRemoteDataSource {
  final Dio _dio;

  CrmStatsRemoteDataSourceImpl(this._dio);

  @override
  Future<CrmStatsModel> getStats(DashboardPeriod period) async {
    try {
      final periodString = _periodToApiString(period);
      final response = await _dio.get(
        'crm/stats/',
        queryParameters: {'period': periodString},
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return CrmStatsModel.fromJson(data);
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

  String _periodToApiString(DashboardPeriod period) {
    switch (period) {
      case DashboardPeriod.today:
        return 'today';
      case DashboardPeriod.week:
        return 'this_week';
      case DashboardPeriod.month:
        return 'this_month';
      case DashboardPeriod.quarter:
        return 'last_quarter';
      case DashboardPeriod.year:
        return 'year_to_date';
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
