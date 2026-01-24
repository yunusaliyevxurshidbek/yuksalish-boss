import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/lead_model.dart';
import '../../data/repositories/leads_repository.dart';

part 'leads_state.dart';

/// Cubit for managing leads state
class LeadsCubit extends Cubit<LeadsState> {
  final LeadsRepository _repository;

  LeadsCubit({required LeadsRepository repository})
      : _repository = repository,
        super(const LeadsState());

  /// Load leads with optional filtering
  Future<void> loadLeads({
    LeadStage? stage,
    String? search,
    String? order,
  }) async {
    emit(state.copyWith(
      status: LeadsStatus.loading,
      selectedStage: stage,
      searchQuery: search,
      currentOrder: order,
    ));

    try {
      final response = await _repository.getLeads(
        stage: stage,
        search: search,
        order: order,
        page: 1,
      );

      emit(state.copyWith(
        status: LeadsStatus.loaded,
        leads: response.results,
        totalCount: response.count,
        hasNextPage: response.hasNextPage,
        currentPage: 1,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LeadsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Load more leads (pagination)
  Future<void> loadMoreLeads() async {
    if (state.isLoadingMore || !state.hasNextPage) return;

    emit(state.copyWith(isLoadingMore: true));

    try {
      final response = await _repository.getLeads(
        stage: state.selectedStage,
        search: state.searchQuery,
        order: state.currentOrder,
        page: state.currentPage + 1,
      );

      emit(state.copyWith(
        leads: [...state.leads, ...response.results],
        hasNextPage: response.hasNextPage,
        currentPage: state.currentPage + 1,
        isLoadingMore: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingMore: false,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Refresh leads
  Future<void> refresh() async {
    emit(state.copyWith(isRefreshing: true));

    try {
      final response = await _repository.getLeads(
        stage: state.selectedStage,
        search: state.searchQuery,
        order: state.currentOrder,
        page: 1,
      );

      emit(state.copyWith(
        leads: response.results,
        totalCount: response.count,
        hasNextPage: response.hasNextPage,
        currentPage: 1,
        isRefreshing: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isRefreshing: false,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Filter by stage
  void filterByStage(LeadStage? stage) {
    loadLeads(
      stage: stage,
      search: state.searchQuery,
      order: state.currentOrder,
    );
  }

  /// Search leads
  void search(String query) {
    loadLeads(
      stage: state.selectedStage,
      search: query.isEmpty ? null : query,
      order: state.currentOrder,
    );
  }

  /// Sort leads
  void sortBy(String order) {
    loadLeads(
      stage: state.selectedStage,
      search: state.searchQuery,
      order: order,
    );
  }

  /// Clear filters
  void clearFilters() {
    loadLeads();
  }

  /// Get total leads count (for dashboard)
  Future<int> getTotalLeadsCount() async {
    try {
      return await _repository.getLeadsCount();
    } catch (e) {
      return 0;
    }
  }

  /// Get leads count by stage (for statistics)
  Future<Map<LeadStage, int>> getLeadsCountByStage() async {
    try {
      return await _repository.getLeadsCountByStage();
    } catch (e) {
      return {};
    }
  }
}
