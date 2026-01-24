import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../models/models.dart';

/// Abstract class for projects remote data source.
abstract class ProjectsRemoteDataSource {
  /// Get list of all projects.
  /// GET /projects/
  Future<List<Project>> getProjects();

  /// Get project details by ID.
  /// GET /projects/{id}/
  Future<Project> getProjectById(int id);

  /// Get paginated list of apartments for a project.
  /// GET /projects/apartments/?project={projectId}&status={status}&rooms={rooms}
  Future<ApartmentsPaginatedResponse> getApartments({
    required int projectId,
    String? status,
    int? rooms,
    String? ordering,
    int page = 1,
  });

  /// Get apartment details by ID.
  /// GET /projects/apartments/{id}/
  Future<Apartment> getApartmentById(int id);

  /// Get builder history for a project.
  /// GET /projects/builder-history/?project={projectId}
  Future<List<BuilderHistoryModel>> getBuilderHistory(int projectId);

  /// Update apartment status.
  /// PATCH /projects/apartments/{id}/
  Future<Apartment> updateApartmentStatus(int apartmentId, String newStatus);
}

/// Implementation of ProjectsRemoteDataSource.
class ProjectsRemoteDataSourceImpl implements ProjectsRemoteDataSource {
  final Dio _dio;

  ProjectsRemoteDataSourceImpl(this._dio);

  @override
  Future<List<Project>> getProjects() async {
    try {
      final response = await _dio.get('projects/');

      final data = response.data;

      // Handle paginated response format: {count, next, previous, results}
      if (data is Map<String, dynamic> && data.containsKey('results')) {
        final results = data['results'] as List;
        return results
            .map((e) => Project.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      // Handle direct list response
      if (data is List) {
        return data
            .map((e) => Project.fromJson(e as Map<String, dynamic>))
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

  @override
  Future<Project> getProjectById(int id) async {
    try {
      final response = await _dio.get('projects/$id/');

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return Project.fromJson(data);
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
  Future<ApartmentsPaginatedResponse> getApartments({
    required int projectId,
    String? status,
    int? rooms,
    String? ordering,
    int page = 1,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'project': projectId,
        'page': page,
      };

      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }
      if (rooms != null && rooms > 0) {
        queryParams['rooms'] = rooms;
      }
      if (ordering != null && ordering.isNotEmpty) {
        queryParams['ordering'] = ordering;
      }

      final response = await _dio.get(
        'projects/apartments/',
        queryParameters: queryParams,
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return ApartmentsPaginatedResponse.fromJson(data);
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
  Future<Apartment> getApartmentById(int id) async {
    try {
      final response = await _dio.get('projects/apartments/$id/');

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return Apartment.fromJson(data);
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
  Future<List<BuilderHistoryModel>> getBuilderHistory(int projectId) async {
    try {
      final response = await _dio.get(
        'projects/builder-history/',
        queryParameters: {'project': projectId},
      );

      final data = response.data;
      if (data is List) {
        return data
            .map((e) => BuilderHistoryModel.fromJson(e as Map<String, dynamic>))
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

  @override
  Future<Apartment> updateApartmentStatus(
    int apartmentId,
    String newStatus,
  ) async {
    try {
      final response = await _dio.patch(
        'projects/apartments/$apartmentId/',
        data: {'status': newStatus},
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return Apartment.fromJson(data);
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
