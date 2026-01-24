import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/extensions/number_extensions.dart';
import '../../../data/models/models.dart';

/// Finance tab content for project detail screen.
class ProjectDetailFinanceTab extends StatelessWidget {
  final ProjectStats? stats;

  const ProjectDetailFinanceTab({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (stats == null) {
      return Center(
        child: CircularProgressIndicator(color: theme.colorScheme.primary),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSizes.p16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppSizes.p8.h),
          _FinanceSummaryCard(stats: stats!),
          SizedBox(height: AppSizes.p16.h),
          _MonthlyIncomeChart(stats: stats!),
          SizedBox(height: AppSizes.p32.h),
        ],
      ),
    );
  }
}

class _FinanceSummaryCard extends StatelessWidget {
  final ProjectStats stats;

  const _FinanceSummaryCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Container(
      padding: EdgeInsets.all(AppSizes.p16.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'projects_finance_indicators'.tr(),
            style: AppTextStyles.labelLarge.copyWith(
              color: theme.textTheme.titleMedium?.color,
            ),
          ),
          SizedBox(height: AppSizes.p16.h),
          _FinanceItem(
            label: 'projects_finance_revenue'.tr(),
            value: stats.totalRevenue.currencyShort,
            color: AppColors.success,
            icon: Icons.trending_up,
          ),
          SizedBox(height: AppSizes.p12.h),
          _FinanceItem(
            label: 'projects_finance_expected'.tr(),
            value: stats.expectedRevenue.currencyShort,
            color: AppColors.info,
            icon: Icons.schedule,
          ),
          SizedBox(height: AppSizes.p12.h),
          _FinanceItem(
            label: 'projects_finance_debt'.tr(),
            value: stats.debt.currencyShort,
            color: AppColors.error,
            icon: Icons.warning_amber,
          ),
          SizedBox(height: AppSizes.p16.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
            child: LinearProgressIndicator(
              value: stats.collectionRate / 100,
              backgroundColor: borderColor,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.success),
              minHeight: 8.h,
            ),
          ),
          SizedBox(height: AppSizes.p8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'projects_finance_collection_rate'.tr(),
                style: AppTextStyles.caption.copyWith(
                  color: theme.textTheme.bodySmall?.color,
                ),
              ),
              Text(
                '${stats.collectionRate.toStringAsFixed(1)}%',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FinanceItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _FinanceItem({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: color.withAlpha(26),
            borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
          ),
          child: Icon(
            icon,
            color: color,
            size: AppSizes.iconM.w,
          ),
        ),
        SizedBox(width: AppSizes.p12.w),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.textTheme.titleMedium?.color,
          ),
        ),
      ],
    );
  }
}

class _MonthlyIncomeChart extends StatelessWidget {
  final ProjectStats stats;

  const _MonthlyIncomeChart({required this.stats});

  double get _maxY {
    if (stats.monthlyIncome.isEmpty) return 100;
    final maxValue =
        stats.monthlyIncome.map((e) => e.amount).reduce((a, b) => a > b ? a : b);
    return maxValue * 1.2;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Container(
      padding: EdgeInsets.all(AppSizes.p16.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'projects_finance_monthly_income'.tr(),
            style: AppTextStyles.labelLarge.copyWith(
              color: theme.textTheme.titleMedium?.color,
            ),
          ),
          SizedBox(height: AppSizes.p24.h),
          SizedBox(
            height: 200.h,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _maxY,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: theme.textTheme.titleLarge?.color ?? Colors.black,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        stats.monthlyIncome[groupIndex].amount.currencyShort,
                        AppTextStyles.caption.copyWith(color: Colors.white),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < stats.monthlyIncome.length) {
                          return Padding(
                            padding: EdgeInsets.only(top: 8.h),
                            child: Text(
                              stats.monthlyIncome[index].month,
                              style: AppTextStyles.caption.copyWith(
                                color: theme.textTheme.bodySmall?.color,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.compactCurrency,
                          style: AppTextStyles.caption.copyWith(
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        );
                      },
                      reservedSize: 50,
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: _maxY / 4,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: borderColor,
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(
                  stats.monthlyIncome.length,
                  (index) {
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: stats.monthlyIncome[index].amount,
                          color: theme.colorScheme.primary,
                          width: 16.w,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(4.r),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
