import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../theme/analytics_theme.dart';

class ContractsDayData {
  final String label;
  final int count;
  final int signed;
  final int cancelled;

  const ContractsDayData({
    required this.label,
    required this.count,
    this.signed = 0,
    this.cancelled = 0,
  });

  /// Creates grouped data with signed and cancelled counts
  factory ContractsDayData.grouped({
    required String label,
    required int signed,
    required int cancelled,
  }) {
    return ContractsDayData(
      label: label,
      count: signed + cancelled,
      signed: signed,
      cancelled: cancelled,
    );
  }

  bool get hasGroupedData => signed > 0 || cancelled > 0;
}

class ContractsLineChart extends StatelessWidget {
  final List<ContractsDayData> data;
  final double height;
  final bool showAsGroupedBars;

  const ContractsLineChart({
    super.key,
    required this.data,
    this.height = 200,
    this.showAsGroupedBars = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AnalyticsPremiumColors.of(context);
    if (data.isEmpty) {
      return SizedBox(
        height: height.h,
        child: Center(
          child: Text(
            'analytics_contracts_no_data'.tr(),
            style: AppTextStyles.bodyMedium,
          ),
        ),
      );
    }

    final hasGrouped = data.any((d) => d.hasGroupedData);

    if (showAsGroupedBars && hasGrouped) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLegend(colors),
          SizedBox(height: AppSizes.p12.h),
          SizedBox(
            height: height.h,
            child: BarChart(_buildGroupedBarData(colors)),
          ),
        ],
      );
    }

    return SizedBox(
      height: height.h,
      child: LineChart(_buildChartData(colors)),
    );
  }

  Widget _buildLegend(AnalyticsPremiumColors colors) {
    return Wrap(
      spacing: AppSizes.p16.w,
      runSpacing: AppSizes.p8.h,
      children: [
        _legendItem('analytics_contracts_signed'.tr(), colors.success, colors),
        _legendItem('analytics_contracts_cancelled'.tr(), colors.danger, colors),
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
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: colors.textMuted,
          ),
        ),
      ],
    );
  }

  BarChartData _buildGroupedBarData(AnalyticsPremiumColors colors) {
    final maxCount = data.map((e) {
      final maxInGroup = e.signed > e.cancelled ? e.signed : e.cancelled;
      return maxInGroup > 0 ? maxInGroup : e.count;
    }).reduce((a, b) => a > b ? a : b);
    final rawMaxY = (maxCount * 1.3).toDouble();
    final maxY = rawMaxY <= 0 ? 4.0 : rawMaxY;

    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: maxY,
      minY: 0,
      groupsSpace: 12.w,
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: colors.tooltipBackground,
          tooltipRoundedRadius: AppSizes.radiusS.r,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            final item = data[group.x.toInt()];
            final label = rodIndex == 0 ? 'analytics_contracts_signed'.tr() : 'analytics_contracts_cancelled'.tr();
            final count = rodIndex == 0 ? item.signed : item.cancelled;
            return BarTooltipItem(
              '${item.label}\n${'analytics_contracts_tooltip'.tr(namedArgs: {'label': label, 'count': '$count'})}',
              AppTextStyles.labelSmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
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
            getTitlesWidget: (value, meta) =>
                _buildBottomTitle(value.toInt(), colors),
            reservedSize: 28.h,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30.w,
            interval: maxY / 4,
            getTitlesWidget: (value, meta) => Padding(
              padding: EdgeInsets.only(right: 6.w),
              child: Text(
                value.toInt().toString(),
                style: AppTextStyles.caption.copyWith(
                  color: colors.textMuted,
                ),
              ),
            ),
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: maxY / 4,
        getDrawingHorizontalLine: (value) => FlLine(
          color: colors.chartGridLine,
          strokeWidth: 1,
        ),
      ),
      borderData: FlBorderData(show: false),
      barGroups: _buildGroupedBars(colors),
    );
  }

  List<BarChartGroupData> _buildGroupedBars(AnalyticsPremiumColors colors) {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;

      return BarChartGroupData(
        x: index,
        barsSpace: 4.w,
        barRods: [
          // Signed (green)
          BarChartRodData(
            toY: item.signed.toDouble(),
            width: 10.w,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4.r),
              topRight: Radius.circular(4.r),
            ),
            color: colors.success,
          ),
          // Cancelled (red)
          BarChartRodData(
            toY: item.cancelled.toDouble(),
            width: 10.w,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4.r),
              topRight: Radius.circular(4.r),
            ),
            color: colors.danger,
          ),
        ],
      );
    }).toList();
  }

  LineChartData _buildChartData(AnalyticsPremiumColors colors) {
    final maxCount = data.map((e) => e.count).reduce((a, b) => a > b ? a : b);
    final rawMaxY = (maxCount * 1.4).toDouble();
    final maxY = rawMaxY <= 0 ? 4.0 : rawMaxY;

    return LineChartData(
      minX: 0,
      maxX: (data.length - 1).toDouble(),
      minY: 0,
      maxY: maxY,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: maxY / 4,
        getDrawingHorizontalLine: (value) => FlLine(
          color: colors.chartGridLine,
          strokeWidth: 1,
        ),
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30.w,
            interval: maxY / 4,
            getTitlesWidget: (value, meta) => Padding(
              padding: EdgeInsets.only(right: 6.w),
              child: Text(
                value.toInt().toString(),
                style: AppTextStyles.caption.copyWith(
                  color: colors.textMuted,
                ),
              ),
            ),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28.h,
            interval: 1,
            getTitlesWidget: (value, meta) =>
                _buildBottomTitle(value.toInt(), colors),
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: colors.tooltipBackground,
          tooltipRoundedRadius: AppSizes.radiusS.r,
          getTooltipItems: (spots) {
            return spots.map((spot) {
              final item = data[spot.x.toInt()];
              return LineTooltipItem(
                '${item.label}\n${'analytics_contracts_count'.tr(namedArgs: {'count': '${item.count}'})}',
                AppTextStyles.labelSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              );
            }).toList();
          },
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          isCurved: true,
          color: colors.primary,
          barWidth: 2,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4.r,
                color: colors.cardBackground,
                strokeWidth: 2,
                strokeColor: colors.primary,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: false,
          ),
          spots: data.asMap().entries.map((entry) {
            return FlSpot(entry.key.toDouble(), entry.value.count.toDouble());
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBottomTitle(int index, AnalyticsPremiumColors colors) {
    if (index < 0 || index >= data.length) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: EdgeInsets.only(top: 6.h),
      child: Text(
        data[index].label,
        style: AppTextStyles.caption.copyWith(
          color: colors.textMuted,
        ),
      ),
    );
  }
}
