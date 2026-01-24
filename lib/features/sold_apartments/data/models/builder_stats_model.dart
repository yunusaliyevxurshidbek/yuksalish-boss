import 'package:equatable/equatable.dart';

/// Builder statistics model from /projects/builder/stats/ API
class BuilderStats extends Equatable {
  final int totalProjects;
  final int activeProjects;
  final int completedProjects;
  final int totalUnits;
  final int availableUnits;
  final int reservedUnits;
  final int soldUnits;
  final double totalValue;
  final double soldValue;
  final int totalViews;
  final int totalLikes;

  const BuilderStats({
    required this.totalProjects,
    required this.activeProjects,
    required this.completedProjects,
    required this.totalUnits,
    required this.availableUnits,
    required this.reservedUnits,
    required this.soldUnits,
    required this.totalValue,
    required this.soldValue,
    required this.totalViews,
    required this.totalLikes,
  });

  factory BuilderStats.fromJson(Map<String, dynamic> json) {
    return BuilderStats(
      totalProjects: json['total_projects'] as int? ?? 0,
      activeProjects: json['active_projects'] as int? ?? 0,
      completedProjects: json['completed_projects'] as int? ?? 0,
      totalUnits: json['total_units'] as int? ?? 0,
      availableUnits: json['available_units'] as int? ?? 0,
      reservedUnits: json['reserved_units'] as int? ?? 0,
      soldUnits: json['sold_units'] as int? ?? 0,
      totalValue: _parseDouble(json['total_value']),
      soldValue: _parseDouble(json['sold_value']),
      totalViews: json['total_views'] as int? ?? 0,
      totalLikes: json['total_likes'] as int? ?? 0,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// Calculate sold percentage
  double get soldPercentage {
    if (totalUnits == 0) return 0.0;
    return (soldUnits / totalUnits) * 100;
  }

  /// Calculate average unit price
  double get averageUnitPrice {
    if (soldUnits == 0) return 0.0;
    return soldValue / soldUnits;
  }

  @override
  List<Object?> get props => [
        totalProjects,
        activeProjects,
        completedProjects,
        totalUnits,
        availableUnits,
        reservedUnits,
        soldUnits,
        totalValue,
        soldValue,
        totalViews,
        totalLikes,
      ];
}
