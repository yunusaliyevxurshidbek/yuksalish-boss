import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:yuksalish_mobile/core/constants/app_icons.dart';
import 'package:yuksalish_mobile/core/constants/app_sizes.dart';
import 'package:yuksalish_mobile/core/constants/app_text_styles.dart';
import 'package:yuksalish_mobile/core/constants/app_colors.dart';
import 'package:yuksalish_mobile/core/extensions/number_extensions.dart';
import 'package:yuksalish_mobile/core/widgets/widgets.dart';
import 'package:yuksalish_mobile/features/dashboard/data/models/dashboard_metrics.dart';

class MetricsGrid extends StatelessWidget {
  final DashboardMetrics metrics;
  final bool isLoading;
  final VoidCallback? onRevenueTap;
  final VoidCallback? onLeadsTap;
  final VoidCallback? onSoldTap;
  final VoidCallback? onConversionTap;

  const MetricsGrid({
    super.key,
    required this.metrics,
    this.isLoading = false,
    this.onRevenueTap,
    this.onLeadsTap,
    this.onSoldTap,
    this.onConversionTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const _MetricsGridShimmer();
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.p16.w),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  title: 'dashboard_metric_revenue'.tr(),
                  value: metrics.totalRevenue.currencyShort,
                  trend: metrics.revenueChange,
                  icon: AppIcons.money,
                  iconColor: AppColors.success,
                  onTap: onRevenueTap,
                ),
              ),
              SizedBox(width: AppSizes.p12.w),
              Expanded(
                child: _MetricTile(
                  title: 'dashboard_metric_leads'.tr(),
                  value: metrics.activeLeads.toString(),
                  trend: metrics.leadsChange,
                  icon: AppIcons.users,
                  iconColor: AppColors.info,
                  onTap: onLeadsTap,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.p12.h),
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  title: 'dashboard_metric_sold'.tr(),
                  value: 'dashboard_count_suffix'.tr(namedArgs: {'count': '${metrics.soldApartments}'}),
                  trend: metrics.soldChange,
                  icon: AppIcons.building,
                  iconColor: AppColors.chartPurple,
                  onTap: onSoldTap,
                ),
              ),
              SizedBox(width: AppSizes.p12.w),
              Expanded(
                child: _MetricTile(
                  title: 'dashboard_metric_conversion'.tr(),
                  value: metrics.conversionRate.percentageUnsigned,
                  trend: metrics.conversionChange,
                  icon: AppIcons.percent,
                  iconColor: AppColors.warning,
                  onTap: onConversionTap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String title;
  final String value;
  final double trend;
  final String icon;
  final Color iconColor;
  final VoidCallback? onTap;

  const _MetricTile({
    required this.title,
    required this.value,
    required this.trend,
    required this.icon,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isPositive = trend >= 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: isDark ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
                  ),
                  child: Center(
                    child: SvgPicture.string(
                      icon,
                      width: AppSizes.iconM.w,
                      height: AppSizes.iconM.w,
                      colorFilter: ColorFilter.mode(
                        iconColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                _TrendIndicator(
                  trend: trend,
                  isPositive: isPositive,
                ),
              ],
            ),
            SizedBox(height: AppSizes.p12.h),
            Text(
              value,
              style: AppTextStyles.h3.copyWith(
                color: theme.textTheme.headlineSmall?.color,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.h),
            Text(
              title,
              style: AppTextStyles.bodySmall.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendIndicator extends StatelessWidget {
  final double trend;
  final bool isPositive;

  const _TrendIndicator({
    required this.trend,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    final color = isPositive ? AppColors.success : AppColors.error;
    final icon = isPositive ? AppIcons.trendingUp : AppIcons.trendingDown;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.string(
            icon,
            width: 12.w,
            height: 12.w,
            colorFilter: ColorFilter.mode(
              color,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            trend.percentage,
            style: AppTextStyles.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricsGridShimmer extends StatelessWidget {
  const _MetricsGridShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.p16.w),
      child: ShimmerMetricGrid(
        itemCount: 4,
        crossAxisCount: 2,
        spacing: AppSizes.p12,
      ),
    );
  }
}
