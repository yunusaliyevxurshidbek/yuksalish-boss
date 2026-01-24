import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/approval.dart';
import '../../data/repositories/approvals_repository.dart';

part 'approvals_state.dart';

/// Cubit for managing approvals state
class ApprovalsCubit extends Cubit<ApprovalsState> {
  final ApprovalsRepository _repository;

  ApprovalsCubit({required ApprovalsRepository repository})
      : _repository = repository,
        super(const ApprovalsState());

  /// Load all approvals
  Future<void> loadApprovals() async {
    emit(state.copyWith(status: ApprovalsStatus.loading));
    try {
      final approvals = await _repository.getApprovals();
      final pendingCount =
          approvals.where((a) => a.status == ApprovalStatus.pending).length;
      emit(state.copyWith(
        status: ApprovalsStatus.loaded,
        approvals: approvals,
        filteredApprovals: _applyFilter(approvals, state.selectedFilter),
        pendingCount: pendingCount,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ApprovalsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Refresh approvals
  Future<void> refresh() async {
    try {
      final approvals = await _repository.getApprovals();
      final pendingCount =
          approvals.where((a) => a.status == ApprovalStatus.pending).length;
      emit(state.copyWith(
        approvals: approvals,
        filteredApprovals: _applyFilter(approvals, state.selectedFilter),
        pendingCount: pendingCount,
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  /// Filter approvals by type
  void filterByType(ApprovalTypeFilter filter) {
    emit(state.copyWith(
      selectedFilter: filter,
      filteredApprovals: _applyFilter(state.approvals, filter),
    ));
  }

  /// Approve a request
  Future<void> approve(String id, {String? comment}) async {
    emit(state.copyWith(processingId: id));
    try {
      final updated = await _repository.approve(id, comment: comment);
      final approvals = state.approvals.map((a) {
        return a.id == id ? updated : a;
      }).toList();
      final pendingCount =
          approvals.where((a) => a.status == ApprovalStatus.pending).length;
      emit(state.copyWith(
        approvals: approvals,
        filteredApprovals: _applyFilter(approvals, state.selectedFilter),
        pendingCount: pendingCount,
        processingId: null,
        lastAction: ApprovalAction.approved,
        lastActionId: id,
      ));
    } catch (e) {
      emit(state.copyWith(
        processingId: null,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Reject a request
  Future<void> reject(String id, String reason) async {
    emit(state.copyWith(processingId: id));
    try {
      final updated = await _repository.reject(id, reason);
      final approvals = state.approvals.map((a) {
        return a.id == id ? updated : a;
      }).toList();
      final pendingCount =
          approvals.where((a) => a.status == ApprovalStatus.pending).length;
      emit(state.copyWith(
        approvals: approvals,
        filteredApprovals: _applyFilter(approvals, state.selectedFilter),
        pendingCount: pendingCount,
        processingId: null,
        lastAction: ApprovalAction.rejected,
        lastActionId: id,
      ));
    } catch (e) {
      emit(state.copyWith(
        processingId: null,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Add comment to approval
  Future<void> addComment(String id, String comment) async {
    try {
      final updated = await _repository.addComment(id, comment);
      final approvals = state.approvals.map((a) {
        return a.id == id ? updated : a;
      }).toList();
      emit(state.copyWith(
        approvals: approvals,
        filteredApprovals: _applyFilter(approvals, state.selectedFilter),
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  /// Clear last action
  void clearLastAction() {
    emit(state.copyWith(
      lastAction: null,
      lastActionId: null,
    ));
  }

  List<Approval> _applyFilter(
    List<Approval> approvals,
    ApprovalTypeFilter filter,
  ) {
    // Only show pending approvals
    final pending =
        approvals.where((a) => a.status == ApprovalStatus.pending).toList();

    if (filter == ApprovalTypeFilter.all) {
      return pending;
    }

    final type = switch (filter) {
      ApprovalTypeFilter.all => null,
      ApprovalTypeFilter.purchase => ApprovalType.purchase,
      ApprovalTypeFilter.payment => ApprovalType.payment,
      ApprovalTypeFilter.hr => ApprovalType.hr,
      ApprovalTypeFilter.budget => ApprovalType.budget,
      ApprovalTypeFilter.discount => ApprovalType.discount,
    };

    if (type == null) return pending;
    return pending.where((a) => a.type == type).toList();
  }
}
