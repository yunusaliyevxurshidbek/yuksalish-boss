import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/debt.dart';
import '../../data/models/debt_filter_params.dart';
import '../../data/models/debt_stats.dart';
import '../../data/models/payment.dart';
import '../../data/models/payment_filter_params.dart';
import '../../data/models/payment_stats.dart';
import '../../data/models/record_payment_request.dart';
import '../../data/models/send_sms_request.dart';
import '../../data/repositories/finance_repository.dart';

// Re-export models for use in widgets
export '../../data/models/debt.dart';
export '../../data/models/debt_filter_params.dart';
export '../../data/models/debt_stats.dart';
export '../../data/models/payment.dart';
export '../../data/models/payment_filter_params.dart';
export '../../data/models/payment_stats.dart';
export '../../data/models/record_payment_request.dart';
export '../../data/models/send_sms_request.dart';

part 'finance_event.dart';
part 'finance_state.dart';

/// Finance bloc handling payments and debts data
class FinanceBloc extends Bloc<FinanceEvent, FinanceState> {
  FinanceBloc({required FinanceRepository repository})
      : _repository = repository,
        super(FinanceState.initial()) {
    // Core events
    on<LoadFinanceData>(_onLoadFinanceData);
    on<RefreshFinanceData>(_onRefreshFinanceData);
    on<ChangeFinanceTab>(_onChangeFinanceTab);
    on<ClearMessages>(_onClearMessages);

    // Payment events
    on<SearchPayments>(_onSearchPayments);
    on<FilterPayments>(_onFilterPayments);
    on<ClearPaymentFilters>(_onClearPaymentFilters);
    on<LoadMorePayments>(_onLoadMorePayments);
    on<RecordPayment>(_onRecordPayment);
    on<ExportPayments>(_onExportPayments);

    // Debt events
    on<SearchDebts>(_onSearchDebts);
    on<FilterDebtsByStatus>(_onFilterDebtsByStatus);
    on<FilterDebts>(_onFilterDebts);
    on<ClearDebtFilters>(_onClearDebtFilters);
    on<SortDebts>(_onSortDebts);
    on<LoadMoreDebts>(_onLoadMoreDebts);
    on<LoadDebtDetail>(_onLoadDebtDetail);
    on<SendDebtReminder>(_onSendDebtReminder);
    on<ExportDebts>(_onExportDebts);
  }

  final FinanceRepository _repository;

  // ============ Core Event Handlers ============

  Future<void> _onLoadFinanceData(
    LoadFinanceData event,
    Emitter<FinanceState> emit,
  ) async {
    emit(state.copyWith(status: FinanceStatus.loading));

    try {
      final results = await Future.wait([
        _repository.getPaymentStats(),
        _repository.getPayments(),
        _repository.getDebtStats(),
        _repository.getDebts(),
      ]);

      final paymentStats = results[0] as PaymentStats;
      final paymentsResponse = results[1] as PaymentsPaginatedResponse;
      final debtStats = results[2] as DebtStats;
      final debtsResponse = results[3] as DebtsPaginatedResponse;

      emit(state.copyWith(
        status: FinanceStatus.loaded,
        paymentStats: paymentStats,
        payments: paymentsResponse.results,
        filteredPayments: paymentsResponse.results,
        totalPaymentsCount: paymentsResponse.count,
        hasMorePayments: paymentsResponse.next != null,
        debtStats: debtStats,
        debts: debtsResponse.results,
        filteredDebts: _applyDebtFiltersAndSort(
          debtsResponse.results,
          state.debtFilter,
          state.debtSortBy,
          state.searchQuery,
        ),
        totalDebtsCount: debtsResponse.count,
        hasMoreDebts: debtsResponse.next != null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FinanceStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRefreshFinanceData(
    RefreshFinanceData event,
    Emitter<FinanceState> emit,
  ) async {
    emit(state.copyWith(isRefreshing: true));

    try {
      final results = await Future.wait([
        _repository.getPaymentStats(),
        _repository.getPayments(filters: state.paymentFilters),
        _repository.getDebtStats(),
        _repository.getDebts(filters: state.debtFilters),
      ]);

      final paymentStats = results[0] as PaymentStats;
      final paymentsResponse = results[1] as PaymentsPaginatedResponse;
      final debtStats = results[2] as DebtStats;
      final debtsResponse = results[3] as DebtsPaginatedResponse;

      emit(state.copyWith(
        isRefreshing: false,
        paymentStats: paymentStats,
        payments: paymentsResponse.results,
        filteredPayments: _applyPaymentSearch(
          paymentsResponse.results,
          state.paymentSearchQuery,
        ),
        totalPaymentsCount: paymentsResponse.count,
        hasMorePayments: paymentsResponse.next != null,
        currentPaymentsPage: 1,
        debtStats: debtStats,
        debts: debtsResponse.results,
        filteredDebts: _applyDebtFiltersAndSort(
          debtsResponse.results,
          state.debtFilter,
          state.debtSortBy,
          state.searchQuery,
        ),
        totalDebtsCount: debtsResponse.count,
        hasMoreDebts: debtsResponse.next != null,
        currentDebtsPage: 1,
      ));
    } catch (e) {
      emit(state.copyWith(
        isRefreshing: false,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onChangeFinanceTab(
    ChangeFinanceTab event,
    Emitter<FinanceState> emit,
  ) {
    emit(state.copyWith(activeTabIndex: event.tabIndex));
  }

  void _onClearMessages(
    ClearMessages event,
    Emitter<FinanceState> emit,
  ) {
    emit(state.copyWith(
      clearErrorMessage: true,
      clearSuccessMessage: true,
    ));
  }

  // ============ Payment Event Handlers ============

  void _onSearchPayments(
    SearchPayments event,
    Emitter<FinanceState> emit,
  ) {
    final filteredPayments = _applyPaymentSearch(state.payments, event.query);
    emit(state.copyWith(
      paymentSearchQuery: event.query,
      filteredPayments: filteredPayments,
    ));
  }

  Future<void> _onFilterPayments(
    FilterPayments event,
    Emitter<FinanceState> emit,
  ) async {
    emit(state.copyWith(
      paymentFilters: event.filters,
      isLoadingMorePayments: true,
    ));

    try {
      final response = await _repository.getPayments(
        filters: event.filters,
        page: 1,
      );

      emit(state.copyWith(
        payments: response.results,
        filteredPayments: _applyPaymentSearch(
          response.results,
          state.paymentSearchQuery,
        ),
        totalPaymentsCount: response.count,
        hasMorePayments: response.next != null,
        currentPaymentsPage: 1,
        isLoadingMorePayments: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingMorePayments: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onClearPaymentFilters(
    ClearPaymentFilters event,
    Emitter<FinanceState> emit,
  ) async {
    emit(state.copyWith(
      paymentFilters: PaymentFilterParams.empty(),
      paymentSearchQuery: '',
      isLoadingMorePayments: true,
    ));

    try {
      final response = await _repository.getPayments(page: 1);

      emit(state.copyWith(
        payments: response.results,
        filteredPayments: response.results,
        totalPaymentsCount: response.count,
        hasMorePayments: response.next != null,
        currentPaymentsPage: 1,
        isLoadingMorePayments: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingMorePayments: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoadMorePayments(
    LoadMorePayments event,
    Emitter<FinanceState> emit,
  ) async {
    if (!state.hasMorePayments || state.isLoadingMorePayments) return;

    emit(state.copyWith(isLoadingMorePayments: true));

    try {
      final nextPage = state.currentPaymentsPage + 1;
      final response = await _repository.getPayments(
        filters: state.paymentFilters,
        page: nextPage,
      );

      final allPayments = [...state.payments, ...response.results];

      emit(state.copyWith(
        payments: allPayments,
        filteredPayments: _applyPaymentSearch(
          allPayments,
          state.paymentSearchQuery,
        ),
        currentPaymentsPage: nextPage,
        hasMorePayments: response.next != null,
        isLoadingMorePayments: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingMorePayments: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRecordPayment(
    RecordPayment event,
    Emitter<FinanceState> emit,
  ) async {
    emit(state.copyWith(isRecordingPayment: true));

    try {
      final payment = await _repository.recordPayment(event.request);

      // Add new payment to the list
      final updatedPayments = [payment, ...state.payments];

      // Refresh stats
      final paymentStats = await _repository.getPaymentStats();

      emit(state.copyWith(
        isRecordingPayment: false,
        payments: updatedPayments,
        filteredPayments: _applyPaymentSearch(
          updatedPayments,
          state.paymentSearchQuery,
        ),
        paymentStats: paymentStats,
        successMessage: "To'lov muvaffaqiyatli qayd etildi",
      ));
    } catch (e) {
      emit(state.copyWith(
        isRecordingPayment: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onExportPayments(
    ExportPayments event,
    Emitter<FinanceState> emit,
  ) async {
    emit(state.copyWith(isExporting: true));

    try {
      await _repository.exportPayments(state.paymentFilters);

      emit(state.copyWith(
        isExporting: false,
        successMessage: "To'lovlar eksport qilindi",
      ));
    } catch (e) {
      emit(state.copyWith(
        isExporting: false,
        errorMessage: e.toString(),
      ));
    }
  }

  // ============ Debt Event Handlers ============

  void _onSearchDebts(
    SearchDebts event,
    Emitter<FinanceState> emit,
  ) {
    final filteredDebts = _applyDebtFiltersAndSort(
      state.debts,
      state.debtFilter,
      state.debtSortBy,
      event.query,
    );
    emit(state.copyWith(
      searchQuery: event.query,
      filteredDebts: filteredDebts,
    ));
  }

  void _onFilterDebtsByStatus(
    FilterDebtsByStatus event,
    Emitter<FinanceState> emit,
  ) {
    final filteredDebts = _applyDebtFiltersAndSort(
      state.debts,
      event.filter,
      state.debtSortBy,
      state.searchQuery,
    );
    emit(state.copyWith(
      debtFilter: event.filter,
      filteredDebts: filteredDebts,
    ));
  }

  Future<void> _onFilterDebts(
    FilterDebts event,
    Emitter<FinanceState> emit,
  ) async {
    emit(state.copyWith(
      debtFilters: event.filters,
      isLoadingMoreDebts: true,
    ));

    try {
      final response = await _repository.getDebts(
        filters: event.filters,
        page: 1,
      );

      emit(state.copyWith(
        debts: response.results,
        filteredDebts: _applyDebtFiltersAndSort(
          response.results,
          state.debtFilter,
          state.debtSortBy,
          state.searchQuery,
        ),
        totalDebtsCount: response.count,
        hasMoreDebts: response.next != null,
        currentDebtsPage: 1,
        isLoadingMoreDebts: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingMoreDebts: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onClearDebtFilters(
    ClearDebtFilters event,
    Emitter<FinanceState> emit,
  ) async {
    emit(state.copyWith(
      debtFilters: DebtFilterParams.empty(),
      debtFilter: DebtFilter.all,
      searchQuery: '',
      isLoadingMoreDebts: true,
    ));

    try {
      final response = await _repository.getDebts(page: 1);

      emit(state.copyWith(
        debts: response.results,
        filteredDebts: response.results,
        totalDebtsCount: response.count,
        hasMoreDebts: response.next != null,
        currentDebtsPage: 1,
        isLoadingMoreDebts: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingMoreDebts: false,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onSortDebts(
    SortDebts event,
    Emitter<FinanceState> emit,
  ) {
    final filteredDebts = _applyDebtFiltersAndSort(
      state.debts,
      state.debtFilter,
      event.sortBy,
      state.searchQuery,
    );
    emit(state.copyWith(
      debtSortBy: event.sortBy,
      filteredDebts: filteredDebts,
    ));
  }

  Future<void> _onLoadMoreDebts(
    LoadMoreDebts event,
    Emitter<FinanceState> emit,
  ) async {
    if (!state.hasMoreDebts || state.isLoadingMoreDebts) return;

    emit(state.copyWith(isLoadingMoreDebts: true));

    try {
      final nextPage = state.currentDebtsPage + 1;
      final response = await _repository.getDebts(
        filters: state.debtFilters,
        page: nextPage,
      );

      final allDebts = [...state.debts, ...response.results];

      emit(state.copyWith(
        debts: allDebts,
        filteredDebts: _applyDebtFiltersAndSort(
          allDebts,
          state.debtFilter,
          state.debtSortBy,
          state.searchQuery,
        ),
        currentDebtsPage: nextPage,
        hasMoreDebts: response.next != null,
        isLoadingMoreDebts: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingMoreDebts: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoadDebtDetail(
    LoadDebtDetail event,
    Emitter<FinanceState> emit,
  ) async {
    emit(state.copyWith(isLoadingDebtDetail: true));

    try {
      final debt = await _repository.getDebtById(event.contractId);

      emit(state.copyWith(
        isLoadingDebtDetail: false,
        selectedDebt: debt,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingDebtDetail: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSendDebtReminder(
    SendDebtReminder event,
    Emitter<FinanceState> emit,
  ) async {
    emit(state.copyWith(isSendingSms: true));

    try {
      await _repository.sendDebtReminder(event.request);

      emit(state.copyWith(
        isSendingSms: false,
        successMessage: 'SMS muvaffaqiyatli yuborildi',
      ));
    } catch (e) {
      emit(state.copyWith(
        isSendingSms: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onExportDebts(
    ExportDebts event,
    Emitter<FinanceState> emit,
  ) async {
    emit(state.copyWith(isExporting: true));

    try {
      await _repository.exportDebts(state.debtFilters);

      emit(state.copyWith(
        isExporting: false,
        successMessage: 'Qarzlar eksport qilindi',
      ));
    } catch (e) {
      emit(state.copyWith(
        isExporting: false,
        errorMessage: e.toString(),
      ));
    }
  }

  // ============ Helper Methods ============

  List<Payment> _applyPaymentSearch(List<Payment> payments, String query) {
    if (query.isEmpty) return payments;

    final lowerQuery = query.toLowerCase();
    return payments.where((payment) {
      return payment.clientName.toLowerCase().contains(lowerQuery) ||
          payment.contractNumber.toLowerCase().contains(lowerQuery) ||
          payment.receiptNumber.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  List<Debt> _applyDebtFiltersAndSort(
    List<Debt> debts,
    DebtFilter filter,
    DebtSortBy sortBy,
    String searchQuery,
  ) {
    var result = List<Debt>.from(debts);

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      result = result.where((debt) {
        return debt.clientName.toLowerCase().contains(query) ||
            debt.contractNumber.toLowerCase().contains(query) ||
            debt.projectName.toLowerCase().contains(query);
      }).toList();
    }

    // Apply status filter
    result = switch (filter) {
      DebtFilter.all => result,
      DebtFilter.mild => result.where((d) => d.severityLevel == 0).toList(),
      DebtFilter.warning => result.where((d) => d.severityLevel == 1).toList(),
      DebtFilter.critical => result.where((d) => d.severityLevel == 2).toList(),
    };

    // Apply sorting
    result.sort((a, b) {
      return switch (sortBy) {
        DebtSortBy.overdueDaysDesc => b.overdueDays.compareTo(a.overdueDays),
        DebtSortBy.overdueDaysAsc => a.overdueDays.compareTo(b.overdueDays),
        DebtSortBy.amountDesc => b.overdueAmount.compareTo(a.overdueAmount),
        DebtSortBy.amountAsc => a.overdueAmount.compareTo(b.overdueAmount),
        DebtSortBy.nameAsc => a.clientName.compareTo(b.clientName),
        DebtSortBy.nameDesc => b.clientName.compareTo(a.clientName),
      };
    });

    return result;
  }
}
