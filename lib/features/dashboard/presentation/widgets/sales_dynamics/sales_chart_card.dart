import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../data/models/sales_dynamics_models.dart';

/// Chart card showing sales vs target bar chart.
class SalesChartCard extends StatelessWidget {
  final List<SalesDynamicsPoint> chartData;

  const SalesChartCard({
    super.key,
    required this.chartData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.salesCard,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.salesShadow.withValues(alpha: 0.08),
            blurRadius: 20.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'dashboard_sales_target'.tr(),
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.salesTextPrimary,
                  ),
                ),
              ),
              _LegendItem(label: 'dashboard_sales_label'.tr(), color: AppColors.salesPrimary),
              SizedBox(width: 12.w),
              _LegendItem(label: 'dashboard_target_label'.tr(), color: AppColors.salesTarget),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 260.h,
            child: chartData.isEmpty
                ? Center(
                    child: Text(
                      'dashboard_no_data'.tr(),
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        color: AppColors.salesTextMuted,
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
    final maxValue = chartData
        .map((point) => max(point.sales, point.target))
        .fold<double>(0, (prev, value) => value > prev ? value : prev);
    final chartMax = maxValue == 0 ? 100 : maxValue * 1.25;

    return BarChartData(
      maxY: chartMax.toDouble(),
      minY: 0,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: chartMax / 4,
        getDrawingHorizontalLine: (value) => FlLine(
          color: AppColors.salesBorder,
          strokeWidth: 1.w,
          dashArray: [4.w.round(), 4.w.round()],
        ),
      ),
      borderData: FlBorderData(show: false),
      barTouchData: BarTouchData(
        enabled: true,
        handleBuiltInTouches: true,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: AppColors.salesTextPrimary,
          tooltipRoundedRadius: 12.r,
          tooltipPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            final point = chartData[group.x.toInt()];
            final label = rodIndex == 0 ? 'dashboard_sales_label'.tr() : 'dashboard_target_label'.tr();
            return BarTooltipItem(
              '${point.label}\n$label: ${rod.toY.toStringAsFixed(0)} ${'dashboard_unit_billion'.tr()}',
              GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.salesCard,
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
              if (index < 0 || index >= chartData.length) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Text(
                  chartData[index].label,
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.salesTextSecondary,
                  ),
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 32.w,
            interval: chartMax / 4,
            getTitlesWidget: (value, meta) {
              return Padding(
                padding: EdgeInsets.only(right: 6.w),
                child: Text(
                  value.toStringAsFixed(0),
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.salesTextMuted,
                  ),
                  textAlign: TextAlign.right,
                ),
              );
            },
          ),
        ),
      ),
      groupsSpace: 12.w,
      barGroups: chartData.asMap().entries.map((entry) {
        final index = entry.key;
        final point = entry.value;
        return BarChartGroupData(
          x: index,
          barsSpace: 6.w,
          barRods: [
            BarChartRodData(
              toY: point.sales,
              width: 10.w,
              borderRadius: BorderRadius.circular(6.r),
              color: AppColors.salesPrimary,
            ),
            BarChartRodData(
              toY: point.target,
              width: 10.w,
              borderRadius: BorderRadius.circular(6.r),
              color: AppColors.salesTarget,
            ),
          ],
        );
      }).toList(),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final Color color;

  const _LegendItem({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.salesTextSecondary,
          ),
        ),
      ],
    );
  }
}
