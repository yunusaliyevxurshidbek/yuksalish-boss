import 'package:dio/dio.dart';

import '../models/apartment_model.dart';

/// Remote data source for apartments
abstract class ApartmentsRemoteDataSource {
  /// Get apartments list with optional filters
  Future<ApartmentsPaginatedResponse> getApartments({
    int page = 1,
    int? projectId,
    String? block,
    int? floor,
    ApartmentStatus? status,
    int? rooms,
    String? ordering,
  });

  /// Get sold apartments only
  Future<ApartmentsPaginatedResponse> getSoldApartments({int page = 1});

  /// Get all sold apartments (fetches all pages)
  Future<List<Apartment>> getAllSoldApartments();

  /// Get block apartments
  Future<BlockApartmentsResponse> getBlockApartments({
    required int projectId,
    required String blockName,
    double? minPrice,
    double? maxPrice,
    double? minArea,
    double? maxArea,
    int? rooms,
    ApartmentStatus? status,
  });

  /// Update apartment status
  Future<Apartment> updateApartmentStatus({
    required int apartmentId,
    required ApartmentStatus status,
  });
}

class ApartmentsRemoteDataSourceImpl implements ApartmentsRemoteDataSource {
  final Dio _dio;

  ApartmentsRemoteDataSourceImpl(this._dio);

  @override
  Future<ApartmentsPaginatedResponse> getApartments({
    int page = 1,
    int? projectId,
    String? block,
    int? floor,
    ApartmentStatus? status,
    int? rooms,
    String? ordering,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
    };

    if (projectId != null) queryParams['project'] = projectId;
    if (block != null) queryParams['block'] = block;
    if (floor != null) queryParams['floor'] = floor;
    if (status != null) queryParams['status'] = status.name;
    if (rooms != null) queryParams['rooms'] = rooms;
    if (ordering != null) queryParams['ordering'] = ordering;

    final response = await _dio.get(
      '/projects/apartments/',
      queryParameters: queryParams,
    );
    return ApartmentsPaginatedResponse.fromJson(
        response.data as Map<String, dynamic>);
  }

  @override
  Future<ApartmentsPaginatedResponse> getSoldApartments({int page = 1}) async {
    return getApartments(page: page, status: ApartmentStatus.sold);
  }

  @override
  Future<List<Apartment>> getAllSoldApartments() async {
    final List<Apartment> allApartments = [];
    int page = 1;
    bool hasMore = true;

    while (hasMore) {
      final response = await getSoldApartments(page: page);
      allApartments.addAll(response.results);
      hasMore = response.hasNextPage;
      page++;
    }

    return allApartments;
  }

  @override
  Future<BlockApartmentsResponse> getBlockApartments({
    required int projectId,
    required String blockName,
    double? minPrice,
    double? maxPrice,
    double? minArea,
    double? maxArea,
    int? rooms,
    ApartmentStatus? status,
  }) async {
    final queryParams = <String, dynamic>{};

    if (minPrice != null) queryParams['min_price'] = minPrice;
    if (maxPrice != null) queryParams['max_price'] = maxPrice;
    if (minArea != null) queryParams['min_area'] = minArea;
    if (maxArea != null) queryParams['max_area'] = maxArea;
    if (rooms != null) queryParams['rooms'] = rooms;
    if (status != null) queryParams['status'] = status.name;

    final response = await _dio.get(
      '/projects/$projectId/block/$blockName/',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    return BlockApartmentsResponse.fromJson(
        response.data as Map<String, dynamic>);
  }

  @override
  Future<Apartment> updateApartmentStatus({
    required int apartmentId,
    required ApartmentStatus status,
  }) async {
    final response = await _dio.patch(
      '/projects/apartments/$apartmentId/',
      data: {'status': status.name},
    );
    return Apartment.fromJson(response.data as Map<String, dynamic>);
  }
}
