import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../models/lead_model.dart';
import '../models/leads_paginated_response.dart';

/// Abstract class for leads remote data source
abstract class LeadsRemoteDataSource {
  /// Get paginated list of leads
  ///
  /// [stage] - Filter by lead stage (new, contacted, qualified, etc.)
  /// [search] - Search query string
  /// [order] - Order by field
  /// [page] - Page number for pagination
  Future<LeadsPaginatedResponse> getLeads({
    LeadStage? stage,
    String? search,
    String? order,
    int page = 1,
  });

  /// Get lead details by ID
  Future<Lead> getLeadById(int id);
}

/// Implementation of LeadsRemoteDataSource
class LeadsRemoteDataSourceImpl implements LeadsRemoteDataSource {
  final Dio _dio;

  LeadsRemoteDataSourceImpl(this._dio);

  @override
  Future<LeadsPaginatedResponse> getLeads({
    LeadStage? stage,
    String? search,
    String? order,
    int page = 1,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
      };

      if (stage != null) {
        queryParams['stage'] = stage.toApiString();
      }
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      if (order != null && order.isNotEmpty) {
        queryParams['ordering'] = order;
      }

      final response = await _dio.get(
        'crm/leads/',
        queryParameters: queryParams,
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return LeadsPaginatedResponse.fromJson(data);
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
  Future<Lead> getLeadById(int id) async {
    try {
      final response = await _dio.get('crm/leads/$id/');

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return Lead.fromJson(data);
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
}
