part of 'finance_bloc.dart';

/// Base event for finance bloc
sealed class FinanceEvent extends Equatable {
  const FinanceEvent();

  @override
  List<Object?> get props => [];
}

/// Load all finance data
class LoadFinanceData extends FinanceEvent {
  const LoadFinanceData();
}

/// Refresh finance data
class RefreshFinanceData extends FinanceEvent {
  const RefreshFinanceData();
}

/// Change active tab
class ChangeFinanceTab extends FinanceEvent {
  const ChangeFinanceTab(this.tabIndex);

  final int tabIndex;

  @override
  List<Object?> get props => [tabIndex];
}

// ============ Payment Events ============

/// Search payments by query
class SearchPayments extends FinanceEvent {
  const SearchPayments(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

/// Filter payments
class FilterPayments extends FinanceEvent {
  const FilterPayments(this.filters);

  final PaymentFilterParams filters;

  @override
  List<Object?> get props => [filters];
}

/// Clear payment filters
class ClearPaymentFilters extends FinanceEvent {
  const ClearPaymentFilters();
}

/// Load more payments (pagination)
class LoadMorePayments extends FinanceEvent {
  const LoadMorePayments();
}

/// Record a new payment
class RecordPayment extends FinanceEvent {
  const RecordPayment(this.request);

  final RecordPaymentRequest request;

  @override
  List<Object?> get props => [request];
}

/// Export payments to file
class ExportPayments extends FinanceEvent {
  const ExportPayments();
}

// ============ Debt Events ============

/// Filter debts by search query
class SearchDebts extends FinanceEvent {
  const SearchDebts(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

/// Filter debts by status (legacy, kept for compatibility)
class FilterDebtsByStatus extends FinanceEvent {
  const FilterDebtsByStatus(this.filter);

  final DebtFilter filter;

  @override
  List<Object?> get props => [filter];
}

/// Filter debts with full params
class FilterDebts extends FinanceEvent {
  const FilterDebts(this.filters);

  final DebtFilterParams filters;

  @override
  List<Object?> get props => [filters];
}

/// Clear debt filters
class ClearDebtFilters extends FinanceEvent {
  const ClearDebtFilters();
}

/// Sort debts
class SortDebts extends FinanceEvent {
  const SortDebts(this.sortBy);

  final DebtSortBy sortBy;

  @override
  List<Object?> get props => [sortBy];
}

/// Load more debts (pagination)
class LoadMoreDebts extends FinanceEvent {
  const LoadMoreDebts();
}

/// Load debt detail
class LoadDebtDetail extends FinanceEvent {
  const LoadDebtDetail(this.contractId);

  final int contractId;

  @override
  List<Object?> get props => [contractId];
}

/// Send SMS reminder to debtor
class SendDebtReminder extends FinanceEvent {
  const SendDebtReminder(this.request);

  final SendSmsRequest request;

  @override
  List<Object?> get props => [request];
}

/// Export debts to file
class ExportDebts extends FinanceEvent {
  const ExportDebts();
}

/// Clear success/error messages
class ClearMessages extends FinanceEvent {
  const ClearMessages();
}
