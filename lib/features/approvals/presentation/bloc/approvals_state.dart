part of 'approvals_cubit.dart';

/// Status of approvals loading
enum ApprovalsStatus {
  initial,
  loading,
  loaded,
  error,
}

/// Filter options for approval types
enum ApprovalTypeFilter {
  all,
  purchase,
  payment,
  hr,
  budget,
  discount,
}

/// Action performed on approval
enum ApprovalAction {
  approved,
  rejected,
}

/// State for approvals
class ApprovalsState extends Equatable {
  final ApprovalsStatus status;
  final List<Approval> approvals;
  final List<Approval> filteredApprovals;
  final ApprovalTypeFilter selectedFilter;
  final int pendingCount;
  final String? processingId;
  final ApprovalAction? lastAction;
  final String? lastActionId;
  final String? errorMessage;

  const ApprovalsState({
    this.status = ApprovalsStatus.initial,
    this.approvals = const [],
    this.filteredApprovals = const [],
    this.selectedFilter = ApprovalTypeFilter.all,
    this.pendingCount = 0,
    this.processingId,
    this.lastAction,
    this.lastActionId,
    this.errorMessage,
  });

  /// Check if currently processing an action
  bool isProcessing(String id) => processingId == id;

  /// Get filter label in Uzbek
  String getFilterLabel(ApprovalTypeFilter filter) {
    return switch (filter) {
      ApprovalTypeFilter.all => 'Barchasi',
      ApprovalTypeFilter.purchase => 'Xarid',
      ApprovalTypeFilter.payment => "To'lov",
      ApprovalTypeFilter.hr => 'HR',
      ApprovalTypeFilter.budget => 'Byudjet',
      ApprovalTypeFilter.discount => 'Chegirma',
    };
  }

  ApprovalsState copyWith({
    ApprovalsStatus? status,
    List<Approval>? approvals,
    List<Approval>? filteredApprovals,
    ApprovalTypeFilter? selectedFilter,
    int? pendingCount,
    String? processingId,
    ApprovalAction? lastAction,
    String? lastActionId,
    String? errorMessage,
  }) {
    return ApprovalsState(
      status: status ?? this.status,
      approvals: approvals ?? this.approvals,
      filteredApprovals: filteredApprovals ?? this.filteredApprovals,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      pendingCount: pendingCount ?? this.pendingCount,
      processingId: processingId,
      lastAction: lastAction,
      lastActionId: lastActionId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        approvals,
        filteredApprovals,
        selectedFilter,
        pendingCount,
        processingId,
        lastAction,
        lastActionId,
        errorMessage,
      ];
}
