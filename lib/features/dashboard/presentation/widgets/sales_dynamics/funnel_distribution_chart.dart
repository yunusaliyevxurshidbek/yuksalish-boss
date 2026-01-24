import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/constants/app_colors.dart';

/// Funnel stage configuration
class FunnelStageConfig {
  final String apiKey;
  final String label;
  final Color color;

  const FunnelStageConfig(this.apiKey, this.label, this.color);
}

/// Funnel distribution donut chart
class FunnelDistributionChart extends StatelessWidget {
  final Map<String, int> leadsByStage;

  const FunnelDistributionChart({super.key, required this.leadsByStage});

  static List<FunnelStageConfig> get stageConfigs => [
    FunnelStageConfig('new', 'dashboard_funnel_stage_new'.tr(), AppColors.funnelNew),
    FunnelStageConfig('contacted', 'dashboard_funnel_stage_contacted'.tr(), AppColors.funnelContacted),
    FunnelStageConfig('qualified', 'dashboard_funnel_stage_qualified'.tr(), AppColors.funnelQualified),
    FunnelStageConfig('showing', 'dashboard_funnel_stage_showing'.tr(), AppColors.funnelShowing),
    FunnelStageConfig('negotiation', 'dashboard_funnel_stage_negotiation'.tr(), AppColors.funnelNegotiation),
    FunnelStageConfig('reservation', 'dashboard_funnel_stage_reservation'.tr(), AppColors.funnelReservation),
    FunnelStageConfig('contract', 'dashboard_funnel_stage_contract'.tr(), AppColors.funnelContract),
    FunnelStageConfig('won', 'dashboard_funnel_stage_won'.tr(), AppColors.funnelWon),
  ];

  int get totalCount =>
      leadsByStage.values.fold<int>(0, (sum, count) => sum + count);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'dashboard_funnel_title'.tr(),
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.titleLarge?.color,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 180.h,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 50.r,
                          sections: _buildPieSections(context),
                          pieTouchData: PieTouchData(
                            touchCallback: (event, response) {},
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$totalCount',
                            style: GoogleFonts.inter(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w700,
                              color: theme.textTheme.titleLarge?.color,
                            ),
                          ),
                          Text(
                            'dashboard_funnel_total_leads'.tr(),
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: theme.textTheme.bodySmall?.color,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildLegend(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieSections(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    if (totalCount == 0) {
      return [
        PieChartSectionData(
          value: 1,
          color: borderColor,
          radius: 25.r,
          showTitle: false,
        ),
      ];
    }

    return stageConfigs
        .where((config) => leadsByStage.containsKey(config.apiKey))
        .map((config) {
      final count = leadsByStage[config.apiKey] ?? 0;
      if (count == 0) return null;
      return PieChartSectionData(
        value: count.toDouble(),
        color: config.color,
        radius: 25.r,
        showTitle: false,
      );
    }).whereType<PieChartSectionData>().toList();
  }

  Widget _buildLegend(BuildContext context) {
    final theme = Theme.of(context);

    final items = stageConfigs
        .where((config) => leadsByStage.containsKey(config.apiKey))
        .map((config) {
      final count = leadsByStage[config.apiKey] ?? 0;
      final percentage =
          totalCount > 0 ? (count / totalCount * 100).toStringAsFixed(0) : '0';
      return _LegendItem(
        color: config.color,
        label: config.label,
        count: count,
        percentage: percentage,
        theme: theme,
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: items.take(6).toList(),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final int count;
  final String percentage;
  final ThemeData theme;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.count,
    required this.percentage,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: theme.textTheme.bodySmall?.color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '$percentage% ($count)',
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.titleMedium?.color,
            ),
          ),
        ],
      ),
    );
  }
}
