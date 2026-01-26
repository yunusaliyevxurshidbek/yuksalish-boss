import '../../../dashboard/data/models/crm_stats_model.dart';
import '../datasources/analytics_cache.dart';
import '../datasources/analytics_remote_datasource.dart';
import '../models/analytics_apartment.dart';
import '../models/analytics_client.dart';
import '../models/analytics_contract.dart';
import '../models/analytics_payment.dart';
import '../models/analytics_period.dart';
import '../models/analytics_project.dart';
import '../services/analytics_pdf_generator.dart';

/// Repository interface for analytics data.
abstract class AnalyticsRepository {
  Future<CrmStatsModel> fetchStats(AnalyticsPeriod period);
  Future<List<AnalyticsClient>> fetchClients();
  Future<List<AnalyticsContract>> fetchContracts();
  Future<List<AnalyticsPayment>> fetchPayments();
  Future<List<AnalyticsProject>> fetchProjects();
  Future<List<AnalyticsApartment>> fetchApartments();
  Future<PdfGenerationResult> exportStatsPdf({
    required CrmStatsModel stats,
    required List<AnalyticsContract> contracts,
    required AnalyticsPeriod period,
    required PdfTranslations translations,
  });

  CrmStatsModel? getCachedStats(AnalyticsPeriod period);
  List<AnalyticsClient>? getCachedClients();
  List<AnalyticsContract>? getCachedContracts();
  List<AnalyticsPayment>? getCachedPayments();
  List<AnalyticsProject>? getCachedProjects();
  List<AnalyticsApartment>? getCachedApartments();

  DateTime? getLastUpdated();
}

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsRemoteDataSource remoteDataSource;
  final AnalyticsCache cache;
  final AnalyticsPdfGenerator _pdfGenerator = AnalyticsPdfGenerator();

  AnalyticsRepositoryImpl({
    required this.remoteDataSource,
    required this.cache,
  });

  @override
  Future<CrmStatsModel> fetchStats(AnalyticsPeriod period) async {
    final stats = await remoteDataSource.getStats(period);
    await cache.saveStats(period, stats.toJson());
    return stats;
  }

  @override
  Future<List<AnalyticsClient>> fetchClients() async {
    final clients = await remoteDataSource.getClients();
    await cache.saveClients(clients.map((e) => e.toJson()).toList());
    return clients;
  }

  @override
  Future<List<AnalyticsContract>> fetchContracts() async {
    final contracts = await remoteDataSource.getContracts();
    await cache.saveContracts(contracts.map((e) => e.toJson()).toList());
    return contracts;
  }

  @override
  Future<List<AnalyticsPayment>> fetchPayments() async {
    final payments = await remoteDataSource.getPayments();
    await cache.savePayments(payments.map((e) => e.toJson()).toList());
    return payments;
  }

  @override
  Future<List<AnalyticsProject>> fetchProjects() async {
    final projects = await remoteDataSource.getProjects();
    await cache.saveProjects(projects.map((e) => e.toJson()).toList());
    return projects;
  }

  @override
  Future<List<AnalyticsApartment>> fetchApartments() async {
    final apartments = await remoteDataSource.getApartments();
    await cache.saveApartments(apartments.map((e) => e.toJson()).toList());
    return apartments;
  }

  @override
  CrmStatsModel? getCachedStats(AnalyticsPeriod period) {
    final raw = cache.getStats(period);
    if (raw == null) return null;
    return CrmStatsModel.fromJson(raw);
  }

  @override
  List<AnalyticsClient>? getCachedClients() {
    final raw = cache.getClients();
    if (raw == null) return null;
    return raw.map(AnalyticsClient.fromJson).toList();
  }

  @override
  List<AnalyticsContract>? getCachedContracts() {
    final raw = cache.getContracts();
    if (raw == null) return null;
    return raw.map(AnalyticsContract.fromJson).toList();
  }

  @override
  List<AnalyticsPayment>? getCachedPayments() {
    final raw = cache.getPayments();
    if (raw == null) return null;
    return raw.map(AnalyticsPayment.fromJson).toList();
  }

  @override
  List<AnalyticsProject>? getCachedProjects() {
    final raw = cache.getProjects();
    if (raw == null) return null;
    return raw.map(AnalyticsProject.fromJson).toList();
  }

  @override
  List<AnalyticsApartment>? getCachedApartments() {
    final raw = cache.getApartments();
    if (raw == null) return null;
    return raw.map(AnalyticsApartment.fromJson).toList();
  }

  @override
  DateTime? getLastUpdated() => cache.getLastUpdated();

  @override
  Future<PdfGenerationResult> exportStatsPdf({
    required CrmStatsModel stats,
    required List<AnalyticsContract> contracts,
    required AnalyticsPeriod period,
    required PdfTranslations translations,
  }) async {
    return _pdfGenerator.generateReport(
      stats: stats,
      contracts: contracts,
      period: period,
      translations: translations,
    );
  }
}

// Legacy enums kept for backwards compatibility with old analytics widgets.
enum AnalyticsDateRange {
  thisMonth,
  lastMonth,
  thisQuarter,
  thisYear,
  custom,
}
