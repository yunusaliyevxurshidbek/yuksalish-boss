part of 'dashboard_bloc.dart';

enum DashboardStatus { initial, loading, loaded, error }

class DashboardState extends Equatable {
  final DashboardStatus status;
  final DashboardPeriod selectedPeriod;
  final DashboardMetrics metrics;
  final List<SalesData> salesData;
  final List<FunnelData> funnelData;
  final String? errorMessage;
  final bool isRefreshing;

  const DashboardState({
    required this.status,
    required this.selectedPeriod,
    required this.metrics,
    required this.salesData,
    required this.funnelData,
    this.errorMessage,
    this.isRefreshing = false,
  });

  factory DashboardState.initial() => DashboardState(
        status: DashboardStatus.initial,
        selectedPeriod: DashboardPeriod.month,
        metrics: DashboardMetrics.empty(),
        salesData: const [],
        funnelData: const [],
      );

  DashboardState copyWith({
    DashboardStatus? status,
    DashboardPeriod? selectedPeriod,
    DashboardMetrics? metrics,
    List<SalesData>? salesData,
    List<FunnelData>? funnelData,
    String? errorMessage,
    bool? isRefreshing,
  }) {
    return DashboardState(
      status: status ?? this.status,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      metrics: metrics ?? this.metrics,
      salesData: salesData ?? this.salesData,
      funnelData: funnelData ?? this.funnelData,
      errorMessage: errorMessage,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  bool get isLoading => status == DashboardStatus.loading;
  bool get isLoaded => status == DashboardStatus.loaded;
  bool get hasError => status == DashboardStatus.error;

  int get totalFunnelCount =>
      funnelData.fold<int>(0, (sum, item) => sum + item.count);

  @override
  List<Object?> get props => [
        status,
        selectedPeriod,
        metrics,
        salesData,
        funnelData,
        errorMessage,
        isRefreshing,
      ];
}
