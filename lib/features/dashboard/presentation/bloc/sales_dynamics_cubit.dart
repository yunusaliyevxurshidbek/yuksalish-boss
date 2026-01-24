import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../sold_apartments/data/datasources/builder_stats_remote_datasource.dart';
import '../../../sold_apartments/data/models/builder_stats_model.dart';
import '../../data/datasources/crm_stats_remote_datasource.dart';
import '../../data/datasources/overdue_payments_remote_datasource.dart';
import '../../data/models/crm_stats_model.dart';
import '../../data/models/overdue_payment_model.dart';
import '../../data/repositories/dashboard_repository.dart';
import 'sales_dynamics_state.dart';

class SalesDynamicsCubit extends Cubit<SalesDynamicsState> {
  final CrmStatsRemoteDataSource _crmStatsDataSource;
  final BuilderStatsRemoteDataSource _builderStatsDataSource;
  final OverduePaymentsRemoteDataSource _overduePaymentsDataSource;

  SalesDynamicsCubit({
    required CrmStatsRemoteDataSource crmStatsDataSource,
    required BuilderStatsRemoteDataSource builderStatsDataSource,
    required OverduePaymentsRemoteDataSource overduePaymentsDataSource,
  })  : _crmStatsDataSource = crmStatsDataSource,
        _builderStatsDataSource = builderStatsDataSource,
        _overduePaymentsDataSource = overduePaymentsDataSource,
        super(const SalesDynamicsState());

  Future<void> loadData() async {
    emit(state.copyWith(status: SalesDynamicsStatus.loading));

    try {
      final period = _mapPeriodToDashboardPeriod(state.selectedPeriod);

      // Fetch all data in parallel
      final crmStatsFuture = _crmStatsDataSource.getStats(period);
      final builderStatsFuture = _builderStatsDataSource.getBuilderStats();
      final overduePaymentsFuture = _overduePaymentsDataSource.getOverduePayments();

      final CrmStatsModel crmStats = await crmStatsFuture;
      final BuilderStats builderStats = await builderStatsFuture;
      final List<OverduePaymentModel> overduePayments = await overduePaymentsFuture;

      emit(state.copyWith(
        status: SalesDynamicsStatus.loaded,
        crmStats: crmStats,
        builderStats: builderStats,
        overduePayments: overduePayments,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SalesDynamicsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> refresh() async {
    emit(state.copyWith(isRefreshing: true));

    try {
      final period = _mapPeriodToDashboardPeriod(state.selectedPeriod);

      final crmStatsFuture = _crmStatsDataSource.getStats(period);
      final builderStatsFuture = _builderStatsDataSource.getBuilderStats();
      final overduePaymentsFuture = _overduePaymentsDataSource.getOverduePayments();

      final CrmStatsModel crmStats = await crmStatsFuture;
      final BuilderStats builderStats = await builderStatsFuture;
      final List<OverduePaymentModel> overduePayments = await overduePaymentsFuture;

      emit(state.copyWith(
        status: SalesDynamicsStatus.loaded,
        crmStats: crmStats,
        builderStats: builderStats,
        overduePayments: overduePayments,
        isRefreshing: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SalesDynamicsStatus.error,
        errorMessage: e.toString(),
        isRefreshing: false,
      ));
    }
  }

  void changePeriod(SalesDynamicsPeriod period) {
    if (period != state.selectedPeriod) {
      emit(state.copyWith(selectedPeriod: period));
      loadData();
    }
  }

  DashboardPeriod _mapPeriodToDashboardPeriod(SalesDynamicsPeriod period) {
    switch (period) {
      case SalesDynamicsPeriod.thisMonth:
        return DashboardPeriod.month;
      case SalesDynamicsPeriod.lastQuarter:
        return DashboardPeriod.quarter;
      case SalesDynamicsPeriod.yearToDate:
        return DashboardPeriod.year;
    }
  }
}
