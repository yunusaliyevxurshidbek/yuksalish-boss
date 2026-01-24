import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dashboard/data/datasources/crm_stats_remote_datasource.dart';
import '../../../dashboard/data/repositories/dashboard_repository.dart';
import '../../data/datasources/apartments_remote_datasource.dart';
import '../../data/datasources/builder_stats_remote_datasource.dart';
import '../../data/models/apartment_model.dart';
import 'sold_apartments_state.dart';

class SoldApartmentsCubit extends Cubit<SoldApartmentsState> {
  final CrmStatsRemoteDataSource _crmStatsDataSource;
  final BuilderStatsRemoteDataSource _builderStatsDataSource;
  final ApartmentsRemoteDataSource _apartmentsDataSource;

  SoldApartmentsCubit({
    required CrmStatsRemoteDataSource crmStatsDataSource,
    required BuilderStatsRemoteDataSource builderStatsDataSource,
    required ApartmentsRemoteDataSource apartmentsDataSource,
  })  : _crmStatsDataSource = crmStatsDataSource,
        _builderStatsDataSource = builderStatsDataSource,
        _apartmentsDataSource = apartmentsDataSource,
        super(const SoldApartmentsState());

  Future<void> loadSoldApartmentsData() async {
    emit(state.copyWith(isLoading: true, hasError: false));

    try {
      // Fetch all data in parallel
      final results = await Future.wait([
        _crmStatsDataSource.getStats(DashboardPeriod.year),
        _builderStatsDataSource.getBuilderStats(),
        _apartmentsDataSource.getSoldApartments(page: 1),
      ]);

      final crmStats = results[0] as dynamic;
      final builderStats = results[1] as dynamic;
      final soldApartmentsResponse = results[2] as ApartmentsPaginatedResponse;

      // Calculate room distribution
      final roomDistribution = <int, int>{};
      for (final apartment in soldApartmentsResponse.results) {
        roomDistribution[apartment.rooms] =
            (roomDistribution[apartment.rooms] ?? 0) + 1;
      }

      // Calculate project distribution
      final projectDistribution = <String, int>{};
      for (final apartment in soldApartmentsResponse.results) {
        projectDistribution[apartment.projectName] =
            (projectDistribution[apartment.projectName] ?? 0) + 1;
      }

      // Build the stats
      final stats = SoldApartmentsStats(
        soldCount: builderStats.soldUnits,
        soldValue: builderStats.soldValue,
        averagePrice: builderStats.averageUnitPrice,
        soldPercentage: builderStats.soldPercentage,
        totalUnits: builderStats.totalUnits,
        availableUnits: builderStats.availableUnits,
        reservedUnits: builderStats.reservedUnits,
        activeProjects: builderStats.activeProjects,
        completedProjects: builderStats.completedProjects,
        roomDistribution: roomDistribution,
        projectDistribution: projectDistribution,
        apartmentsTrend: crmStats.apartmentsTrend,
      );

      emit(state.copyWith(
        isLoading: false,
        stats: stats,
        builderStats: builderStats,
        recentSoldApartments: soldApartmentsResponse.results,
        monthlySales: crmStats.monthlySales,
        hasMoreApartments: soldApartmentsResponse.hasNextPage,
        currentPage: 1,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> loadMoreApartments() async {
    if (state.isLoadingMore || !state.hasMoreApartments) return;

    emit(state.copyWith(isLoadingMore: true));

    try {
      final nextPage = state.currentPage + 1;
      final response = await _apartmentsDataSource.getSoldApartments(
        page: nextPage,
      );

      // Update room distribution
      final roomDistribution = Map<int, int>.from(state.stats.roomDistribution);
      for (final apartment in response.results) {
        roomDistribution[apartment.rooms] =
            (roomDistribution[apartment.rooms] ?? 0) + 1;
      }

      // Update project distribution
      final projectDistribution =
          Map<String, int>.from(state.stats.projectDistribution);
      for (final apartment in response.results) {
        projectDistribution[apartment.projectName] =
            (projectDistribution[apartment.projectName] ?? 0) + 1;
      }

      final updatedStats = SoldApartmentsStats(
        soldCount: state.stats.soldCount,
        soldValue: state.stats.soldValue,
        averagePrice: state.stats.averagePrice,
        soldPercentage: state.stats.soldPercentage,
        totalUnits: state.stats.totalUnits,
        availableUnits: state.stats.availableUnits,
        reservedUnits: state.stats.reservedUnits,
        activeProjects: state.stats.activeProjects,
        completedProjects: state.stats.completedProjects,
        roomDistribution: roomDistribution,
        projectDistribution: projectDistribution,
        apartmentsTrend: state.stats.apartmentsTrend,
      );

      emit(state.copyWith(
        isLoadingMore: false,
        stats: updatedStats,
        recentSoldApartments: [
          ...state.recentSoldApartments,
          ...response.results,
        ],
        hasMoreApartments: response.hasNextPage,
        currentPage: nextPage,
      ));
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  Future<void> refresh() async {
    await loadSoldApartmentsData();
  }
}
