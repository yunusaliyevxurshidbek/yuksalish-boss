import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/error/exceptions.dart';
import '../../../dashboard/data/models/crm_stats_model.dart';
import '../models/analytics_apartment.dart';
import '../models/analytics_client.dart';
import '../models/analytics_contract.dart';
import '../models/analytics_payment.dart';
import '../models/analytics_period.dart';
import '../models/analytics_project.dart';

abstract class AnalyticsRemoteDataSource {
  Future<CrmStatsModel> getStats(AnalyticsPeriod period);
  Future<List<AnalyticsClient>> getClients();
  Future<List<AnalyticsContract>> getContracts();
  Future<List<AnalyticsPayment>> getPayments();
  Future<List<AnalyticsProject>> getProjects();
  Future<List<AnalyticsApartment>> getApartments();
  Future<String> exportPdf(AnalyticsPeriod period);
}

class AnalyticsRemoteDataSourceImpl implements AnalyticsRemoteDataSource {
  final Dio _dio;

  AnalyticsRemoteDataSourceImpl(this._dio);

  @override
  Future<CrmStatsModel> getStats(AnalyticsPeriod period) async {
    try {
      final response = await _dio.get(
        'crm/stats/',
        queryParameters: {'period': period.apiValue},
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

  @override
  Future<List<AnalyticsClient>> getClients() async {
    final raw = await _fetchPaginatedList('crm/clients/');
    return raw.map(AnalyticsClient.fromJson).toList();
  }

  @override
  Future<List<AnalyticsContract>> getContracts() async {
    final raw = await _fetchPaginatedList('crm/contracts/');
    return raw.map(AnalyticsContract.fromJson).toList();
  }

  @override
  Future<List<AnalyticsPayment>> getPayments() async {
    final raw = await _fetchPaginatedList('crm/payments/');
    return raw.map(AnalyticsPayment.fromJson).toList();
  }

  @override
  Future<List<AnalyticsProject>> getProjects() async {
    final raw = await _fetchList('projects/');
    return raw.map(AnalyticsProject.fromJson).toList();
  }

  @override
  Future<List<AnalyticsApartment>> getApartments() async {
    final raw = await _fetchPaginatedList('projects/apartments/');
    return raw.map(AnalyticsApartment.fromJson).toList();
  }

  Future<List<Map<String, dynamic>>> _fetchList(String path) async {
    try {
      final response = await _dio.get(path);
      final data = response.data;
      if (data is List) {
        return data.whereType<Map<String, dynamic>>().toList();
      }
      if (data is Map<String, dynamic>) {
        final results = data['results'];
        if (results is List) {
          return results.whereType<Map<String, dynamic>>().toList();
        }
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

  Future<List<Map<String, dynamic>>> _fetchPaginatedList(String path) async {
    final results = <Map<String, dynamic>>[];
    int page = 1;

    while (true) {
      try {
        final response = await _dio.get(
          path,
          queryParameters: {'page': page},
        );

        final data = response.data;
        if (data is Map<String, dynamic>) {
          final items = data['results'];
          if (items is List) {
            results.addAll(items.whereType<Map<String, dynamic>>());
          }

          final next = data['next'];
          if (next == null) {
            break;
          }
          page++;
          continue;
        }

        if (data is List) {
          return data.whereType<Map<String, dynamic>>().toList();
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

    return results;
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
    return 'Xatolik yuz berdi. Iltimos, qayta urinib ko\'ring.';
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

  @override
  Future<String> exportPdf(AnalyticsPeriod period) async {
    try {
      final response = await _dio.get(
        'crm/stats/export/pdf/',
        queryParameters: {'period': period.apiValue},
        options: Options(responseType: ResponseType.bytes),
      );

      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'analytics_${period.apiValue}_$timestamp.pdf';
      final filePath = '${directory.path}/$fileName';

      final file = File(filePath);
      await file.writeAsBytes(response.data);

      return filePath;
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
}
