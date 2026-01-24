part of 'finance_bloc.dart';

/// Finance loading status
enum FinanceStatus { initial, loading, loaded, error }

/// Debt filter options (legacy, kept for compatibility)
enum DebtFilter { all, mild, warning, critical }

/// Finance bloc state
class FinanceState extends Equatable {
  const FinanceState({
    required this.status,
    required this.activeTabIndex,
    required this.paymentStats,
    required this.payments,
    required this.filteredPayments,
    required this.debtStats,
    required this.debts,
    required this.filteredDebts,
    required this.debtFilter,
    required this.debtSortBy,
    required this.searchQuery,
    required this.paymentSearchQuery,
    required this.paymentFilters,
    required this.debtFilters,
    this.selectedDebt,
    this.errorMessage,
    this.successMessage,
    this.isRefreshing = false,
    this.isRecordingPayment = false,
    this.isSendingSms = false,
    this.isExporting = false,
    this.isLoadingDebtDetail = false,
    this.isLoadingMorePayments = false,
    this.isLoadingMoreDebts = false,
    this.hasMorePayments = true,
    this.hasMoreDebts = true,
    this.currentPaymentsPage = 1,
    this.currentDebtsPage = 1,
    this.totalPaymentsCount = 0,
    this.totalDebtsCount = 0,
  });

  final FinanceStatus status;
  final int activeTabIndex;

  // Payment state
  final PaymentStats paymentStats;
  final List<Payment> payments;
  final List<Payment> filteredPayments;
  final String paymentSearchQuery;
  final PaymentFilterParams paymentFilters;
  final bool isRecordingPayment;
  final bool isLoadingMorePayments;
  final bool hasMorePayments;
  final int currentPaymentsPage;
  final int totalPaymentsCount;

  // Debt state
  final DebtStats debtStats;
  final List<Debt> debts;
  final List<Debt> filteredDebts;
  final DebtFilter debtFilter;
  final DebtSortBy debtSortBy;
  final String searchQuery;
  final DebtFilterParams debtFilters;
  final Debt? selectedDebt;
  final bool isSendingSms;
  final bool isLoadingDebtDetail;
  final bool isLoadingMoreDebts;
  final bool hasMoreDebts;
  final int currentDebtsPage;
  final int totalDebtsCount;

  // Common state
  final String? errorMessage;
  final String? successMessage;
  final bool isRefreshing;
  final bool isExporting;

  /// Factory for initial state
  factory FinanceState.initial() {
    return FinanceState(
      status: FinanceStatus.initial,
      activeTabIndex: 0,
      paymentStats: PaymentStats.empty(),
      payments: const [],
      filteredPayments: const [],
      paymentSearchQuery: '',
      paymentFilters: PaymentFilterParams.empty(),
      debtStats: DebtStats.empty(),
      debts: const [],
      filteredDebts: const [],
      debtFilter: DebtFilter.all,
      debtSortBy: DebtSortBy.overdueDaysDesc,
      searchQuery: '',
      debtFilters: DebtFilterParams.empty(),
    );
  }

  /// Check if payment filters are active
  bool get hasActivePaymentFilters => paymentFilters.hasActiveFilters;

  /// Check if debt filters are active
  bool get hasActiveDebtFilters => debtFilters.hasActiveFilters;

  FinanceState copyWith({
    FinanceStatus? status,
    int? activeTabIndex,
    PaymentStats? paymentStats,
    List<Payment>? payments,
    List<Payment>? filteredPayments,
    String? paymentSearchQuery,
    PaymentFilterParams? paymentFilters,
    DebtStats? debtStats,
    List<Debt>? debts,
    List<Debt>? filteredDebts,
    DebtFilter? debtFilter,
    DebtSortBy? debtSortBy,
    String? searchQuery,
    DebtFilterParams? debtFilters,
    Debt? selectedDebt,
    String? errorMessage,
    String? successMessage,
    bool? isRefreshing,
    bool? isRecordingPayment,
    bool? isSendingSms,
    bool? isExporting,
    bool? isLoadingDebtDetail,
    bool? isLoadingMorePayments,
    bool? isLoadingMoreDebts,
    bool? hasMorePayments,
    bool? hasMoreDebts,
    int? currentPaymentsPage,
    int? currentDebtsPage,
    int? totalPaymentsCount,
    int? totalDebtsCount,
    bool clearSelectedDebt = false,
    bool clearErrorMessage = false,
    bool clearSuccessMessage = false,
  }) {
    return FinanceState(
      status: status ?? this.status,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
      paymentStats: paymentStats ?? this.paymentStats,
      payments: payments ?? this.payments,
      filteredPayments: filteredPayments ?? this.filteredPayments,
      paymentSearchQuery: paymentSearchQuery ?? this.paymentSearchQuery,
      paymentFilters: paymentFilters ?? this.paymentFilters,
      debtStats: debtStats ?? this.debtStats,
      debts: debts ?? this.debts,
      filteredDebts: filteredDebts ?? this.filteredDebts,
      debtFilter: debtFilter ?? this.debtFilter,
      debtSortBy: debtSortBy ?? this.debtSortBy,
      searchQuery: searchQuery ?? this.searchQuery,
      debtFilters: debtFilters ?? this.debtFilters,
      selectedDebt: clearSelectedDebt ? null : (selectedDebt ?? this.selectedDebt),
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccessMessage ? null : (successMessage ?? this.successMessage),
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isRecordingPayment: isRecordingPayment ?? this.isRecordingPayment,
      isSendingSms: isSendingSms ?? this.isSendingSms,
      isExporting: isExporting ?? this.isExporting,
      isLoadingDebtDetail: isLoadingDebtDetail ?? this.isLoadingDebtDetail,
      isLoadingMorePayments: isLoadingMorePayments ?? this.isLoadingMorePayments,
      isLoadingMoreDebts: isLoadingMoreDebts ?? this.isLoadingMoreDebts,
      hasMorePayments: hasMorePayments ?? this.hasMorePayments,
      hasMoreDebts: hasMoreDebts ?? this.hasMoreDebts,
      currentPaymentsPage: currentPaymentsPage ?? this.currentPaymentsPage,
      currentDebtsPage: currentDebtsPage ?? this.currentDebtsPage,
      totalPaymentsCount: totalPaymentsCount ?? this.totalPaymentsCount,
      totalDebtsCount: totalDebtsCount ?? this.totalDebtsCount,
    );
  }

  @override
  List<Object?> get props => [
        status,
        activeTabIndex,
        paymentStats,
        payments,
        filteredPayments,
        paymentSearchQuery,
        paymentFilters,
        debtStats,
        debts,
        filteredDebts,
        debtFilter,
        debtSortBy,
        searchQuery,
        debtFilters,
        selectedDebt,
        errorMessage,
        successMessage,
        isRefreshing,
        isRecordingPayment,
        isSendingSms,
        isExporting,
        isLoadingDebtDetail,
        isLoadingMorePayments,
        isLoadingMoreDebts,
        hasMorePayments,
        hasMoreDebts,
        currentPaymentsPage,
        currentDebtsPage,
        totalPaymentsCount,
        totalDebtsCount,
      ];
}
