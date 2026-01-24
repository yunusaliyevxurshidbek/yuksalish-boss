import 'package:equatable/equatable.dart';

/// Project model for analytics inventory section.
class AnalyticsProject extends Equatable {
  final int id;
  final String name;
  final int totalUnits;
  final int soldUnits;

  const AnalyticsProject({
    required this.id,
    required this.name,
    required this.totalUnits,
    required this.soldUnits,
  });

  factory AnalyticsProject.fromJson(Map<String, dynamic> json) {
    return AnalyticsProject(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      totalUnits: json['total_units'] as int? ?? 0,
      soldUnits: json['sold_units'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'total_units': totalUnits,
      'sold_units': soldUnits,
    };
  }

  @override
  List<Object?> get props => [id, name, totalUnits, soldUnits];
}
