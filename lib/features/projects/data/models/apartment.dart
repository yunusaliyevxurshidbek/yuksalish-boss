import 'package:flutter/material.dart';

/// Apartment status enum matching API values.
enum ApartmentStatus {
  available,
  reserved,
  sold,
  notForSale,
  handedOver,
}

/// Extension to get display text and colors for apartment status.
extension ApartmentStatusExtension on ApartmentStatus {
  String get displayName {
    switch (this) {
      case ApartmentStatus.available:
        return "Bo'sh";
      case ApartmentStatus.reserved:
        return 'Bron';
      case ApartmentStatus.sold:
        return 'Sotilgan';
      case ApartmentStatus.notForSale:
        return 'Sotilmaydi';
      case ApartmentStatus.handedOver:
        return 'Topshirilgan';
    }
  }

  String get badgeLabel {
    switch (this) {
      case ApartmentStatus.available:
        return "BO'SH";
      case ApartmentStatus.reserved:
        return 'BRON';
      case ApartmentStatus.sold:
        return 'SOTILGAN';
      case ApartmentStatus.notForSale:
        return 'SOTILMAYDI';
      case ApartmentStatus.handedOver:
        return 'TOPSHIRILGAN';
    }
  }

  Color get color {
    switch (this) {
      case ApartmentStatus.available:
        return const Color(0xFF27AE60);
      case ApartmentStatus.reserved:
        return const Color(0xFFF39C12);
      case ApartmentStatus.sold:
        return const Color(0xFFE74C3C);
      case ApartmentStatus.notForSale:
        return const Color(0xFF95A5A6);
      case ApartmentStatus.handedOver:
        return const Color(0xFF3498DB);
    }
  }

  Color get backgroundColor {
    switch (this) {
      case ApartmentStatus.available:
        return const Color(0xFFE8F5E9);
      case ApartmentStatus.reserved:
        return const Color(0xFFFFF3E0);
      case ApartmentStatus.sold:
        return const Color(0xFFFFEBEE);
      case ApartmentStatus.notForSale:
        return const Color(0xFFECEFF1);
      case ApartmentStatus.handedOver:
        return const Color(0xFFE3F2FD);
    }
  }

  String get apiValue {
    switch (this) {
      case ApartmentStatus.available:
        return 'available';
      case ApartmentStatus.reserved:
        return 'reserved';
      case ApartmentStatus.sold:
        return 'sold';
      case ApartmentStatus.notForSale:
        return 'not_for_sale';
      case ApartmentStatus.handedOver:
        return 'handed_over';
    }
  }

  static ApartmentStatus fromString(String? value) {
    switch (value) {
      case 'available':
        return ApartmentStatus.available;
      case 'reserved':
        return ApartmentStatus.reserved;
      case 'sold':
        return ApartmentStatus.sold;
      case 'not_for_sale':
        return ApartmentStatus.notForSale;
      case 'handed_over':
        return ApartmentStatus.handedOver;
      default:
        return ApartmentStatus.available;
    }
  }
}

/// Apartment model representing a single unit in a project.
class Apartment {
  final int id;
  final int projectId;
  final String? projectName;
  final String apartmentNumber;
  final String block;
  final int floor;
  final int rooms;
  final double area;
  final double price;
  final double pricePerSqm;
  final String currency;
  final ApartmentStatus status;
  final String? renovationStatus;
  final String? layoutImage;
  final bool isLiveable;

  const Apartment({
    required this.id,
    required this.projectId,
    this.projectName,
    required this.apartmentNumber,
    required this.block,
    required this.floor,
    required this.rooms,
    required this.area,
    required this.price,
    this.pricePerSqm = 0,
    this.currency = 'UZS',
    required this.status,
    this.renovationStatus,
    this.layoutImage,
    this.isLiveable = true,
  });

  /// Parse from API JSON response.
  factory Apartment.fromJson(Map<String, dynamic> json) {
    return Apartment(
      id: json['id'] as int,
      projectId: json['project'] as int,
      projectName: json['project_name'] as String?,
      apartmentNumber: json['apartment_number'] as String? ?? '',
      block: json['block'] as String? ?? 'A',
      floor: json['floor'] as int? ?? 1,
      rooms: json['rooms'] as int? ?? 1,
      area: _parseDouble(json['area']) ?? 0,
      price: _parseDouble(json['price']) ?? 0,
      pricePerSqm: _parseDouble(json['price_per_sqm']) ?? 0,
      currency: json['currency'] as String? ?? 'UZS',
      status: ApartmentStatusExtension.fromString(json['status'] as String?),
      renovationStatus: json['renovation_status'] as String?,
      layoutImage: json['layout_image'] as String?,
      isLiveable: json['is_liveable'] as bool? ?? true,
    );
  }

  /// Convert to JSON for API requests.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project': projectId,
      'project_name': projectName,
      'apartment_number': apartmentNumber,
      'block': block,
      'floor': floor,
      'rooms': rooms,
      'area': area,
      'price': price,
      'price_per_sqm': pricePerSqm,
      'currency': currency,
      'status': status.apiValue,
      'renovation_status': renovationStatus,
      'layout_image': layoutImage,
      'is_liveable': isLiveable,
    };
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  /// Get room display text.
  String get roomsText => '$rooms-xona';

  /// Get floor display text.
  String get floorText => 'Qavat $floor';

  /// Get block and floor display.
  String get blockFloorText => 'Blok $block, Qavat $floor';

  /// Get area display text.
  String get areaText => '${area.toStringAsFixed(0)} m²';

  /// Get renovation status display.
  String get renovationStatusText {
    switch (renovationStatus) {
      case 'renovated':
        return 'Remont qilingan';
      case 'unrenovated':
        return 'Remont qilinmagan';
      case 'semi_renovated':
        return 'Qisman remont';
      default:
        return renovationStatus ?? 'Nomalum';
    }
  }

  Apartment copyWith({
    int? id,
    int? projectId,
    String? projectName,
    String? apartmentNumber,
    String? block,
    int? floor,
    int? rooms,
    double? area,
    double? price,
    double? pricePerSqm,
    String? currency,
    ApartmentStatus? status,
    String? renovationStatus,
    String? layoutImage,
    bool? isLiveable,
  }) {
    return Apartment(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      apartmentNumber: apartmentNumber ?? this.apartmentNumber,
      block: block ?? this.block,
      floor: floor ?? this.floor,
      rooms: rooms ?? this.rooms,
      area: area ?? this.area,
      price: price ?? this.price,
      pricePerSqm: pricePerSqm ?? this.pricePerSqm,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      renovationStatus: renovationStatus ?? this.renovationStatus,
      layoutImage: layoutImage ?? this.layoutImage,
      isLiveable: isLiveable ?? this.isLiveable,
    );
  }
}
