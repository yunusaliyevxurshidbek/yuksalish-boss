import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../theme/analytics_theme.dart';

/// Error state widget for analytics screen.
class AnalyticsErrorState extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback onRetry;

  const AnalyticsErrorState({
    super.key,
    this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AnalyticsPremiumColors.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.p16.w),
      child: Column(
        children: [
          SizedBox(height: AppSizes.p40.h),
          Icon(
            Icons.error_outline_rounded,
            size: AppSizes.iconXXL.w,
            color: colors.danger,
          ),
          SizedBox(height: AppSizes.p16.h),
          Text(
            'analytics_error_loading'.tr(),
            style: AppTextStyles.h4.copyWith(
              color: colors.textHeading,
            ),
          ),
          SizedBox(height: AppSizes.p8.h),
          Text(
            errorMessage ?? 'analytics_error_try_again'.tr(),
            style: AppTextStyles.bodyMedium.copyWith(
              color: colors.textSubtitle,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSizes.p24.h),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.textOnPrimary,
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.p24.w,
                vertical: AppSizes.p12.h,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
              ),
            ),
            child: Text('analytics_reload'.tr(), style: AppTextStyles.button),
          ),
        ],
      ),
    );
  }
}
