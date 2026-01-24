import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/extensions/number_extensions.dart';
import '../../../dashboard/data/models/crm_stats_model.dart';

class RevenueDetailsSalesChart extends StatefulWidget {
  final List<MonthlySalesModel> monthlySales;

  const RevenueDetailsSalesChart({super.key, required this.monthlySales});

  @override
  State<RevenueDetailsSalesChart> createState() => _RevenueDetailsSalesChartState();
}

class _RevenueDetailsSalesChartState extends State<RevenueDetailsSalesChart>
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'dashboard_sales_dynamics'.tr(),
          style: AppTextStyles.h4.copyWith(
            color: theme.textTheme.titleLarge?.color,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppSizes.p12.h),
        Container(
          height: 250.h,
          padding: EdgeInsets.all(AppSizes.p16.w),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.border,
              width: AppSizes.borderThin,
            ),
          ),
          child: widget.monthlySales.isEmpty
              ? Center(
                child: Text(
                    'common_no_data'.tr(),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                )
              : AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) => _buildChart(),
                ),
        ),
      ],
    );
  }

  Widget _buildChart() {
    final theme = Theme.of(context);
    final maxAmount = widget.monthlySales
        .map((e) => e.amount)
        .fold<double>(0, (a, b) => a > b ? a : b);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: (maxAmount * 1.2 * _animation.value).clamp(0.1, double.infinity),
        minY: 0,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: theme.brightness == Brightness.dark
                ? AppColors.darkSurface
                : AppColors.textPrimary,
            tooltipRoundedRadius: AppSizes.radiusS.r,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final data = widget.monthlySales[group.x];
              final contractsCountLabel = 'dashboard_count_suffix'.tr(
                namedArgs: {'count': data.contractsCount.toString()},
              );
              return BarTooltipItem(
                '${data.name}: ${data.amount.currencyShort}\n($contractsCountLabel)',
                AppTextStyles.labelSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
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
              getTitlesWidget: (value, meta) =>
                  _buildBottomTitle(value.toInt()),
              reservedSize: 28.h,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: _buildLeftTitle,
              reservedSize: 50.w,
              interval: maxAmount > 0 ? maxAmount / 4 : 1,
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
          horizontalInterval: maxAmount > 0 ? maxAmount / 4 : 1,
          getDrawingHorizontalLine: (value) => FlLine(
            color: theme.dividerColor,
            strokeWidth: 1,
            dashArray: [5, 5],
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: _buildBarGroups(),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    final theme = Theme.of(context);

    return widget.monthlySales.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final isTouched = _touchedIndex == index;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data.amount * _animation.value,
            width: 24.w,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(6.r),
              topRight: Radius.circular(6.r),
            ),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: isTouched
                  ? [theme.colorScheme.primary, AppColors.primaryLight]
                  : [
                      theme.colorScheme.primary.withValues(alpha: 0.7),
                      AppColors.primaryLight.withValues(alpha: 0.9),
                    ],
            ),
          ),
        ],
      );
    }).toList();
  }

  Widget _buildBottomTitle(int index) {
    final theme = Theme.of(context);

    if (index < 0 || index >= widget.monthlySales.length) {
      return const SizedBox.shrink();
    }

    final name = widget.monthlySales[index].name;
    final shortName = name.length > 3 ? name.substring(0, 3) : name;

    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Text(
        shortName,
        style: AppTextStyles.labelSmall.copyWith(
          color: _touchedIndex == index
              ? theme.colorScheme.primary
              : theme.textTheme.bodySmall?.color,
          fontWeight: _touchedIndex == index ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildLeftTitle(double value, TitleMeta meta) {
    final theme = Theme.of(context);

    String text;
    if (value >= 1000000000) {
      text = '${(value / 1000000000).toStringAsFixed(1)}B';
    } else if (value >= 1000000) {
      text = '${(value / 1000000).toStringAsFixed(0)}M';
    } else if (value >= 1000) {
      text = '${(value / 1000).toStringAsFixed(0)}K';
    } else {
      text = value.toStringAsFixed(0);
    }

    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: Text(
        text,
        style: AppTextStyles.labelSmall.copyWith(
          color: theme.textTheme.bodySmall?.color,
          fontSize: 10.sp,
        ),
        textAlign: TextAlign.right,
      ),
    );
  }
}
