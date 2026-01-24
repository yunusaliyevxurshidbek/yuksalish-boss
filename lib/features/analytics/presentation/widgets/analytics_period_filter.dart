import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/analytics_period.dart';
import '../theme/analytics_theme.dart';

class AnalyticsPeriodFilter extends StatelessWidget {
  final AnalyticsPeriod value;
  final ValueChanged<AnalyticsPeriod> onChanged;

  const AnalyticsPeriodFilter({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AnalyticsPremiumColors.of(context);
    return GestureDetector(
      onTap: () => _showPeriodPicker(context),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.p12.w,
          vertical: AppSizes.p8.h,
        ),
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
          border: Border.all(color: colors.cardBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 16.w,
              color: colors.primary,
            ),
            SizedBox(width: AppSizes.p8.w),
            Text(
              value.label,
              style: AppTextStyles.bodySmall.copyWith(
                color: colors.textHeading,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: AppSizes.p4.w),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18.w,
              color: colors.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  void _showPeriodPicker(BuildContext context) {
    final colors = AnalyticsPremiumColors.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSizes.radiusXL.r),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: AppSizes.p8.h),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: colors.cardBorder,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: AppSizes.p16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.p16.w),
                child: Row(
                  children: [
                    Text(
                      'Davr tanlang',
                      style: AppTextStyles.h4.copyWith(
                        color: colors.textHeading,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSizes.p12.h),
              ...AnalyticsPeriod.values.map(
                (period) => AnalyticsPeriodOption(
                  period: period,
                  isSelected: period == value,
                  onTap: () {
                    Navigator.pop(context);
                    if (period != value) onChanged(period);
                  },
                ),
              ),
              SizedBox(height: AppSizes.p16.h),
            ],
          ),
        ),
      ),
    );
  }
}

class AnalyticsPeriodOption extends StatelessWidget {
  final AnalyticsPeriod period;
  final bool isSelected;
  final VoidCallback onTap;

  const AnalyticsPeriodOption({
    super.key,
    required this.period,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AnalyticsPremiumColors.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.p16.w,
          vertical: AppSizes.p12.h,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primary.withValues(alpha: 0.08)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: isSelected
                    ? colors.primary.withValues(alpha: 0.15)
                    : colors.cardBorder.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
              ),
              child: Icon(
                _getIcon(period),
                size: 18.w,
                color: isSelected
                    ? colors.primary
                    : colors.textMuted,
              ),
            ),
            SizedBox(width: AppSizes.p12.w),
            Expanded(
              child: Text(
                period.label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isSelected
                      ? colors.primary
                      : colors.textHeading,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                size: 22.w,
                color: colors.primary,
              ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(AnalyticsPeriod period) {
    switch (period) {
      case AnalyticsPeriod.last30Days:
        return Icons.today_rounded;
      case AnalyticsPeriod.last3Months:
        return Icons.date_range_rounded;
      case AnalyticsPeriod.last6Months:
        return Icons.calendar_month_rounded;
      case AnalyticsPeriod.lastYear:
        return Icons.calendar_today_rounded;
      case AnalyticsPeriod.allTime:
        return Icons.all_inclusive_rounded;
    }
  }
}
