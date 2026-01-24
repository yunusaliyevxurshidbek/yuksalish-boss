import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../bloc/sold_apartments_state.dart';

class SoldApartmentsUnitsDistribution extends StatelessWidget {
  final SoldApartmentsStats stats;

  const SoldApartmentsUnitsDistribution({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final total = stats.totalUnits;
    final soldPercent = total > 0 ? stats.soldCount / total : 0.0;
    final reservedPercent = total > 0 ? stats.reservedUnits / total : 0.0;
    final availablePercent = total > 0 ? stats.availableUnits / total : 0.0;

    return Container(
      padding: EdgeInsets.all(AppSizes.p20.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'sold_apartments_units_status'.tr(),
            style: AppTextStyles.h4.copyWith(
              color: theme.textTheme.titleLarge?.color,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSizes.p16.h),
          // Stacked progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: SizedBox(
              height: 12.h,
              child: Row(
                children: [
                  Expanded(
                    flex: (soldPercent * 100).round(),
                    child: Container(color: const Color(0xFF6366F1)),
                  ),
                  Expanded(
                    flex: (reservedPercent * 100).round(),
                    child: Container(color: const Color(0xFFF59E0B)),
                  ),
                  Expanded(
                    flex: (availablePercent * 100).round(),
                    child: Container(color: const Color(0xFF22C55E)),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppSizes.p16.h),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              UnitsDistributionLegendItem(
                color: const Color(0xFF6366F1),
                label: 'sold_apartments_sold'.tr(),
                value: '${stats.soldCount}',
              ),
              UnitsDistributionLegendItem(
                color: const Color(0xFFF59E0B),
                label: 'sold_apartments_occupied'.tr(),
                value: '${stats.reservedUnits}',
              ),
              UnitsDistributionLegendItem(
                color: const Color(0xFF22C55E),
                label: 'sold_apartments_available'.tr(),
                value: '${stats.availableUnits}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class UnitsDistributionLegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String value;

  const UnitsDistributionLegendItem({
    super.key,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3.r),
          ),
        ),
        SizedBox(width: 6.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: AppTextStyles.labelMedium.copyWith(
                color: theme.textTheme.titleMedium?.color,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
