part of 'leads_cubit.dart';

/// Status of leads loading
enum LeadsStatus {
  initial,
  loading,
  loaded,
  error,
}

/// State for leads
class LeadsState extends Equatable {
  final LeadsStatus status;
  final List<Lead> leads;
  final int totalCount;
  final int currentPage;
  final bool hasNextPage;
  final bool isLoadingMore;
  final bool isRefreshing;
  final LeadStage? selectedStage;
  final String? searchQuery;
  final String? currentOrder;
  final String? errorMessage;

  const LeadsState({
    this.status = LeadsStatus.initial,
    this.leads = const [],
    this.totalCount = 0,
    this.currentPage = 1,
    this.hasNextPage = false,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.selectedStage,
    this.searchQuery,
    this.currentOrder,
    this.errorMessage,
  });

  /// Computed properties
  bool get isLoading => status == LeadsStatus.loading;
  bool get isLoaded => status == LeadsStatus.loaded;
  bool get hasError => status == LeadsStatus.error;
  bool get isEmpty => leads.isEmpty && isLoaded;
  bool get hasFilters => selectedStage != null || (searchQuery?.isNotEmpty ?? false);

  /// Get stage filter label in Uzbek
  String getStageLabel(LeadStage? stage) {
    if (stage == null) return 'Barchasi';
    return stage.displayName;
  }

  LeadsState copyWith({
    LeadsStatus? status,
    List<Lead>? leads,
    int? totalCount,
    int? currentPage,
    bool? hasNextPage,
    bool? isLoadingMore,
    bool? isRefreshing,
    LeadStage? selectedStage,
    String? searchQuery,
    String? currentOrder,
    String? errorMessage,
  }) {
    return LeadsState(
      status: status ?? this.status,
      leads: leads ?? this.leads,
      totalCount: totalCount ?? this.totalCount,
      currentPage: currentPage ?? this.currentPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      selectedStage: selectedStage ?? this.selectedStage,
      searchQuery: searchQuery ?? this.searchQuery,
      currentOrder: currentOrder ?? this.currentOrder,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        leads,
        totalCount,
        currentPage,
        hasNextPage,
        isLoadingMore,
        isRefreshing,
        selectedStage,
        searchQuery,
        currentOrder,
        errorMessage,
      ];
}
