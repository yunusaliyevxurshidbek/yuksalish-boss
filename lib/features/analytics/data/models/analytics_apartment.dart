import 'package:equatable/equatable.dart';

/// Apartment model for analytics inventory and revenue breakdown.
class AnalyticsApartment extends Equatable {
  final int id;
  final int projectId;
  final String projectName;
  final String apartmentNumber;
  final String status;
  final double price;
  final String currency;
  final int rooms;

  const AnalyticsApartment({
    required this.id,
    required this.projectId,
    required this.projectName,
    required this.apartmentNumber,
    required this.status,
    required this.price,
    required this.currency,
    required this.rooms,
  });

  factory AnalyticsApartment.fromJson(Map<String, dynamic> json) {
    return AnalyticsApartment(
      id: json['id'] as int? ?? 0,
      projectId: json['project'] as int? ?? 0,
      projectName: json['project_name'] as String? ?? '',
      apartmentNumber: json['apartment_number'] as String? ?? '',
      status: (json['status'] as String? ?? '').toLowerCase(),
      price: _parseDouble(json['price']),
      currency: json['currency'] as String? ?? 'UZS',
      rooms: json['rooms'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project': projectId,
      'project_name': projectName,
      'apartment_number': apartmentNumber,
      'status': status,
      'price': price,
      'currency': currency,
      'rooms': rooms,
    };
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  @override
  List<Object?> get props => [
        id,
        projectId,
        projectName,
        apartmentNumber,
        status,
        price,
        currency,
        rooms,
      ];
}
