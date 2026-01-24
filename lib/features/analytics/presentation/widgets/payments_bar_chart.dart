import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../theme/analytics_theme.dart';
import '../utils/analytics_utils.dart';
import 'analytics_empty_state.dart';

class PaymentsChartData {
  final String label;
  final double total;
  final int count;
  final double received;
  final double pending;
  final double overdue;

  const PaymentsChartData({
    required this.label,
    required this.total,
    required this.count,
    this.received = 0,
    this.pending = 0,
    this.overdue = 0,
  });

  /// Creates stacked data from breakdown values
  factory PaymentsChartData.stacked({
    required String label,
    required double received,
    required double pending,
    required double overdue,
    required int count,
  }) {
    return PaymentsChartData(
      label: label,
      total: received + pending + overdue,
      count: count,
      received: received,
      pending: pending,
      overdue: overdue,
    );
  }

  bool get hasStackedData => received > 0 || pending > 0 || overdue > 0;
}

/// Premium bar chart for payments visualization
/// Features rounded corners, dashed grid lines, and dark tooltips
class PaymentsBarChart extends StatelessWidget {
  final List<PaymentsChartData> data;
  final double height;
  final bool showLegend;

  const PaymentsBarChart({
    super.key,
    required this.data,
    this.height = 220,
    this.showLegend = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AnalyticsPremiumColors.of(context);
    if (data.isEmpty) {
      return SizedBox(
        height: height.h,
        child: AnalyticsEmptyStateCompact(
          message: 'analytics_payment_no_data'.tr(),
          icon: Icons.payments_outlined,
        ),
      );
    }

    final hasStacked = data.any((d) => d.hasStackedData);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLegend && hasStacked) ...[
          _buildLegend(colors),
          SizedBox(height: AppSizes.p12.h),
        ],
        SizedBox(
          height: height.h,
          child: BarChart(_buildChartData(hasStacked, colors)),
        ),
      ],
    );
  }

  Widget _buildLegend(AnalyticsPremiumColors colors) {
    return Wrap(
      spacing: AppSizes.p16.w,
      runSpacing: AppSizes.p8.h,
      children: [
        _legendItem('analytics_payment_received'.tr(), colors.success, colors),
        _legendItem('analytics_pending_payments_label'.tr(), colors.warning, colors),
        _legendItem('analytics_overdue_payments_label'.tr(), colors.danger, colors),
      ],
    );
  }

  Widget _legendItem(String label, Color color, AnalyticsPremiumColors colors) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Circular bullet
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

  BarChartData _buildChartData(bool hasStacked, AnalyticsPremiumColors colors) {
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
            if (hasStacked) {
              return BarTooltipItem(
                '${item.label}\n',
                AppTextStyles.caption.copyWith(
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  TextSpan(
                    text: '${'analytics_payment_received_short'.tr(namedArgs: {'amount': formatCurrency(item.received)})}\n',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: colors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: '${'analytics_pending_amount'.tr(namedArgs: {'amount': formatCurrency(item.pending)})}\n',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: colors.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: 'analytics_overdue_amount'.tr(namedArgs: {'amount': formatCurrency(item.overdue)}),
                    style: AppTextStyles.labelSmall.copyWith(
                      color: colors.danger,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              );
            }
            return BarTooltipItem(
              '${item.label}\n',
              AppTextStyles.caption.copyWith(
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
              children: [
                TextSpan(
                  text: formatCurrency(item.total),
                  style: AppTextStyles.labelLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: ' • ${'analytics_payment_count'.tr(namedArgs: {'count': '${item.count}'})}',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white70,
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
            reservedSize: 50.w,
            interval: maxY / 4,
            getTitlesWidget: (value, meta) => Padding(
              padding: EdgeInsets.only(right: 6.w),
              child: Text(
                formatChartCurrency(value),
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
          dashArray: [5, 5], // Dashed lines
        ),
      ),
      borderData: FlBorderData(show: false),
      barGroups: hasStacked
          ? _buildStackedGroups(colors)
          : _buildGroups(colors),
    );
  }

  List<BarChartGroupData> _buildGroups(AnalyticsPremiumColors colors) {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: item.total,
            width: 20.w,
            borderRadius: BorderRadius.circular(4.r), // All corners rounded
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                colors.success,
                colors.success.withValues(alpha: 0.7),
              ],
            ),
          ),
        ],
      );
    }).toList();
  }

  List<BarChartGroupData> _buildStackedGroups(AnalyticsPremiumColors colors) {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;

      // Build stacked rod sections
      final rodStackItems = <BarChartRodStackItem>[];
      double fromY = 0;

      // Received (green) - bottom
      if (item.received > 0) {
        rodStackItems.add(BarChartRodStackItem(
          fromY,
          fromY + item.received,
          colors.success,
        ));
        fromY += item.received;
      }

      // Pending (yellow/warning) - middle
      if (item.pending > 0) {
        rodStackItems.add(BarChartRodStackItem(
          fromY,
          fromY + item.pending,
          colors.warning,
        ));
        fromY += item.pending;
      }

      // Overdue (red/danger) - top
      if (item.overdue > 0) {
        rodStackItems.add(BarChartRodStackItem(
          fromY,
          fromY + item.overdue,
          colors.danger,
        ));
      }

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: item.total,
            width: 20.w,
            borderRadius: BorderRadius.circular(4.r), // All corners rounded
            rodStackItems: rodStackItems,
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
        data[index].label,
        style: AppTextStyles.caption.copyWith(
          color: colors.textMuted,
          fontSize: 10.sp,
        ),
      ),
    );
  }
}
