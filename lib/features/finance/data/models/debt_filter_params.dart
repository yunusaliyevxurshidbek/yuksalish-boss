import 'package:equatable/equatable.dart';

import 'debt.dart';

/// Filter parameters for debts list
class DebtFilterParams extends Equatable {
  const DebtFilterParams({
    this.status,
    this.projectId,
    this.assignedToId,
    this.clientSearch,
    this.latenessRange,
    this.sortBy,
  });

  final DebtStatus? status;
  final int? projectId;
  final int? assignedToId;
  final String? clientSearch;
  final LatenessRange? latenessRange;
  final DebtSortBy? sortBy;

  /// Check if any filters are active
  bool get hasActiveFilters {
    return status != null ||
        projectId != null ||
        assignedToId != null ||
        (clientSearch != null && clientSearch!.isNotEmpty) ||
        latenessRange != null;
  }

  /// Get active filter count (for badge display)
  int get activeFilterCount {
    int count = 0;
    if (status != null) count++;
    if (projectId != null) count++;
    if (assignedToId != null) count++;
    if (clientSearch != null && clientSearch!.isNotEmpty) count++;
    if (latenessRange != null) count++;
    return count;
  }

  /// Convert to query parameters for API request
  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{};

    if (status != null) {
      params['debt_status'] = status!.toApiString();
    }
    if (projectId != null) {
      params['project'] = projectId;
    }
    if (assignedToId != null) {
      params['assigned_to'] = assignedToId;
    }
    if (clientSearch != null && clientSearch!.isNotEmpty) {
      params['search'] = clientSearch;
    }
    if (latenessRange != null) {
      final range = latenessRange!.toApiParams();
      params.addAll(range);
    }
    if (sortBy != null) {
      params['ordering'] = sortBy!.toApiString();
    }

    return params;
  }

  DebtFilterParams copyWith({
    DebtStatus? status,
    int? projectId,
    int? assignedToId,
    String? clientSearch,
    LatenessRange? latenessRange,
    DebtSortBy? sortBy,
    bool clearStatus = false,
    bool clearProjectId = false,
    bool clearAssignedToId = false,
    bool clearClientSearch = false,
    bool clearLatenessRange = false,
    bool clearSortBy = false,
  }) {
    return DebtFilterParams(
      status: clearStatus ? null : (status ?? this.status),
      projectId: clearProjectId ? null : (projectId ?? this.projectId),
      assignedToId:
          clearAssignedToId ? null : (assignedToId ?? this.assignedToId),
      clientSearch:
          clearClientSearch ? null : (clientSearch ?? this.clientSearch),
      latenessRange:
          clearLatenessRange ? null : (latenessRange ?? this.latenessRange),
      sortBy: clearSortBy ? null : (sortBy ?? this.sortBy),
    );
  }

  /// Create empty filter params
  factory DebtFilterParams.empty() {
    return const DebtFilterParams();
  }

  /// Clear all filters
  DebtFilterParams clear() {
    return const DebtFilterParams();
  }

  @override
  List<Object?> get props => [
        status,
        projectId,
        assignedToId,
        clientSearch,
        latenessRange,
        sortBy,
      ];
}

/// Lateness range options for filtering debts
enum LatenessRange {
  none,
  oneToSeven,
  eightToFourteen,
  fifteenToThirty,
  overThirty;

  Map<String, dynamic> toApiParams() {
    return switch (this) {
      LatenessRange.none => {'overdue_days_max': 0},
      LatenessRange.oneToSeven => {'overdue_days_min': 1, 'overdue_days_max': 7},
      LatenessRange.eightToFourteen => {
          'overdue_days_min': 8,
          'overdue_days_max': 14
        },
      LatenessRange.fifteenToThirty => {
          'overdue_days_min': 15,
          'overdue_days_max': 30
        },
      LatenessRange.overThirty => {'overdue_days_min': 31},
    };
  }

  String get label {
    return switch (this) {
      LatenessRange.none => 'Kechikmasdan',
      LatenessRange.oneToSeven => '1-7 kun',
      LatenessRange.eightToFourteen => '8-14 kun',
      LatenessRange.fifteenToThirty => '15-30 kun',
      LatenessRange.overThirty => '30+ kun',
    };
  }
}

/// Sort options for debts
enum DebtSortBy {
  overdueDaysDesc,
  overdueDaysAsc,
  amountDesc,
  amountAsc,
  nameAsc,
  nameDesc;

  String toApiString() {
    return switch (this) {
      DebtSortBy.overdueDaysDesc => '-overdue_days',
      DebtSortBy.overdueDaysAsc => 'overdue_days',
      DebtSortBy.amountDesc => '-remaining_amount',
      DebtSortBy.amountAsc => 'remaining_amount',
      DebtSortBy.nameAsc => 'client_name',
      DebtSortBy.nameDesc => '-client_name',
    };
  }

  String get label {
    return switch (this) {
      DebtSortBy.overdueDaysDesc => 'Kechikish (ko\'p → kam)',
      DebtSortBy.overdueDaysAsc => 'Kechikish (kam → ko\'p)',
      DebtSortBy.amountDesc => 'Summa (katta → kichik)',
      DebtSortBy.amountAsc => 'Summa (kichik → katta)',
      DebtSortBy.nameAsc => 'Ism (A → Z)',
      DebtSortBy.nameDesc => 'Ism (Z → A)',
    };
  }
}
