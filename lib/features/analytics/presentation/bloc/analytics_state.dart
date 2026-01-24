part of 'analytics_bloc.dart';

/// Status of analytics data loading
enum AnalyticsStatus { initial, loading, loaded, error }

/// State for analytics screen
class AnalyticsState extends Equatable {
  final AnalyticsStatus status;
  final AnalyticsPeriod selectedPeriod;
  final DateTime paymentsFrom;
  final DateTime paymentsTo;
  final String selectedProjectId;
  final CrmStatsModel stats;
  final List<AnalyticsClient> clients;
  final List<AnalyticsContract> contracts;
  final List<AnalyticsPayment> payments;
  final List<AnalyticsProject> projects;
  final List<AnalyticsApartment> apartments;
  final String? errorMessage;
  final bool isRefreshing;
  final bool isOffline;
  final DateTime? lastUpdated;
  final bool isExporting;
  final String? exportError;
  final String? exportSuccessPath;

  const AnalyticsState({
    required this.status,
    required this.selectedPeriod,
    required this.paymentsFrom,
    required this.paymentsTo,
    required this.selectedProjectId,
    required this.stats,
    required this.clients,
    required this.contracts,
    required this.payments,
    required this.projects,
    required this.apartments,
    this.errorMessage,
    this.isRefreshing = false,
    this.isOffline = false,
    this.lastUpdated,
    this.isExporting = false,
    this.exportError,
    this.exportSuccessPath,
  });

  factory AnalyticsState.initial() {
    final now = DateTime.now();
    final from = DateTime(now.year, now.month - 1, now.day);
    return AnalyticsState(
      status: AnalyticsStatus.initial,
      selectedPeriod: AnalyticsPeriod.last30Days,
      paymentsFrom: from,
      paymentsTo: now,
      selectedProjectId: 'all',
      stats: CrmStatsModel.empty(),
      clients: const [],
      contracts: const [],
      payments: const [],
      projects: const [],
      apartments: const [],
    );
  }

  AnalyticsState copyWith({
    AnalyticsStatus? status,
    AnalyticsPeriod? selectedPeriod,
    DateTime? paymentsFrom,
    DateTime? paymentsTo,
    String? selectedProjectId,
    CrmStatsModel? stats,
    List<AnalyticsClient>? clients,
    List<AnalyticsContract>? contracts,
    List<AnalyticsPayment>? payments,
    List<AnalyticsProject>? projects,
    List<AnalyticsApartment>? apartments,
    String? errorMessage,
    bool? isRefreshing,
    bool? isOffline,
    DateTime? lastUpdated,
    bool? isExporting,
    String? exportError,
    String? exportSuccessPath,
    bool clearExportStatus = false,
    bool clearErrorMessage = false,
  }) {
    return AnalyticsState(
      status: status ?? this.status,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      paymentsFrom: paymentsFrom ?? this.paymentsFrom,
      paymentsTo: paymentsTo ?? this.paymentsTo,
      selectedProjectId: selectedProjectId ?? this.selectedProjectId,
      stats: stats ?? this.stats,
      clients: clients ?? this.clients,
      contracts: contracts ?? this.contracts,
      payments: payments ?? this.payments,
      projects: projects ?? this.projects,
      apartments: apartments ?? this.apartments,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isOffline: isOffline ?? this.isOffline,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isExporting: isExporting ?? this.isExporting,
      exportError: clearExportStatus ? null : (exportError ?? this.exportError),
      exportSuccessPath: clearExportStatus ? null : (exportSuccessPath ?? this.exportSuccessPath),
    );
  }

  bool get hasData =>
      stats.totalRevenue > 0 ||
      clients.isNotEmpty ||
      contracts.isNotEmpty ||
      payments.isNotEmpty ||
      projects.isNotEmpty ||
      apartments.isNotEmpty;

  @override
  List<Object?> get props => [
        status,
        selectedPeriod,
        paymentsFrom,
        paymentsTo,
        selectedProjectId,
        stats,
        clients,
        contracts,
        payments,
        projects,
        apartments,
        errorMessage,
        isRefreshing,
        isOffline,
        lastUpdated,
        isExporting,
        exportError,
        exportSuccessPath,
      ];
}
