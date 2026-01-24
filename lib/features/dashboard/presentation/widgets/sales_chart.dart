import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:yuksalish_mobile/core/constants/app_sizes.dart';
import 'package:yuksalish_mobile/core/constants/app_text_styles.dart';
import 'package:yuksalish_mobile/core/constants/app_colors.dart';
import 'package:yuksalish_mobile/core/widgets/widgets.dart';
import 'package:yuksalish_mobile/features/dashboard/data/models/sales_data.dart';

class SalesChart extends StatefulWidget {
  final List<SalesData> data;
  final bool isLoading;
  final VoidCallback? onSeeAllTap;

  const SalesChart({
    super.key,
    required this.data,
    this.isLoading = false,
    this.onSeeAllTap,
  });

  @override
  State<SalesChart> createState() => _SalesChartState();
}

class _SalesChartState extends State<SalesChart>
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
    final chartYear = _getChartYear();
    final title = chartYear == null
        ? 'dashboard_sales_dynamics'.tr()
        : 'dashboard_sales_dynamics_year'.tr(namedArgs: {'year': '$chartYear'});

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.p16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: title,
            actionText: 'dashboard_see_all'.tr(),
            onActionTap: widget.onSeeAllTap,
          ),
          SizedBox(height: AppSizes.p16.h),
          Container(
            height: 220.h,
            padding: EdgeInsets.all(AppSizes.p16.w),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.border,
                width: AppSizes.borderThin,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: widget.isLoading
                ? const _ChartShimmer()
                : AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) => _buildChart(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (widget.data.isEmpty) {
      return Center(
        child: Text(
          'dashboard_no_data'.tr(),
          style: AppTextStyles.bodyMedium.copyWith(
            color: theme.textTheme.bodyMedium?.color,
          ),
        ),
      );
    }

    final maxAmount = widget.data
        .map((e) => e.amount)
        .reduce((a, b) => a > b ? a : b);
    final double interval = maxAmount > 0 ? maxAmount / 4 : 1.0;

    final axisScale = _getAxisScale(maxAmount);
    final axisUnit = _getAxisUnit(axisScale);

    return Stack(
      children: [
        BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY:
                (maxAmount * 1.2 * _animation.value).clamp(0.1, double.infinity),
            minY: 0,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: isDark
                    ? AppColors.darkSurfaceElevated
                    : AppColors.textPrimary,
                tooltipRoundedRadius: AppSizes.radiusS.r,
                tooltipPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 8.h,
                ),
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final data = widget.data[group.x];
                  return BarTooltipItem(
                    '${_getFullMonthName(data.month)}: ${_formatAmount(data.amount)} UZS\n${_formatContracts(data.count)}',
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
                  getTitlesWidget: (value, meta) =>
                      _buildLeftTitle(value, meta, axisScale),
                  reservedSize: 40.w,
                  interval: interval,
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
              getDrawingHorizontalLine: (value) => FlLine(
                color: isDark ? AppColors.darkDivider : AppColors.divider,
                strokeWidth: 1,
                dashArray: [5, 5],
              ),
            ),
            borderData: FlBorderData(show: false),
            barGroups: _buildBarGroups(),
          ),
          swapAnimationDuration: const Duration(milliseconds: 300),
        ),
        if (axisUnit != null)
          Positioned(
            right: 0,
            top: 0,
            child: Text(
              axisUnit,
              style: AppTextStyles.labelSmall.copyWith(
                color: theme.textTheme.bodySmall?.color,
                fontSize: 10.sp,
              ),
            ),
          ),
      ],
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
            toY: data.amount * _animation.value,
            width: 28.w,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(6.r),
              topRight: Radius.circular(6.r),
            ),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: isTouched
                  ? [
                      AppColors.primary,
                      AppColors.primaryLight,
                    ]
                  : [
                      AppColors.primary.withValues(alpha: 0.7),
                      AppColors.primaryLight.withValues(alpha: 0.9),
                    ],
            ),
          ),
        ],
      );
    }).toList();
  }

  Widget _buildBottomTitle(int index) {
    if (index < 0 || index >= widget.data.length) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Text(
        widget.data[index].month,
        style: AppTextStyles.labelSmall.copyWith(
          color: _touchedIndex == index
              ? theme.colorScheme.primary
              : theme.textTheme.bodySmall?.color,
          fontWeight:
              _touchedIndex == index ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildLeftTitle(double value, TitleMeta meta, double axisScale) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: Text(
        _formatAxisValue(value, axisScale),
        style: AppTextStyles.labelSmall.copyWith(
          color: theme.textTheme.bodySmall?.color,
          fontSize: 10.sp,
        ),
        textAlign: TextAlign.right,
      ),
    );
  }

  double _getAxisScale(double maxAmount) {
    if (maxAmount >= 1000000000) {
      return 1000000000;
    }
    if (maxAmount >= 1000000) {
      return 1000000;
    }
    if (maxAmount >= 1000) {
      return 1000;
    }
    return 1;
  }

  String? _getAxisUnit(double scale) {
    if (scale == 1000000000) {
      return 'dashboard_unit_billion'.tr();
    }
    if (scale == 1000000) {
      return 'dashboard_unit_million'.tr();
    }
    if (scale == 1000) {
      return 'dashboard_unit_thousand'.tr();
    }
    return null;
  }

  String _formatAxisValue(double value, double scale) {
    final scaled = value / scale;
    String text;
    if (scale >= 1000000000) {
      text = scaled.toStringAsFixed(1);
    } else {
      text = scaled.toStringAsFixed(0);
    }
    return _trimTrailingZeros(text);
  }

  String _trimTrailingZeros(String value) {
    if (!value.contains('.')) {
      return value;
    }
    var trimmed = value.replaceAll(RegExp(r'0+$'), '');
    trimmed = trimmed.replaceAll(RegExp(r'\.$'), '');
    return trimmed;
  }

  String _formatAmount(double value) {
    if (value >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(1)} ${'dashboard_unit_billion'.tr()}';
    }
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(0)} ${'dashboard_unit_million'.tr()}';
    }
    return value.toStringAsFixed(0);
  }

  String _formatContracts(int count) => 'dashboard_contracts_count'.tr(namedArgs: {'count': '$count'});

  String _getFullMonthName(String shortName) {
    final months = {
      'Yan': 'dashboard_month_jan'.tr(),
      'Fev': 'dashboard_month_feb'.tr(),
      'Mar': 'dashboard_month_mar'.tr(),
      'Apr': 'dashboard_month_apr'.tr(),
      'May': 'dashboard_month_may'.tr(),
      'Iyn': 'dashboard_month_jun'.tr(),
      'Iyl': 'dashboard_month_jul'.tr(),
      'Avg': 'dashboard_month_aug'.tr(),
      'Sen': 'dashboard_month_sep'.tr(),
      'Okt': 'dashboard_month_oct'.tr(),
      'Noy': 'dashboard_month_nov'.tr(),
      'Dek': 'dashboard_month_dec'.tr(),
    };
    return months[shortName] ?? shortName;
  }

  int? _getChartYear() {
    if (widget.data.isEmpty) return null;
    final year = widget.data.last.year;
    return year > 0 ? year : null;
  }
}

class _ChartShimmer extends StatelessWidget {
  const _ChartShimmer();

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(
          6,
          (index) => Container(
            width: 28.w,
            height: (60 + (index * 20)).h,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6.r),
                topRight: Radius.circular(6.r),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
