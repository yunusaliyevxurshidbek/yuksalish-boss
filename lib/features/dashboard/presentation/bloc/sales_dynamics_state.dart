import 'package:equatable/equatable.dart';

import '../../../sold_apartments/data/models/builder_stats_model.dart';
import '../../data/models/crm_stats_model.dart';
import '../../data/models/overdue_payment_model.dart';

/// Period options for sales dynamics
enum SalesDynamicsPeriod {
  thisMonth('this_month', 'sales_period_this_month'),
  lastQuarter('last_quarter', 'sales_period_last_quarter'),
  yearToDate('year_to_date', 'sales_period_year_to_date');

  final String apiValue;
  final String translationKey;
  const SalesDynamicsPeriod(this.apiValue, this.translationKey);
}

enum SalesDynamicsStatus { initial, loading, loaded, error }

class SalesDynamicsState extends Equatable {
  final SalesDynamicsStatus status;
  final SalesDynamicsPeriod selectedPeriod;
  final CrmStatsModel? crmStats;
  final BuilderStats? builderStats;
  final List<OverduePaymentModel> overduePayments;
  final String? errorMessage;
  final bool isRefreshing;

  const SalesDynamicsState({
    this.status = SalesDynamicsStatus.initial,
    this.selectedPeriod = SalesDynamicsPeriod.thisMonth,
    this.crmStats,
    this.builderStats,
    this.overduePayments = const [],
    this.errorMessage,
    this.isRefreshing = false,
  });

  // Helper getters
  bool get isLoading => status == SalesDynamicsStatus.loading;
  bool get isLoaded => status == SalesDynamicsStatus.loaded;
  bool get hasError => status == SalesDynamicsStatus.error;
  bool get hasData => crmStats != null;

  // Revenue getters
  double get totalRevenue => crmStats?.totalRevenue ?? 0;
  double get revenueTrend => crmStats?.revenueTrend ?? 0;
  int get apartmentsSold => crmStats?.apartmentsSold ?? 0;
  double get apartmentsTrend => crmStats?.apartmentsTrend ?? 0;
  int get completedContracts => crmStats?.completedContracts ?? 0;
  double get conversionRate => crmStats?.conversionRate ?? 0;
  double get conversionTrend => crmStats?.conversionTrend ?? 0;

  // Payment getters
  double get totalPaid => crmStats?.totalPaid ?? 0;
  double get pendingPayments => crmStats?.pendingPayments ?? 0;
  double get overduePaymentsTotal => crmStats?.overduePayments ?? 0;
  double get totalPayments => totalPaid + pendingPayments + overduePaymentsTotal;

  // Monthly sales
  List<MonthlySalesModel> get monthlySales => crmStats?.monthlySales ?? [];

  // Leads by stage (for funnel)
  Map<String, int> get leadsByStage => crmStats?.leadsByStage ?? {};
  int get totalLeads =>
      leadsByStage.values.fold<int>(0, (sum, count) => sum + count);

  // Contracts by status
  Map<String, int> get contractsByStatus => crmStats?.contractsByStatus ?? {};

  // Builder stats
  int get totalUnits => builderStats?.totalUnits ?? 0;
  int get availableUnits => builderStats?.availableUnits ?? 0;
  int get reservedUnits => builderStats?.reservedUnits ?? 0;
  int get soldUnits => builderStats?.soldUnits ?? 0;
  double get soldValue => builderStats?.soldValue ?? 0;

  SalesDynamicsState copyWith({
    SalesDynamicsStatus? status,
    SalesDynamicsPeriod? selectedPeriod,
    CrmStatsModel? crmStats,
    BuilderStats? builderStats,
    List<OverduePaymentModel>? overduePayments,
    String? errorMessage,
    bool? isRefreshing,
  }) {
    return SalesDynamicsState(
      status: status ?? this.status,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      crmStats: crmStats ?? this.crmStats,
      builderStats: builderStats ?? this.builderStats,
      overduePayments: overduePayments ?? this.overduePayments,
      errorMessage: errorMessage,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [
        status,
        selectedPeriod,
        crmStats,
        builderStats,
        overduePayments,
        errorMessage,
        isRefreshing,
      ];
}
