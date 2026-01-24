import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/monthly_income.dart';

/// Area chart showing monthly income vs expenses
class IncomeChart extends StatefulWidget {
  const IncomeChart({
    super.key,
    required this.data,
    this.height = 220,
  });

  final List<MonthlyIncome> data;
  final double height;

  @override
  State<IncomeChart> createState() => _IncomeChartState();
}

class _IncomeChartState extends State<IncomeChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _showIncome = true;
  bool _showExpenses = true;

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
    if (widget.data.isEmpty) {
      return SizedBox(
        height: widget.height.h,
        child: Center(
          child: Text(
            'analytics_income_no_data'.tr(),
            style: AppTextStyles.bodyMedium,
          ),
        ),
      );
    }

    return Column(
      children: [
        _buildLegendToggle(),
        SizedBox(height: AppSizes.p12.h),
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return SizedBox(
              height: widget.height.h,
              child: Padding(
                padding: EdgeInsets.only(right: AppSizes.p16.w),
                child: LineChart(_buildChartData()),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLegendToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildToggleChip(
          'analytics_income'.tr(),
          AppColors.chartGreen,
          _showIncome,
          (value) => setState(() => _showIncome = value),
        ),
        SizedBox(width: AppSizes.p12.w),
        _buildToggleChip(
          'analytics_expenses'.tr(),
          AppColors.chartRed,
          _showExpenses,
          (value) => setState(() => _showExpenses = value),
        ),
      ],
    );
  }

  Widget _buildToggleChip(
    String label,
    Color color,
    bool isActive,
    ValueChanged<bool> onChanged,
  ) {
    return GestureDetector(
      onTap: () => onChanged(!isActive),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.p12.w,
          vertical: AppSizes.p8.h,
        ),
        decoration: BoxDecoration(
          color: isActive ? color.withValues(alpha: 0.1) : AppColors.border,
          borderRadius: BorderRadius.circular(AppSizes.radiusFull.r),
          border: Border.all(
            color: isActive ? color : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: isActive ? color : AppColors.textTertiary,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: AppSizes.p8.w),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: isActive ? color : AppColors.textTertiary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData _buildChartData() {
    final maxIncome = widget.data.map((e) => e.income).reduce((a, b) => a > b ? a : b);
    final normalizedMax = (maxIncome / 1000000000).ceil() * 1000000000.0;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: normalizedMax / 4,
        getDrawingHorizontalLine: (value) => const FlLine(
          color: AppColors.border,
          strokeWidth: 1,
        ),
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 45.w,
            interval: normalizedMax / 4,
            getTitlesWidget: (value, meta) => _buildLeftTitle(value),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30.h,
            interval: 1,
            getTitlesWidget: (value, meta) => _buildBottomTitle(value),
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: (widget.data.length - 1).toDouble(),
      minY: 0,
      maxY: normalizedMax * _animation.value,
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: AppColors.textPrimary,
          tooltipRoundedRadius: AppSizes.radiusS.r,
          tooltipPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 8.h,
          ),
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              final dataIndex = spot.x.toInt();
              final data = widget.data[dataIndex];
              final isIncome = spot.barIndex == 0;
              final value = isIncome ? data.income : data.expenses;
              final label = isIncome ? 'analytics_income_label'.tr() : 'analytics_expense_label'.tr();

              return LineTooltipItem(
                'analytics_tooltip_amount'.tr(namedArgs: {'label': label, 'amount': _formatAmount(value)}),
                AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textOnPrimary,
                  fontWeight: FontWeight.w600,
                ),
              );
            }).toList();
          },
        ),
      ),
      lineBarsData: [
        if (_showIncome) _buildIncomeLine(),
        if (_showExpenses) _buildExpensesLine(),
      ],
    );
  }

  LineChartBarData _buildIncomeLine() {
    return LineChartBarData(
      spots: widget.data.asMap().entries.map((entry) {
        return FlSpot(
          entry.key.toDouble(),
          entry.value.income * _animation.value,
        );
      }).toList(),
      isCurved: true,
      curveSmoothness: 0.3,
      color: AppColors.chartGreen,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 4.r,
            color: AppColors.surface,
            strokeWidth: 2,
            strokeColor: AppColors.chartGreen,
          );
        },
      ),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.chartGreen.withValues(alpha: 0.3),
            AppColors.chartGreen.withValues(alpha: 0.0),
          ],
        ),
      ),
    );
  }

  LineChartBarData _buildExpensesLine() {
    return LineChartBarData(
      spots: widget.data.asMap().entries.map((entry) {
        return FlSpot(
          entry.key.toDouble(),
          entry.value.expenses * _animation.value,
        );
      }).toList(),
      isCurved: true,
      curveSmoothness: 0.3,
      color: AppColors.chartRed,
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 3.r,
            color: AppColors.surface,
            strokeWidth: 2,
            strokeColor: AppColors.chartRed,
          );
        },
      ),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.chartRed.withValues(alpha: 0.15),
            AppColors.chartRed.withValues(alpha: 0.0),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftTitle(double value) {
    final billions = value / 1000000000;
    String text;
    if (billions >= 1) {
      text = '${billions.toStringAsFixed(0)} mlrd';
    } else {
      final millions = value / 1000000;
      text = '${millions.toStringAsFixed(0)} mln';
    }
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.textTertiary,
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
    // Show every other month for readability
    if (index % 2 != 0 && widget.data.length > 6) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Text(
        widget.data[index].month,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.textTertiary,
        ),
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 1000000000) {
      return '${(amount / 1000000000).toStringAsFixed(1)} mlrd';
    } else if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)} mln';
    }
    return amount.toStringAsFixed(0);
  }
}
