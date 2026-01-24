import 'package:equatable/equatable.dart';

/// Summary data for analytics screens
class AnalyticsSummary extends Equatable {
  /// Year-to-date revenue in UZS
  final double ytdRevenue;

  /// Number of closed deals
  final int closedDeals;

  /// Average deal size in UZS
  final double avgDealSize;

  /// Total income for Moliya tab
  final double totalIncome;

  /// Total expenses for Moliya tab
  final double totalExpenses;

  /// Total leads count for Lidlar tab
  final int totalLeads;

  /// Overall conversion rate (0-100)
  final double overallConversion;

  /// Revenue change percentage compared to previous period
  final double revenueChange;

  /// Deals change percentage compared to previous period
  final double dealsChange;

  const AnalyticsSummary({
    required this.ytdRevenue,
    required this.closedDeals,
    required this.avgDealSize,
    required this.totalIncome,
    required this.totalExpenses,
    required this.totalLeads,
    required this.overallConversion,
    this.revenueChange = 0,
    this.dealsChange = 0,
  });

  factory AnalyticsSummary.empty() => const AnalyticsSummary(
        ytdRevenue: 0,
        closedDeals: 0,
        avgDealSize: 0,
        totalIncome: 0,
        totalExpenses: 0,
        totalLeads: 0,
        overallConversion: 0,
      );

  /// Net income (income - expenses)
  double get netIncome => totalIncome - totalExpenses;

  /// Format YTD revenue in billions
  String get formattedYtdRevenue {
    if (ytdRevenue >= 1000000000) {
      return '${(ytdRevenue / 1000000000).toStringAsFixed(1)} mlrd';
    } else if (ytdRevenue >= 1000000) {
      return '${(ytdRevenue / 1000000).toStringAsFixed(1)} mln';
    }
    return ytdRevenue.toStringAsFixed(0);
  }

  AnalyticsSummary copyWith({
    double? ytdRevenue,
    int? closedDeals,
    double? avgDealSize,
    double? totalIncome,
    double? totalExpenses,
    int? totalLeads,
    double? overallConversion,
    double? revenueChange,
    double? dealsChange,
  }) {
    return AnalyticsSummary(
      ytdRevenue: ytdRevenue ?? this.ytdRevenue,
      closedDeals: closedDeals ?? this.closedDeals,
      avgDealSize: avgDealSize ?? this.avgDealSize,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      totalLeads: totalLeads ?? this.totalLeads,
      overallConversion: overallConversion ?? this.overallConversion,
      revenueChange: revenueChange ?? this.revenueChange,
      dealsChange: dealsChange ?? this.dealsChange,
    );
  }

  @override
  List<Object?> get props => [
        ytdRevenue,
        closedDeals,
        avgDealSize,
        totalIncome,
        totalExpenses,
        totalLeads,
        overallConversion,
        revenueChange,
        dealsChange,
      ];
}
