import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../dashboard/data/models/crm_stats_model.dart';
import '../../data/models/analytics_apartment.dart';
import '../../data/models/analytics_client.dart';
import '../../data/models/analytics_contract.dart';
import '../../data/models/analytics_payment.dart';
import '../../data/models/analytics_period.dart';
import '../../data/models/analytics_project.dart';
import '../../data/repositories/analytics_repository.dart';
import '../../data/services/analytics_pdf_generator.dart';
import '../../../../core/error/exceptions.dart';

part 'analytics_event.dart';
part 'analytics_state.dart';

// Legacy enum for old analytics widgets.
enum AnalyticsTab { sales, finance, leads }

/// BLoC for managing analytics screen state
class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final AnalyticsRepository _repository;

  AnalyticsBloc({required AnalyticsRepository repository})
      : _repository = repository,
        super(AnalyticsState.initial()) {
    on<LoadAnalytics>(_onLoadAnalytics);
    on<RefreshAnalytics>(_onRefreshAnalytics);
    on<ChangePeriod>(_onChangePeriod);
    on<ChangePaymentsDateRange>(_onChangePaymentsDateRange);
    on<ChangeProjectFilter>(_onChangeProjectFilter);
    on<RefreshContracts>(_onRefreshContracts);
    on<RefreshRevenueBreakdown>(_onRefreshRevenueBreakdown);
    on<ExportAnalyticsPdf>(_onExportPdf);
    on<ClearExportStatus>(_onClearExportStatus);
  }

  Future<void> _onLoadAnalytics(
    LoadAnalytics event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(state.copyWith(
      status: AnalyticsStatus.loading,
      errorMessage: null,
      isOffline: false,
    ));

    try {
      final results = await Future.wait([
        _repository.fetchStats(state.selectedPeriod),
        _repository.fetchClients(),
        _repository.fetchContracts(),
        _repository.fetchPayments(),
        _repository.fetchProjects(),
        _repository.fetchApartments(),
      ]);

      emit(state.copyWith(
        status: AnalyticsStatus.loaded,
        stats: results[0] as CrmStatsModel,
        clients: results[1] as List<AnalyticsClient>,
        contracts: results[2] as List<AnalyticsContract>,
        payments: results[3] as List<AnalyticsPayment>,
        projects: results[4] as List<AnalyticsProject>,
        apartments: results[5] as List<AnalyticsApartment>,
        lastUpdated: _repository.getLastUpdated(),
        isOffline: false,
        clearErrorMessage: true,
      ));
    } catch (e) {
      final cachedState = _loadCachedState();
      if (cachedState != null) {
        emit(cachedState.copyWith(
          status: AnalyticsStatus.loaded,
          errorMessage: _errorMessage(e),
          isOffline: e is NetworkException,
        ));
      } else {
        emit(state.copyWith(
          status: AnalyticsStatus.error,
          errorMessage: _errorMessage(e),
        ));
      }
    }
  }

  Future<void> _onRefreshAnalytics(
    RefreshAnalytics event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(state.copyWith(isRefreshing: true, errorMessage: null));

    try {
      final results = await Future.wait([
        _repository.fetchStats(state.selectedPeriod),
        _repository.fetchClients(),
        _repository.fetchContracts(),
        _repository.fetchPayments(),
        _repository.fetchProjects(),
        _repository.fetchApartments(),
      ]);

      emit(state.copyWith(
        status: AnalyticsStatus.loaded,
        isRefreshing: false,
        stats: results[0] as CrmStatsModel,
        clients: results[1] as List<AnalyticsClient>,
        contracts: results[2] as List<AnalyticsContract>,
        payments: results[3] as List<AnalyticsPayment>,
        projects: results[4] as List<AnalyticsProject>,
        apartments: results[5] as List<AnalyticsApartment>,
        lastUpdated: _repository.getLastUpdated(),
        isOffline: false,
      ));
    } catch (e) {
      final cachedState = _loadCachedState();
      if (cachedState != null) {
        emit(cachedState.copyWith(
          status: AnalyticsStatus.loaded,
          isRefreshing: false,
          errorMessage: _errorMessage(e),
          isOffline: e is NetworkException,
        ));
      } else {
        emit(state.copyWith(
          isRefreshing: false,
          errorMessage: _errorMessage(e),
          status: AnalyticsStatus.error,
        ));
      }
    }
  }

  Future<void> _onChangePeriod(
    ChangePeriod event,
    Emitter<AnalyticsState> emit,
  ) async {
    if (event.period == state.selectedPeriod) return;
    final previousPeriod = state.selectedPeriod;

    emit(state.copyWith(
      status: AnalyticsStatus.loading,
      selectedPeriod: event.period,
      errorMessage: null,
    ));

    try {
      final stats = await _repository.fetchStats(event.period);
      emit(state.copyWith(
        status: AnalyticsStatus.loaded,
        stats: stats,
        lastUpdated: _repository.getLastUpdated(),
        isOffline: false,
      ));
    } catch (e) {
      final cached = _repository.getCachedStats(event.period);
      if (cached != null) {
        emit(state.copyWith(
          status: AnalyticsStatus.loaded,
          stats: cached,
          lastUpdated: _repository.getLastUpdated(),
          errorMessage: _errorMessage(e),
          isOffline: e is NetworkException,
        ));
      } else {
        emit(state.copyWith(
          status: AnalyticsStatus.error,
          errorMessage: _errorMessage(e),
          selectedPeriod: previousPeriod,
        ));
      }
    }
  }

  void _onChangePaymentsDateRange(
    ChangePaymentsDateRange event,
    Emitter<AnalyticsState> emit,
  ) {
    emit(state.copyWith(
      paymentsFrom: event.from,
      paymentsTo: event.to,
    ));
  }

  void _onChangeProjectFilter(
    ChangeProjectFilter event,
    Emitter<AnalyticsState> emit,
  ) {
    emit(state.copyWith(selectedProjectId: event.projectId));
  }

  Future<void> _onRefreshContracts(
    RefreshContracts event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(state.copyWith(isRefreshing: true, errorMessage: null));

    try {
      final contracts = await _repository.fetchContracts();
      emit(state.copyWith(
        contracts: contracts,
        isRefreshing: false,
        lastUpdated: _repository.getLastUpdated(),
        isOffline: false,
      ));
    } catch (e) {
      final cached = _repository.getCachedContracts();
      if (cached != null) {
        emit(state.copyWith(
          contracts: cached,
          isRefreshing: false,
          lastUpdated: _repository.getLastUpdated(),
          errorMessage: _errorMessage(e),
          isOffline: e is NetworkException,
        ));
      } else {
        emit(state.copyWith(
          isRefreshing: false,
          errorMessage: _errorMessage(e),
        ));
      }
    }
  }

  Future<void> _onRefreshRevenueBreakdown(
    RefreshRevenueBreakdown event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(state.copyWith(isRefreshing: true, errorMessage: null));

    try {
      final results = await Future.wait([
        _repository.fetchContracts(),
        _repository.fetchApartments(),
      ]);

      emit(state.copyWith(
        contracts: results[0] as List<AnalyticsContract>,
        apartments: results[1] as List<AnalyticsApartment>,
        isRefreshing: false,
        lastUpdated: _repository.getLastUpdated(),
        isOffline: false,
      ));
    } catch (e) {
      final cachedContracts = _repository.getCachedContracts();
      final cachedApartments = _repository.getCachedApartments();
      if (cachedContracts != null || cachedApartments != null) {
        emit(state.copyWith(
          contracts: cachedContracts ?? state.contracts,
          apartments: cachedApartments ?? state.apartments,
          isRefreshing: false,
          lastUpdated: _repository.getLastUpdated(),
          errorMessage: _errorMessage(e),
          isOffline: e is NetworkException,
        ));
      } else {
        emit(state.copyWith(
          isRefreshing: false,
          errorMessage: _errorMessage(e),
        ));
      }
    }
  }

  AnalyticsState? _loadCachedState() {
    final cachedStats = _repository.getCachedStats(state.selectedPeriod);
    final cachedClients = _repository.getCachedClients();
    final cachedContracts = _repository.getCachedContracts();
    final cachedPayments = _repository.getCachedPayments();
    final cachedProjects = _repository.getCachedProjects();
    final cachedApartments = _repository.getCachedApartments();

    final hasAny = cachedStats != null ||
        cachedClients != null ||
        cachedContracts != null ||
        cachedPayments != null ||
        cachedProjects != null ||
        cachedApartments != null;

    if (!hasAny) return null;

    return state.copyWith(
      stats: cachedStats ?? state.stats,
      clients: cachedClients ?? state.clients,
      contracts: cachedContracts ?? state.contracts,
      payments: cachedPayments ?? state.payments,
      projects: cachedProjects ?? state.projects,
      apartments: cachedApartments ?? state.apartments,
      lastUpdated: _repository.getLastUpdated(),
    );
  }

  Future<void> _onExportPdf(
    ExportAnalyticsPdf event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(state.copyWith(isExporting: true, clearExportStatus: true));

    try {
      final result = await _repository.exportStatsPdf(
        stats: state.stats,
        contracts: state.contracts,
        period: state.selectedPeriod,
        translations: event.translations,
      );
      emit(state.copyWith(
        isExporting: false,
        exportSuccessPath: result.filePath,
        savedToDownloads: result.savedToDownloads,
      ));
    } catch (e) {
      emit(state.copyWith(
        isExporting: false,
        exportError: _errorMessage(e),
      ));
    }
  }

  void _onClearExportStatus(
    ClearExportStatus event,
    Emitter<AnalyticsState> emit,
  ) {
    emit(state.copyWith(clearExportStatus: true));
  }

  String _errorMessage(Object error) {
    if (error is NetworkException) return error.message;
    if (error is ServerExceptions) return error.message;
    if (error is FormatException) {
      return 'analytics_error_reading_response'.tr();
    }
    if (error is TypeError) {
      return 'analytics_error_format'.tr();
    }
    // Log unexpected errors for debugging
    log('[AnalyticsBloc] Unexpected error: $error', name: 'AnalyticsBloc');
    return 'analytics_error_loading_data'.tr();
  }
}
