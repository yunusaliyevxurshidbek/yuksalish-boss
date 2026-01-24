import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/contracts_data.dart';

/// Bar chart showing contracts count trend
class ContractsChart extends StatefulWidget {
  const ContractsChart({
    super.key,
    required this.data,
    this.height = 200,
  });

  final List<ContractsData> data;
  final double height;

  @override
  State<ContractsChart> createState() => _ContractsChartState();
}

class _ContractsChartState extends State<ContractsChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int? _touchedIndex;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
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
            'Ma\'lumot mavjud emas',
            style: AppTextStyles.bodyMedium,
          ),
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
            child: BarChart(_buildChartData()),
          ),
        );
      },
    );
  }

  BarChartData _buildChartData() {
    final maxCount = widget.data.map((e) => e.count).reduce((a, b) => a > b ? a : b);
    final normalizedMax = ((maxCount / 5).ceil() * 5).toDouble();

    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: (normalizedMax * 1.2 * _animation.value).clamp(1, double.infinity),
      minY: 0,
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: AppColors.textPrimary,
          tooltipRoundedRadius: AppSizes.radiusS.r,
          tooltipPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 8.h,
          ),
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            final data = widget.data[group.x];
            return BarTooltipItem(
              '${data.month}: ${data.count} ta shartnoma',
              AppTextStyles.labelSmall.copyWith(
                color: AppColors.textOnPrimary,
                fontWeight: FontWeight.w600,
              ),
            );
          },
        ),
        touchCallback: (event, response) {
          setState(() {
            if (response == null || response.spot == null) {
              _touchedIndex = null;
            } else {
              _touchedIndex = response.spot!.touchedBarGroupIndex;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) => _buildBottomTitle(value.toInt()),
            reservedSize: 28.h,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) => _buildLeftTitle(value),
            reservedSize: 35.w,
            interval: normalizedMax / 4,
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: normalizedMax / 4,
        getDrawingHorizontalLine: (value) => const FlLine(
          color: AppColors.border,
          strokeWidth: 1,
        ),
      ),
      borderData: FlBorderData(show: false),
      barGroups: _buildBarGroups(),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return widget.data.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final isTouched = _touchedIndex == index;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data.count.toDouble() * _animation.value,
            width: 24.w,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(6.r),
              topRight: Radius.circular(6.r),
            ),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: isTouched
                  ? [
                      AppColors.chartBlue,
                      AppColors.primaryLight,
                    ]
                  : [
                      AppColors.chartBlue.withValues(alpha: 0.7),
                      AppColors.primaryLight.withValues(alpha: 0.9),
                    ],
            ),
          ),
        ],
        showingTooltipIndicators: isTouched ? [0] : [],
      );
    }).toList();
  }

  Widget _buildBottomTitle(int index) {
    if (index < 0 || index >= widget.data.length) {
      return const SizedBox.shrink();
    }
    // Show every other month for readability when there are many
    if (index % 2 != 0 && widget.data.length > 8) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Text(
        widget.data[index].month,
        style: AppTextStyles.caption.copyWith(
          color: _touchedIndex == index
              ? AppColors.primary
              : AppColors.textTertiary,
          fontWeight: _touchedIndex == index ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildLeftTitle(double value) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: Text(
        value.toInt().toString(),
        style: AppTextStyles.caption.copyWith(
          color: AppColors.textTertiary,
        ),
        textAlign: TextAlign.right,
      ),
    );
  }
}
