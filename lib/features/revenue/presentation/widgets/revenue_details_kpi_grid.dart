import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/extensions/number_extensions.dart';
import '../bloc/revenue_details_state.dart';

class RevenueDetailsKpiGrid extends StatelessWidget {
  final RevenueStats stats;

  const RevenueDetailsKpiGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: RevenueKpiCard(
                title: 'revenue_closed_deals'.tr(),
                value: 'dashboard_count_suffix'.tr(
                  namedArgs: {'count': stats.completedContracts.toString()},
                ),
                icon: Icons.check_circle_outline,
                iconColor: theme.brightness == Brightness.dark
                    ? AppColors.success
                    : AppColors.success,
              ),
            ),
            SizedBox(width: AppSizes.p12.w),
            Expanded(
              child: RevenueKpiCard(
                title: 'revenue_average_deal'.tr(),
                value: stats.averageDealValue.currencyShort,
                icon: Icons.analytics_outlined,
                iconColor: AppColors.info,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSizes.p12.h),
        Row(
          children: [
            Expanded(
              child: RevenueKpiCard(
                title: 'revenue_overdue'.tr(),
                value: stats.overduePayments.currencyShort,
                icon: Icons.warning_amber_outlined,
                iconColor: AppColors.error,
              ),
            ),
            SizedBox(width: AppSizes.p12.w),
            Expanded(
              child: RevenueKpiCard(
                title: 'revenue_expected'.tr(),
                value: stats.pendingPayments.currencyShort,
                icon: Icons.schedule_outlined,
                iconColor: AppColors.warning,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class RevenueKpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const RevenueKpiCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(AppSizes.p16.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
          width: AppSizes.borderThin,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
            ),
            child: Icon(
              icon,
              size: 20.w,
              color: iconColor,
            ),
          ),
          SizedBox(height: AppSizes.p12.h),
          Text(
            value,
            style: AppTextStyles.h4.copyWith(
              color: theme.textTheme.titleLarge?.color,
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
    );
  }
}
