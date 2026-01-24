import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';

class SoldApartmentsRoomChart extends StatelessWidget {
  final Map<int, int> distribution;

  const SoldApartmentsRoomChart({super.key, required this.distribution});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    if (distribution.isEmpty) {
      return const SizedBox.shrink();
    }

    final sortedEntries = distribution.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    final maxValue = sortedEntries.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final totalCount = sortedEntries.map((e) => e.value).fold(0, (a, b) => a + b);

    // Calculate nice Y axis interval
    final double maxY = (maxValue * 1.2).ceilToDouble();
    final double interval = _calculateInterval(maxY);

    return Container(
      padding: EdgeInsets.all(AppSizes.p20.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'sold_apartments_distribution'.tr(),
                style: AppTextStyles.h4.copyWith(
                  color: theme.textTheme.titleLarge?.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
                ),
                child: Text(
                  'sold_apartments_total_count'.tr(args: ['$totalCount']),
                  style: AppTextStyles.labelMedium.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.p20.h),
          SizedBox(
            height: 220.h,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                minY: 0,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: AppColors.textPrimary,
                    tooltipRoundedRadius: AppSizes.radiusS.r,
                    tooltipPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final entry = sortedEntries[group.x.toInt()];
                      final percentage = totalCount > 0
                          ? (entry.value / totalCount * 100).toStringAsFixed(1)
                          : '0';
                      return BarTooltipItem(
                        '${entry.key} xonali\n${entry.value} ta ($percentage%)',
                        AppTextStyles.bodySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    axisNameWidget: Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Text(
                        'sold_apartments_room_count'.tr(),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                    ),
                    axisNameSize: 24.h,
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < sortedEntries.length) {
                          return Padding(
                            padding: EdgeInsets.only(top: 8.h),
                            child: Text(
                              '${sortedEntries[index].key}',
                              style: AppTextStyles.labelMedium.copyWith(
                                color: theme.textTheme.bodySmall?.color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                      reservedSize: 28.h,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    axisNameWidget: Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Text(
                        'Soni',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                    ),
                    axisNameSize: 20.w,
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: interval,
                      reservedSize: 40.w,
                      getTitlesWidget: (value, meta) {
                        if (value == meta.max) return const SizedBox.shrink();
                        return Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child: Text(
                            value.toInt().toString(),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: theme.textTheme.bodySmall?.color,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: interval,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: borderColor,
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    );
                  },
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(color: borderColor, width: 1),
                    left: BorderSide(color: borderColor, width: 1),
                  ),
                ),
                barGroups: sortedEntries.asMap().entries.map((entry) {
                  final index = entry.key;
                  final data = entry.value;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: data.value.toDouble(),
                        gradient: LinearGradient(
                          colors: [
                            _getBarColor(data.key),
                            _getBarColor(data.key).withValues(alpha: 0.7),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        width: 40.w,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(8.r),
                        ),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: maxY,
                          color: borderColor.withValues(alpha: 0.3),
                        ),
                      ),
                    ],
                    showingTooltipIndicators: [],
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(height: AppSizes.p16.h),
          // Legend
          _buildLegend(context, sortedEntries, totalCount),
        ],
      ),
    );
  }

  Widget _buildLegend(BuildContext context, List<MapEntry<int, int>> sortedEntries, int totalCount) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: 16.w,
      runSpacing: 8.h,
      children: sortedEntries.map((entry) {
        final percentage = totalCount > 0
            ? (entry.value / totalCount * 100).toStringAsFixed(1)
            : '0';
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: _getBarColor(entry.key),
                borderRadius: BorderRadius.circular(3.r),
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              '${entry.key} xona: ${entry.value} ($percentage%)',
              style: AppTextStyles.bodySmall.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  double _calculateInterval(double maxY) {
    if (maxY <= 5) return 1;
    if (maxY <= 10) return 2;
    if (maxY <= 25) return 5;
    if (maxY <= 50) return 10;
    if (maxY <= 100) return 20;
    if (maxY <= 250) return 50;
    if (maxY <= 500) return 100;
    return (maxY / 5).ceilToDouble();
  }

  Color _getBarColor(int rooms) {
    switch (rooms) {
      case 1:
        return const Color(0xFF3B82F6);
      case 2:
        return const Color(0xFF22C55E);
      case 3:
        return const Color(0xFF8B5CF6);
      case 4:
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF6366F1);
    }
  }
}
