import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:yuksalish_mobile/features/dashboard/data/models/dashboard_metrics.dart';
import 'package:yuksalish_mobile/features/dashboard/data/models/funnel_data.dart';
import 'package:yuksalish_mobile/features/dashboard/data/models/sales_data.dart';
import 'package:yuksalish_mobile/features/dashboard/data/repositories/dashboard_repository.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository _repository;

  DashboardBloc({required DashboardRepository repository})
      : _repository = repository,
        super(DashboardState.initial()) {
    on<LoadDashboard>(_onLoadDashboard);
    on<RefreshDashboard>(_onRefreshDashboard);
    on<ChangePeriod>(_onChangePeriod);
  }

  Future<void> _onLoadDashboard(
    LoadDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardStatus.loading));

    try {
      final results = await Future.wait([
        _repository.getMetrics(state.selectedPeriod),
        _repository.getSalesData(state.selectedPeriod),
        _repository.getFunnelData(state.selectedPeriod),
      ]);

      emit(state.copyWith(
        status: DashboardStatus.loaded,
        metrics: results[0] as DashboardMetrics,
        salesData: results[1] as List<SalesData>,
        funnelData: results[2] as List<FunnelData>,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: DashboardStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRefreshDashboard(
    RefreshDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isRefreshing: true));

    try {
      final results = await Future.wait([
        _repository.getMetrics(state.selectedPeriod),
        _repository.getSalesData(state.selectedPeriod),
        _repository.getFunnelData(state.selectedPeriod),
      ]);

      emit(state.copyWith(
        status: DashboardStatus.loaded,
        metrics: results[0] as DashboardMetrics,
        salesData: results[1] as List<SalesData>,
        funnelData: results[2] as List<FunnelData>,
        isRefreshing: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: DashboardStatus.error,
        errorMessage: e.toString(),
        isRefreshing: false,
      ));
    }
  }

  Future<void> _onChangePeriod(
    ChangePeriod event,
    Emitter<DashboardState> emit,
  ) async {
    if (event.period == state.selectedPeriod) return;

    emit(state.copyWith(
      selectedPeriod: event.period,
      status: DashboardStatus.loading,
    ));

    try {
      final results = await Future.wait([
        _repository.getMetrics(event.period),
        _repository.getSalesData(event.period),
        _repository.getFunnelData(event.period),
      ]);

      emit(state.copyWith(
        status: DashboardStatus.loaded,
        metrics: results[0] as DashboardMetrics,
        salesData: results[1] as List<SalesData>,
        funnelData: results[2] as List<FunnelData>,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: DashboardStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
