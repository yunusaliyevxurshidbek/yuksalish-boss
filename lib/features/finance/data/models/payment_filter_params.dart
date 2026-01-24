import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';

import 'payment.dart';

/// Filter parameters for payments list
class PaymentFilterParams extends Equatable {
  const PaymentFilterParams({
    this.status,
    this.method,
    this.clientSearch,
    this.projectId,
    this.dateFrom,
    this.dateTo,
    this.sortBy,
  });

  final PaymentStatus? status;
  final PaymentType? method;
  final String? clientSearch;
  final int? projectId;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final PaymentSortBy? sortBy;

  /// Check if any filters are active
  bool get hasActiveFilters {
    return status != null ||
        method != null ||
        (clientSearch != null && clientSearch!.isNotEmpty) ||
        projectId != null ||
        dateFrom != null ||
        dateTo != null;
  }

  /// Get active filter count (for badge display)
  int get activeFilterCount {
    int count = 0;
    if (status != null) count++;
    if (method != null) count++;
    if (clientSearch != null && clientSearch!.isNotEmpty) count++;
    if (projectId != null) count++;
    if (dateFrom != null || dateTo != null) count++;
    return count;
  }

  /// Convert to query parameters for API request
  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{};

    if (status != null) {
      params['status'] = status!.toApiString();
    }
    if (method != null) {
      params['method'] = method!.toApiString();
    }
    if (clientSearch != null && clientSearch!.isNotEmpty) {
      params['search'] = clientSearch;
    }
    if (projectId != null) {
      params['project'] = projectId;
    }
    if (dateFrom != null) {
      params['date_from'] = dateFrom!.toIso8601String().split('T').first;
    }
    if (dateTo != null) {
      params['date_to'] = dateTo!.toIso8601String().split('T').first;
    }
    if (sortBy != null) {
      params['ordering'] = sortBy!.toApiString();
    }

    return params;
  }

  PaymentFilterParams copyWith({
    PaymentStatus? status,
    PaymentType? method,
    String? clientSearch,
    int? projectId,
    DateTime? dateFrom,
    DateTime? dateTo,
    PaymentSortBy? sortBy,
    bool clearStatus = false,
    bool clearMethod = false,
    bool clearClientSearch = false,
    bool clearProjectId = false,
    bool clearDateFrom = false,
    bool clearDateTo = false,
    bool clearSortBy = false,
  }) {
    return PaymentFilterParams(
      status: clearStatus ? null : (status ?? this.status),
      method: clearMethod ? null : (method ?? this.method),
      clientSearch:
          clearClientSearch ? null : (clientSearch ?? this.clientSearch),
      projectId: clearProjectId ? null : (projectId ?? this.projectId),
      dateFrom: clearDateFrom ? null : (dateFrom ?? this.dateFrom),
      dateTo: clearDateTo ? null : (dateTo ?? this.dateTo),
      sortBy: clearSortBy ? null : (sortBy ?? this.sortBy),
    );
  }

  /// Create empty filter params
  factory PaymentFilterParams.empty() {
    return const PaymentFilterParams();
  }

  /// Clear all filters
  PaymentFilterParams clear() {
    return const PaymentFilterParams();
  }

  @override
  List<Object?> get props => [
        status,
        method,
        clientSearch,
        projectId,
        dateFrom,
        dateTo,
        sortBy,
      ];
}

/// Sort options for payments
enum PaymentSortBy {
  dateDesc,
  dateAsc,
  amountDesc,
  amountAsc;

  String toApiString() {
    return switch (this) {
      PaymentSortBy.dateDesc => '-payment_date',
      PaymentSortBy.dateAsc => 'payment_date',
      PaymentSortBy.amountDesc => '-amount',
      PaymentSortBy.amountAsc => 'amount',
    };
  }

  String get label {
    return switch (this) {
      PaymentSortBy.dateDesc => 'finance_sort_date_desc'.tr(),
      PaymentSortBy.dateAsc => 'finance_sort_date_asc'.tr(),
      PaymentSortBy.amountDesc => 'finance_sort_amount_desc'.tr(),
      PaymentSortBy.amountAsc => 'finance_sort_amount_asc'.tr(),
    };
  }
}
