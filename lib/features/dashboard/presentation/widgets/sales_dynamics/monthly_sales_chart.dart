import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../data/models/crm_stats_model.dart';
import 'summary_cards.dart';

/// Monthly sales chart section
class MonthlySalesChart extends StatelessWidget {
  final List<MonthlySalesModel> monthlySales;

  const MonthlySalesChart({super.key, required this.monthlySales});

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
            'dashboard_monthly_sales'.tr(),
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.titleLarge?.color,
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 220.h,
            child: monthlySales.isEmpty
                ? Center(
                    child: Text(
                      'dashboard_no_data'.tr(),
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        color: theme.textTheme.bodySmall?.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : BarChart(_buildBarChartData(context)),
          ),
        ],
      ),
    );
  }

  BarChartData _buildBarChartData(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    final maxValue = monthlySales
        .map((m) => m.amount)
        .fold<double>(0, (prev, value) => value > prev ? value : prev);
    final chartMax = maxValue == 0 ? 100.0 : maxValue * 1.2;
    final double interval = chartMax / 4;

    return BarChartData(
      maxY: chartMax,
      minY: 0,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: interval,
        getDrawingHorizontalLine: (value) => FlLine(
          color: borderColor,
          strokeWidth: 1.w,
          dashArray: [4.w.round(), 4.w.round()],
        ),
      ),
      borderData: FlBorderData(show: false),
      barTouchData: BarTouchData(
        enabled: true,
        handleBuiltInTouches: true,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: isDark ? AppColors.darkSurface : AppColors.textPrimary,
          tooltipRoundedRadius: 12.r,
          tooltipPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            final data = monthlySales[group.x.toInt()];
            return BarTooltipItem(
              '${data.name}\n${CurrencyFormatter.format(data.amount)}',
              GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            );
          },
        ),
      ),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28.h,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index < 0 || index >= monthlySales.length) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Text(
                  monthlySales[index].name,
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40.w,
            interval: interval,
            getTitlesWidget: (value, meta) {
              return Padding(
                padding: EdgeInsets.only(right: 6.w),
                child: Text(
                  _formatAxisValue(value),
                  style: GoogleFonts.inter(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w500,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  textAlign: TextAlign.right,
                ),
              );
            },
          ),
        ),
      ),
      barGroups: monthlySales.asMap().entries.map((entry) {
        final index = entry.key;
        final data = entry.value;
        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: data.amount,
              width: 16.w,
              borderRadius: BorderRadius.circular(6.r),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withValues(alpha: 0.7),
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  String _formatAxisValue(double value) {
    if (value >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(1)} ${'dashboard_unit_billion'.tr()}';
    }
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(0)} ${'dashboard_unit_million'.tr()}';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)} ${'dashboard_unit_thousand'.tr()}';
    }
    return value.toStringAsFixed(0);
  }
}
