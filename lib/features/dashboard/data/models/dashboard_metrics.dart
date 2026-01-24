import 'package:equatable/equatable.dart';

/// Dashboard metrics model containing key performance indicators
class DashboardMetrics extends Equatable {
  final double totalRevenue;
  final double revenueChange;
  final int activeLeads;
  final double leadsChange;
  final int soldApartments;
  final double soldChange;
  final double conversionRate;
  final double conversionChange;

  const DashboardMetrics({
    required this.totalRevenue,
    required this.revenueChange,
    required this.activeLeads,
    required this.leadsChange,
    required this.soldApartments,
    required this.soldChange,
    required this.conversionRate,
    required this.conversionChange,
  });

  factory DashboardMetrics.empty() => const DashboardMetrics(
        totalRevenue: 0,
        revenueChange: 0,
        activeLeads: 0,
        leadsChange: 0,
        soldApartments: 0,
        soldChange: 0,
        conversionRate: 0,
        conversionChange: 0,
      );

  DashboardMetrics copyWith({
    double? totalRevenue,
    double? revenueChange,
    int? activeLeads,
    double? leadsChange,
    int? soldApartments,
    double? soldChange,
    double? conversionRate,
    double? conversionChange,
  }) {
    return DashboardMetrics(
      totalRevenue: totalRevenue ?? this.totalRevenue,
      revenueChange: revenueChange ?? this.revenueChange,
      activeLeads: activeLeads ?? this.activeLeads,
      leadsChange: leadsChange ?? this.leadsChange,
      soldApartments: soldApartments ?? this.soldApartments,
      soldChange: soldChange ?? this.soldChange,
      conversionRate: conversionRate ?? this.conversionRate,
      conversionChange: conversionChange ?? this.conversionChange,
    );
  }

  @override
  List<Object?> get props => [
        totalRevenue,
        revenueChange,
        activeLeads,
        leadsChange,
        soldApartments,
        soldChange,
        conversionRate,
        conversionChange,
      ];
}
