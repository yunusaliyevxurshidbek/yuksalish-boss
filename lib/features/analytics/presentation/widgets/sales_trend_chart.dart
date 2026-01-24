import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/sales_trend.dart';
import '../theme/analytics_theme.dart';
import '../utils/analytics_utils.dart';
import 'analytics_empty_state.dart';

/// Premium sales trend line chart with gradient fill and dashed grid lines
/// Features smooth curves, dark tooltips, and responsive design
class SalesTrendChart extends StatefulWidget {
  const SalesTrendChart({
    super.key,
    required this.data,
    this.height = 250,
    this.lineColor,
  });

  final List<SalesTrend> data;
  final double height;
  final Color? lineColor;

  @override
  State<SalesTrendChart> createState() => _SalesTrendChartState();
}

class _SalesTrendChartState extends State<SalesTrendChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AnalyticsPremiumColors.of(context);
    if (widget.data.isEmpty) {
      return SizedBox(
        height: widget.height.h,
        child: AnalyticsEmptyStateCompact(
          message: 'analytics_sales_no_data'.tr(),
          icon: Icons.show_chart_rounded,
        ),
      );
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          height: widget.height.h,
          child: Padding(
            padding: EdgeInsets.only(right: AppSizes.p8.w),
            child: LineChart(_buildChartData(colors)),
          ),
        );
      },
    );
  }

  LineChartData _buildChartData(AnalyticsPremiumColors colors) {
    final maxY =
        widget.data.map((e) => e.amount).reduce((a, b) => a > b ? a : b);
    final normalizedMax = (maxY / 1000000000).ceil() * 1000000000.0;
    final safeMax = normalizedMax == 0 ? 1 : normalizedMax;
    final chartColor = widget.lineColor ?? colors.chartLine;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: safeMax / 4,
        getDrawingHorizontalLine: (value) => FlLine(
          color: colors.chartGridLine,
          strokeWidth: 1,
          dashArray: [5, 5], // Dashed lines
        ),
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 50.w,
            interval: safeMax / 4,
            getTitlesWidget: (value, meta) => _buildLeftTitle(value),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 32.h,
            interval: 1,
            getTitlesWidget: (value, meta) => _buildBottomTitle(value),
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: (widget.data.length - 1).toDouble(),
      minY: 0,
      maxY: safeMax * _animation.value,
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: colors.tooltipBackground,
          tooltipRoundedRadius: 12.r,
          tooltipPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 10.h,
          ),
          tooltipMargin: 12.h,
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              final data = widget.data[spot.x.toInt()];
              return LineTooltipItem(
                '${data.month}\n',
                AppTextStyles.caption.copyWith(
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  TextSpan(
                    text: formatCurrency(data.amount),
                    style: AppTextStyles.labelLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              );
            }).toList();
          },
        ),
        handleBuiltInTouches: true,
        getTouchedSpotIndicator: (barData, spotIndexes) {
          return spotIndexes.map((spotIndex) {
            return TouchedSpotIndicatorData(
              FlLine(
                color: chartColor.withValues(alpha: 0.3),
                strokeWidth: 2,
                dashArray: [4, 4],
              ),
              FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 6.r,
                    color: colors.cardBackground,
                    strokeWidth: 3,
                    strokeColor: chartColor,
                  );
                },
              ),
            );
          }).toList();
        },
      ),
      lineBarsData: [
        LineChartBarData(
          spots: widget.data.asMap().entries.map((entry) {
            return FlSpot(
              entry.key.toDouble(),
              entry.value.amount * _animation.value,
            );
          }).toList(),
          isCurved: true,
          curveSmoothness: 0.35,
          color: chartColor,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 5.r,
                color: colors.cardBackground,
                strokeWidth: 2.5,
                strokeColor: chartColor,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: AnalyticsGradients.chartArea(chartColor),
          ),
        ),
      ],
    );
  }

  Widget _buildLeftTitle(double value) {
    final text = formatChartCurrency(value);
    final colors = AnalyticsPremiumColors.of(context);
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(
          color: colors.textMuted,
          fontSize: 10.sp,
        ),
        textAlign: TextAlign.right,
      ),
    );
  }

  Widget _buildBottomTitle(double value) {
    final index = value.toInt();
    if (index < 0 || index >= widget.data.length) {
      return const SizedBox.shrink();
    }
    final colors = AnalyticsPremiumColors.of(context);
    // Show every other month for readability when many data points
    if (index % 2 != 0 && widget.data.length > 6) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Text(
        widget.data[index].month,
        style: AppTextStyles.caption.copyWith(
          color: colors.textMuted,
          fontSize: 10.sp,
        ),
      ),
    );
  }
}
