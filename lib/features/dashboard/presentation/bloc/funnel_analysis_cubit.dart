import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/datasources/crm_stats_remote_datasource.dart';
import '../../data/models/funnel_models.dart';
import '../../data/repositories/dashboard_repository.dart';
import 'funnel_analysis_state.dart';

class FunnelAnalysisCubit extends Cubit<FunnelAnalysisState> {
  final CrmStatsRemoteDataSource _statsDataSource;

  FunnelAnalysisCubit({
    required CrmStatsRemoteDataSource statsDataSource,
  })  : _statsDataSource = statsDataSource,
        super(const FunnelAnalysisState());

  Future<void> loadFunnelData([DashboardPeriod period = DashboardPeriod.month]) async {
    emit(state.copyWith(status: FunnelAnalysisStatus.loading));

    try {
      final stats = await _statsDataSource.getStats(period);
      final stages = _mapLeadsByStageToFunnelStages(stats.leadsByStage);
      final kpis = _calculateKpis(stats.leadsByStage, stats.conversionRate);

      emit(state.copyWith(
        status: FunnelAnalysisStatus.loaded,
        stages: stages,
        kpis: kpis,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FunnelAnalysisStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> refresh([DashboardPeriod period = DashboardPeriod.month]) async {
    await loadFunnelData(period);
  }

  /// Maps API leads_by_stage data to FunnelStage list
  List<FunnelStage> _mapLeadsByStageToFunnelStages(Map<String, int> leadsByStage) {
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
        .map((config) => FunnelStage(
              name: config.$2,
              count: leadsByStage[config.$1] ?? 0,
              color: config.$3,
              clients: const [], // Clients list not available from stats API
            ))
        .toList();
  }

  /// Calculate KPIs from leads data
  List<FunnelKpi> _calculateKpis(Map<String, int> leadsByStage, double conversionRate) {
    final total = leadsByStage.values.fold<int>(0, (sum, count) => sum + count);
    final lost = leadsByStage.entries
        .where((e) => e.key != 'won' && e.key != 'contract')
        .fold<int>(0, (sum, e) => sum + e.value);

    // Calculate average time (placeholder - API doesn't provide this)
    final avgDays = total > 0 ? '${(total / 10).clamp(1, 30).toInt()} kun' : '-';

    return [
      FunnelKpi(
        label: 'dashboard_funnel_kpi_conversion',
        value: '${conversionRate.toStringAsFixed(0)}%',
        valueColor: AppColors.funnelReservation,
      ),
      FunnelKpi(
        label: "dashboard_funnel_kpi_lost",
        value: '$lost',
        valueColor: AppColors.errorColor,
      ),
      FunnelKpi(
        label: "dashboard_funnel_kpi_average_time",
        value: avgDays,
        valueColor: AppColors.funnelNew,
      ),
    ];
  }
}
