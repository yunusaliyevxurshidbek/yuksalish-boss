import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../bloc/sold_apartments_state.dart';

class SoldApartmentsKpiGrid extends StatelessWidget {
  final SoldApartmentsStats stats;

  const SoldApartmentsKpiGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SoldApartmentsKpiCard(
                title: 'sold_apartments_kpi_sales_rate'.tr(),
                value: '${stats.soldPercentage.toStringAsFixed(1)}%',
                icon: Icons.pie_chart_rounded,
                color: const Color(0xFF10B981),
              ),
            ),
            SizedBox(width: AppSizes.p12.w),
            Expanded(
              child: SoldApartmentsKpiCard(
                title: 'sold_apartments_kpi_active_projects'.tr(),
                value: '${stats.activeProjects}',
                icon: Icons.business_rounded,
                color: const Color(0xFF3B82F6),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSizes.p12.h),
        Row(
          children: [
            Expanded(
              child: SoldApartmentsKpiCard(
                title: 'sold_apartments_kpi_available'.tr(),
                value: '${stats.availableUnits}',
                icon: Icons.check_circle_outline_rounded,
                color: const Color(0xFF22C55E),
              ),
            ),
            SizedBox(width: AppSizes.p12.w),
            Expanded(
              child: SoldApartmentsKpiCard(
                title: 'sold_apartments_kpi_occupied'.tr(),
                value: '${stats.reservedUnits}',
                icon: Icons.pending_outlined,
                color: const Color(0xFFF59E0B),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class SoldApartmentsKpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const SoldApartmentsKpiCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(AppSizes.p16.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20.w,
            ),
          ),
          SizedBox(width: AppSizes.p12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: AppTextStyles.h4.copyWith(
                    color: theme.textTheme.titleLarge?.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2.h),
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
        ],
      ),
    );
  }
}
