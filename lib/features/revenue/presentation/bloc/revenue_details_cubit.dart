import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/exceptions.dart';
import '../../../dashboard/data/datasources/crm_stats_remote_datasource.dart';
import '../../../dashboard/data/repositories/dashboard_repository.dart';
import '../../data/datasources/contracts_remote_datasource.dart';
import '../../data/models/contract_model.dart';
import 'revenue_details_state.dart';

class RevenueDetailsCubit extends Cubit<RevenueDetailsState> {
  final CrmStatsRemoteDataSource _statsDataSource;
  final ContractsRemoteDataSource _contractsDataSource;

  RevenueDetailsCubit({
    required CrmStatsRemoteDataSource statsDataSource,
    required ContractsRemoteDataSource contractsDataSource,
  })  : _statsDataSource = statsDataSource,
        _contractsDataSource = contractsDataSource,
        super(RevenueDetailsState.initial());

  Future<void> loadRevenueDetails() async {
    emit(state.copyWith(status: RevenueDetailsStatus.loading));

    try {
      // Fetch stats and contracts in parallel
      final results = await Future.wait([
        _statsDataSource.getStats(DashboardPeriod.year),
        _contractsDataSource.getAllContracts(),
      ]);

      final statsModel = results[0] as dynamic;
      final contracts = results[1] as List<Contract>;

      // Calculate average deal value from completed contracts
      final completedContracts = contracts
          .where((c) => c.status == ContractStatus.completed)
          .toList();
      final totalCompletedAmount = completedContracts.fold<double>(
        0,
        (sum, c) => sum + c.totalAmount,
      );
      final averageDealValue = completedContracts.isNotEmpty
          ? totalCompletedAmount / completedContracts.length
          : 0.0;

      final revenueStats = RevenueStats(
        totalRevenue: statsModel.totalRevenue,
        revenueTrend: statsModel.revenueTrend,
        completedContracts: statsModel.completedContracts,
        averageDealValue: averageDealValue,
        overduePayments: statsModel.overduePayments,
        totalPaid: statsModel.totalPaid,
        pendingPayments: statsModel.pendingPayments,
        monthlySales: statsModel.monthlySales,
      );

      emit(state.copyWith(
        status: RevenueDetailsStatus.loaded,
        stats: revenueStats,
      ));
    } on NetworkException catch (e) {
      emit(state.copyWith(
        status: RevenueDetailsStatus.error,
        errorMessage: e.message,
      ));
    } on ServerExceptions catch (e) {
      emit(state.copyWith(
        status: RevenueDetailsStatus.error,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: RevenueDetailsStatus.error,
        errorMessage: null,
      ));
    }
  }

  Future<void> refresh() async {
    await loadRevenueDetails();
  }
}
