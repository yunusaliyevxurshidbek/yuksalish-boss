import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../theme/analytics_theme.dart';
import 'analytics_empty_state.dart';

class InventoryBarData {
  final String name;
  final int available;
  final int reserved;
  final int sold;

  const InventoryBarData({
    required this.name,
    required this.available,
    required this.reserved,
    required this.sold,
  });

  int get total => available + reserved + sold;
}

/// Premium stacked bar chart for inventory by project
/// Shows available, reserved, and sold units with rounded corners
class InventoryStackedChart extends StatelessWidget {
  final List<InventoryBarData> data;
  final double height;

  const InventoryStackedChart({
    super.key,
    required this.data,
    this.height = 220,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AnalyticsPremiumColors.of(context);
    if (data.isEmpty) {
      return SizedBox(
        height: height.h,
        child: AnalyticsEmptyStateCompact(
          message: 'analytics_inventory_no_data'.tr(),
          icon: Icons.inventory_2_outlined,
        ),
      );
    }

    return SizedBox(
      height: height.h,
      child: Column(
        children: [
          Expanded(
            child: BarChart(_buildChartData(colors)),
          ),
          SizedBox(height: AppSizes.p12.h),
          _buildLegend(colors),
        ],
      ),
    );
  }

  BarChartData _buildChartData(AnalyticsPremiumColors colors) {
    final maxTotal = data.map((e) => e.total).reduce((a, b) => a > b ? a : b);
    final maxY = (maxTotal * 1.2).toDouble();

    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: maxY <= 0 ? 1 : maxY,
      minY: 0,
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: colors.tooltipBackground,
          tooltipRoundedRadius: 12.r,
          tooltipPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 8.h,
          ),
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            final item = data[group.x.toInt()];
            return BarTooltipItem(
              '${item.name}\n',
              AppTextStyles.caption.copyWith(
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
              children: [
                TextSpan(
                  text: '${'analytics_inventory_available'.tr(namedArgs: {'count': '${item.available}'})}\n',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: colors.available,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: '${'analytics_inventory_reserved'.tr(namedArgs: {'count': '${item.reserved}'})}\n',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: colors.reserved,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: 'analytics_sold_count'.tr(namedArgs: {'count': '${item.sold}'}),
                  style: AppTextStyles.labelSmall.copyWith(
                    color: colors.sold,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            );
          },
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) =>
                _buildBottomTitle(value.toInt(), colors),
            reservedSize: 28.h,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 36.w,
            interval: maxY / 4,
            getTitlesWidget: (value, meta) => Padding(
              padding: EdgeInsets.only(right: 6.w),
              child: Text(
                value.toInt().toString(),
                style: AppTextStyles.caption.copyWith(
                  color: colors.textMuted,
                  fontSize: 10.sp,
                ),
              ),
            ),
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: maxY / 4,
        getDrawingHorizontalLine: (value) => FlLine(
          color: colors.chartGridLine,
          strokeWidth: 1,
          dashArray: [5, 5],
        ),
      ),
      borderData: FlBorderData(show: false),
      barGroups: _buildGroups(colors),
    );
  }

  List<BarChartGroupData> _buildGroups(AnalyticsPremiumColors colors) {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final total = item.total.toDouble();
      final available = item.available.toDouble();
      final reserved = item.reserved.toDouble();

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: total,
            width: 22.w,
            borderRadius: BorderRadius.circular(4.r),
            rodStackItems: [
              BarChartRodStackItem(0, available, colors.available),
              BarChartRodStackItem(
                  available, available + reserved, colors.reserved),
              BarChartRodStackItem(
                  available + reserved, total, colors.sold),
            ],
            color: Colors.transparent,
          ),
        ],
      );
    }).toList();
  }

  Widget _buildBottomTitle(int index, AnalyticsPremiumColors colors) {
    if (index < 0 || index >= data.length) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Text(
        data[index].name,
        style: AppTextStyles.caption.copyWith(
          color: colors.textMuted,
          fontSize: 10.sp,
        ),
      ),
    );
  }

  Widget _buildLegend(AnalyticsPremiumColors colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem('analytics_available_short'.tr(), colors.available, colors),
        SizedBox(width: 16.w),
        _legendItem('analytics_reserved_short'.tr(), colors.reserved, colors),
        SizedBox(width: 16.w),
        _legendItem('analytics_sold'.tr(), colors.sold, colors),
      ],
    );
  }

  Widget _legendItem(
    String label,
    Color color,
    AnalyticsPremiumColors colors,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: colors.textSubtitle,
          ),
        ),
      ],
    );
  }
}
