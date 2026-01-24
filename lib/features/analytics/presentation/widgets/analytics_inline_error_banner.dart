import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../theme/analytics_theme.dart';

class AnalyticsInlineErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const AnalyticsInlineErrorBanner({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AnalyticsPremiumColors.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.p16.w),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.p12.w,
          vertical: AppSizes.p12.h,
        ),
        decoration: BoxDecoration(
          color: colors.danger.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
          border: Border.all(color: colors.danger.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 18.w,
              color: colors.danger,
            ),
            SizedBox(width: AppSizes.p8.w),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodySmall.copyWith(
                  color: colors.textHeading,
                ),
              ),
            ),
            TextButton(
              onPressed: onRetry,
              child: Text(
                'analytics_retry'.tr(),
                style: AppTextStyles.labelSmall.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
