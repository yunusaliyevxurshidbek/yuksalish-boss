import 'package:equatable/equatable.dart';

import '../../../dashboard/data/models/crm_stats_model.dart';

enum RevenueDetailsStatus { initial, loading, loaded, error }

/// Model for revenue statistics displayed on the screen
class RevenueStats extends Equatable {
  final double totalRevenue;
  final double revenueTrend;
  final int completedContracts;
  final double averageDealValue;
  final double overduePayments;
  final double totalPaid;
  final double pendingPayments;
  final List<MonthlySalesModel> monthlySales;

  const RevenueStats({
    required this.totalRevenue,
    required this.revenueTrend,
    required this.completedContracts,
    required this.averageDealValue,
    required this.overduePayments,
    required this.totalPaid,
    required this.pendingPayments,
    required this.monthlySales,
  });

  factory RevenueStats.empty() => const RevenueStats(
        totalRevenue: 0,
        revenueTrend: 0,
        completedContracts: 0,
        averageDealValue: 0,
        overduePayments: 0,
        totalPaid: 0,
        pendingPayments: 0,
        monthlySales: [],
      );

  @override
  List<Object?> get props => [
        totalRevenue,
        revenueTrend,
        completedContracts,
        averageDealValue,
        overduePayments,
        totalPaid,
        pendingPayments,
        monthlySales,
      ];
}

class RevenueDetailsState extends Equatable {
  final RevenueDetailsStatus status;
  final RevenueStats stats;
  final String? errorMessage;

  const RevenueDetailsState({
    required this.status,
    required this.stats,
    this.errorMessage,
  });

  factory RevenueDetailsState.initial() => RevenueDetailsState(
        status: RevenueDetailsStatus.initial,
        stats: RevenueStats.empty(),
      );

  RevenueDetailsState copyWith({
    RevenueDetailsStatus? status,
    RevenueStats? stats,
    String? errorMessage,
  }) {
    return RevenueDetailsState(
      status: status ?? this.status,
      stats: stats ?? this.stats,
      errorMessage: errorMessage,
    );
  }

  bool get isLoading => status == RevenueDetailsStatus.loading;
  bool get isLoaded => status == RevenueDetailsStatus.loaded;
  bool get hasError => status == RevenueDetailsStatus.error;

  @override
  List<Object?> get props => [status, stats, errorMessage];
}
