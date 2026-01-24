import 'package:yuksalish_mobile/core/constants/app_colors.dart';
import 'package:yuksalish_mobile/features/dashboard/data/datasources/crm_stats_remote_datasource.dart';
import 'package:yuksalish_mobile/features/dashboard/data/models/dashboard_metrics.dart';
import 'package:yuksalish_mobile/features/dashboard/data/models/funnel_data.dart';
import 'package:yuksalish_mobile/features/dashboard/data/models/sales_data.dart';

/// Filter period for dashboard data
enum DashboardPeriod {
  today,
  week,
  month,
  quarter,
  year,
}

/// Repository for dashboard data operations
abstract class DashboardRepository {
  Future<DashboardMetrics> getMetrics(DashboardPeriod period);
  Future<List<SalesData>> getSalesData(DashboardPeriod period);
  Future<List<FunnelData>> getFunnelData(DashboardPeriod period);
}

/// Implementation of DashboardRepository with real API data
class DashboardRepositoryImpl implements DashboardRepository {
  final CrmStatsRemoteDataSource _statsDataSource;

  DashboardRepositoryImpl(this._statsDataSource);

  @override
  Future<DashboardMetrics> getMetrics(DashboardPeriod period) async {
    final stats = await _statsDataSource.getStats(period);
    return stats.toDashboardMetrics();
  }

  @override
  Future<List<SalesData>> getSalesData(DashboardPeriod period) async {
    final stats = await _statsDataSource.getStats(period);
    return stats.monthlySales
        .map(
          (item) => SalesData(
            month: item.name,
            year: item.year,
            amount: item.amount,
            count: item.contractsCount,
          ),
        )
        .toList();
  }

  @override
  Future<List<FunnelData>> getFunnelData(DashboardPeriod period) async {
    final stats = await _statsDataSource.getStats(period);
    return _mapLeadsByStageToFunnelData(stats.leadsByStage);
  }

  /// Maps API leads_by_stage data to FunnelData list with proper ordering and colors
  List<FunnelData> _mapLeadsByStageToFunnelData(Map<String, int> leadsByStage) {
    // Stage order and configuration
    const stageConfig = [
      ('new', 'Yangi', AppColors.funnelNew),
      ('contacted', "Bog'lanildi", AppColors.funnelContacted),
      ('qualified', 'Kvalif.', AppColors.funnelQualified),
      ('showing', "Ko'rsatuv", AppColors.funnelShowing),
      ('negotiation', 'Muzokara', AppColors.funnelNegotiation),
      ('reservation', 'Bron', AppColors.funnelReservation),
      ('contract', 'Shartnoma', AppColors.funnelContract),
      ('won', 'Sotilgan', AppColors.funnelWon),
    ];

    return stageConfig
        .where((config) => leadsByStage.containsKey(config.$1))
        .map((config) => FunnelData(
              stage: config.$2,
              count: leadsByStage[config.$1] ?? 0,
              color: config.$3,
            ))
        .toList();
  }
}
