import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../theme/profile_theme.dart';

/// Header card for support screen with gradient background.
class SupportHeaderCard extends StatelessWidget {
  const SupportHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.p24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.primary, colors.primaryLight],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
      ),
      child: Column(
        children: [
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              color: colors.textOnPrimary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.support_agent_rounded,
              color: colors.textOnPrimary,
              size: 32.w,
            ),
          ),
          SizedBox(height: AppSizes.p16.h),
          Text(
            'profile_support_header_title'.tr(),
            style: AppTextStyles.h4.copyWith(
              color: colors.textOnPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            'profile_support_header_subtitle'.tr(),
            style: AppTextStyles.bodySmall.copyWith(
              color: colors.textOnPrimary.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
