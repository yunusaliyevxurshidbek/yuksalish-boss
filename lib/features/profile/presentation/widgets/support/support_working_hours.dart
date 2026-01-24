import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../theme/profile_theme.dart';

/// Working hours info card for support screen.
class SupportWorkingHours extends StatelessWidget {
  const SupportWorkingHours({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.p16.w),
      decoration: BoxDecoration(
        color: colors.infoLight,
        borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
        border: Border.all(
          color: colors.info.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.access_time_rounded,
            color: colors.info,
            size: AppSizes.iconM.w,
          ),
          SizedBox(width: AppSizes.p12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'profile_support_hours_title'.tr(),
                  style: AppTextStyles.labelMedium.copyWith(
                    color: colors.info,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'profile_support_hours_value'.tr(),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colors.info,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
