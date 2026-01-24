import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../dashboard/data/models/crm_stats_model.dart';

class SoldApartmentsSalesChart extends StatelessWidget {
  final List<MonthlySalesModel> monthlySales;

  const SoldApartmentsSalesChart({super.key, required this.monthlySales});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (monthlySales.isEmpty) {
      return const SizedBox.shrink();
    }

    final maxAmount = monthlySales
        .map((e) => e.amount)
        .reduce((a, b) => a > b ? a : b);
    final totalContracts = monthlySales
        .map((e) => e.contractsCount)
        .fold(0, (a, b) => a + b);

    // Calculate nice Y axis values
    final double maxY = maxAmount > 0 ? (maxAmount * 1.2) : 100;
    final double interval = _calculateInterval(maxY);

    // Get the year for the title
    final currentYear = monthlySales.isNotEmpty
        ? monthlySales.last.year
        : DateTime.now().year;

    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'sold_apartments_sales_dynamics'.tr(),
                    style: AppTextStyles.h4.copyWith(
                      color: theme.textTheme.titleLarge?.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'sold_apartments_year_label'.tr(args: ['$currentYear']),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
                ),
                child: Text(
                  'sold_apartments_contracts_count'.tr(args: ['$totalContracts']),
                  style: AppTextStyles.labelMedium.copyWith(
                    color: const Color(0xFF10B981),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.p20.h),
          SizedBox(
            height: 200.h,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                minY: 0,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: isDark ? AppColors.darkSurface : AppColors.textPrimary,
                    tooltipRoundedRadius: AppSizes.radiusS.r,
                    tooltipPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final data = monthlySales[group.x.toInt()];
                      return BarTooltipItem(
                        '${data.name} ${data.year}\n${_formatAmount(data.amount)}\n${data.contractsCount} ta shartnoma',
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
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < monthlySales.length) {
                          return Padding(
                            padding: EdgeInsets.only(top: 8.h),
                            child: Text(
                              monthlySales[index].name,
                              style: AppTextStyles.labelMedium.copyWith(
                                color: theme.textTheme.bodySmall?.color,
                                fontWeight: FontWeight.w500,
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
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: interval,
                      reservedSize: 50.w,
                      getTitlesWidget: (value, meta) {
                        if (value == meta.max) return const SizedBox.shrink();
                        return Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child: Text(
                            _formatAxisLabel(value),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: theme.textTheme.bodySmall?.color,
                              fontSize: 10.sp,
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
                barGroups: monthlySales.asMap().entries.map((entry) {
                  final index = entry.key;
                  final data = entry.value;
                  final hasValue = data.amount > 0;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: data.amount > 0 ? data.amount : maxY * 0.02,
                        gradient: hasValue
                            ? const LinearGradient(
                                colors: [Color(0xFF10B981), Color(0xFF059669)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              )
                            : null,
                        color: hasValue ? null : borderColor.withValues(alpha: 0.5),
                        width: 24.w,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(6.r),
                        ),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: maxY,
                          color: borderColor.withValues(alpha: 0.2),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateInterval(double maxY) {
    if (maxY <= 1000000) return 200000; // 200K
    if (maxY <= 10000000) return 2000000; // 2M
    if (maxY <= 100000000) return 20000000; // 20M
    if (maxY <= 1000000000) return 200000000; // 200M
    if (maxY <= 5000000000) return 1000000000; // 1B
    if (maxY <= 10000000000) return 2000000000; // 2B
    return (maxY / 5).ceilToDouble();
  }

  String _formatAxisLabel(double value) {
    if (value >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(1)} mlrd';
    } else if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(0)} mln';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return value.toStringAsFixed(0);
  }

  String _formatAmount(double value) {
    if (value >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(2)} mlrd so\'m';
    } else if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)} mln so\'m';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)} ming so\'m';
    }
    return '${value.toStringAsFixed(0)} so\'m';
  }
}
