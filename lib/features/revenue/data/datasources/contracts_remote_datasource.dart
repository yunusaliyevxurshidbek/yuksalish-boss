import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/error/exceptions.dart';
import '../models/contract_model.dart';

/// Abstract class for contracts remote data source
abstract class ContractsRemoteDataSource {
  /// Get all contracts (paginated)
  Future<ContractsPaginatedResponse> getContracts({int page = 1});

  /// Get all contracts for calculating average (fetches all pages)
  Future<List<Contract>> getAllContracts();
}

/// Implementation of ContractsRemoteDataSource
class ContractsRemoteDataSourceImpl implements ContractsRemoteDataSource {
  final Dio _dio;

  ContractsRemoteDataSourceImpl(this._dio);

  @override
  Future<ContractsPaginatedResponse> getContracts({int page = 1}) async {
    try {
      final response = await _dio.get(
        'crm/contracts/',
        queryParameters: {'page': page},
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return ContractsPaginatedResponse.fromJson(data);
      }

      throw ServerExceptions(
        message: 'common_error'.tr(),
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      if (e.response == null) {
        throw NetworkException('common_no_internet'.tr());
      }
      final message = _extractMessage(e.response?.data);
      throw ServerExceptions(
        message: message,
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<Contract>> getAllContracts() async {
    final allContracts = <Contract>[];
    int page = 1;
    bool hasMore = true;

    while (hasMore) {
      final response = await getContracts(page: page);
      allContracts.addAll(response.results);
      hasMore = response.next != null;
      page++;
    }

    return allContracts;
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
    return 'common_error'.tr();
  }
}
