import 'package:equatable/equatable.dart';

/// Apartment status enum
enum ApartmentStatus {
  available,
  reserved,
  sold;

  static ApartmentStatus fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'available':
        return ApartmentStatus.available;
      case 'reserved':
        return ApartmentStatus.reserved;
      case 'sold':
        return ApartmentStatus.sold;
      default:
        return ApartmentStatus.available;
    }
  }

  String get displayName {
    switch (this) {
      case ApartmentStatus.available:
        return 'Mavjud';
      case ApartmentStatus.reserved:
        return 'Band qilingan';
      case ApartmentStatus.sold:
        return 'Sotilgan';
    }
  }
}

/// Renovation status enum
enum RenovationStatus {
  unrenovated,
  renovated;

  static RenovationStatus fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'renovated':
        return RenovationStatus.renovated;
      default:
        return RenovationStatus.unrenovated;
    }
  }

  String get displayName {
    switch (this) {
      case RenovationStatus.unrenovated:
        return 'Ta\'mirsiz';
      case RenovationStatus.renovated:
        return 'Ta\'mirli';
    }
  }
}

/// Apartment model from /projects/apartments/ API
class Apartment extends Equatable {
  final int id;
  final int projectId;
  final String projectName;
  final String apartmentNumber;
  final String block;
  final int floor;
  final int rooms;
  final double area;
  final double price;
  final double pricePerSqm;
  final String currency;
  final ApartmentStatus status;
  final RenovationStatus renovationStatus;
  final String? layoutImage;
  final String? layoutImageUrl;
  final bool isLiveable;

  const Apartment({
    required this.id,
    required this.projectId,
    required this.projectName,
    required this.apartmentNumber,
    required this.block,
    required this.floor,
    required this.rooms,
    required this.area,
    required this.price,
    required this.pricePerSqm,
    required this.currency,
    required this.status,
    required this.renovationStatus,
    this.layoutImage,
    this.layoutImageUrl,
    required this.isLiveable,
  });

  factory Apartment.fromJson(Map<String, dynamic> json) {
    return Apartment(
      id: json['id'] as int? ?? 0,
      projectId: json['project'] as int? ?? 0,
      projectName: json['project_name'] as String? ?? '',
      apartmentNumber: json['apartment_number'] as String? ?? '',
      block: json['block'] as String? ?? '',
      floor: json['floor'] as int? ?? 0,
      rooms: json['rooms'] as int? ?? 0,
      area: _parseDouble(json['area']),
      price: _parseDouble(json['price']),
      pricePerSqm: _parseDouble(json['price_per_sqm']),
      currency: json['currency'] as String? ?? 'UZS',
      status: ApartmentStatus.fromString(json['status'] as String?),
      renovationStatus:
          RenovationStatus.fromString(json['renovation_status'] as String?),
      layoutImage: json['layout_image'] as String?,
      layoutImageUrl: json['layout_image_url'] as String?,
      isLiveable: json['is_liveable'] as bool? ?? false,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  @override
  List<Object?> get props => [
        id,
        projectId,
        projectName,
        apartmentNumber,
        block,
        floor,
        rooms,
        area,
        price,
        pricePerSqm,
        currency,
        status,
        renovationStatus,
        layoutImage,
        layoutImageUrl,
        isLiveable,
      ];
}

/// Paginated response for apartments
class ApartmentsPaginatedResponse extends Equatable {
  final int count;
  final String? next;
  final String? previous;
  final List<Apartment> results;

  const ApartmentsPaginatedResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory ApartmentsPaginatedResponse.fromJson(Map<String, dynamic> json) {
    return ApartmentsPaginatedResponse(
      count: json['count'] as int? ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => Apartment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  bool get hasNextPage => next != null;

  @override
  List<Object?> get props => [count, next, previous, results];
}

/// Filter bounds for apartments
class ApartmentFilterBounds extends Equatable {
  final double minPrice;
  final double maxPrice;
  final double minArea;
  final double maxArea;
  final List<int> rooms;

  const ApartmentFilterBounds({
    required this.minPrice,
    required this.maxPrice,
    required this.minArea,
    required this.maxArea,
    required this.rooms,
  });

  factory ApartmentFilterBounds.fromJson(Map<String, dynamic> json) {
    return ApartmentFilterBounds(
      minPrice: _parseDouble(json['min_price']),
      maxPrice: _parseDouble(json['max_price']),
      minArea: _parseDouble(json['min_area']),
      maxArea: _parseDouble(json['max_area']),
      rooms: (json['rooms'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  @override
  List<Object?> get props => [minPrice, maxPrice, minArea, maxArea, rooms];
}

/// Block apartments response
class BlockApartmentsResponse extends Equatable {
  final String block;
  final List<Apartment> apartments;
  final int total;
  final int available;
  final int reserved;
  final int sold;
  final ApartmentFilterBounds filterBounds;
  final int totalUnfiltered;

  const BlockApartmentsResponse({
    required this.block,
    required this.apartments,
    required this.total,
    required this.available,
    required this.reserved,
    required this.sold,
    required this.filterBounds,
    required this.totalUnfiltered,
  });

  factory BlockApartmentsResponse.fromJson(Map<String, dynamic> json) {
    return BlockApartmentsResponse(
      block: json['block'] as String? ?? '',
      apartments: (json['apartments'] as List<dynamic>?)
              ?.map((e) => Apartment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      total: json['total'] as int? ?? 0,
      available: json['available'] as int? ?? 0,
      reserved: json['reserved'] as int? ?? 0,
      sold: json['sold'] as int? ?? 0,
      filterBounds: json['filter_bounds'] != null
          ? ApartmentFilterBounds.fromJson(
              json['filter_bounds'] as Map<String, dynamic>)
          : const ApartmentFilterBounds(
              minPrice: 0,
              maxPrice: 0,
              minArea: 0,
              maxArea: 0,
              rooms: [],
            ),
      totalUnfiltered: json['total_unfiltered'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        block,
        apartments,
        total,
        available,
        reserved,
        sold,
        filterBounds,
        totalUnfiltered,
      ];
}
