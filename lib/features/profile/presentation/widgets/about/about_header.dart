import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../theme/profile_theme.dart';

/// Header section for about screen with logo and version.
class AboutHeader extends StatelessWidget {
  final String version;
  final String buildNumber;

  const AboutHeader({
    super.key,
    this.version = '1.0.0',
    this.buildNumber = '24',
  });

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return Column(
      children: [
        _AppLogo(),
        SizedBox(height: AppSizes.p24.h),
        Text(
          'profile_about_app_name'.tr(),
          style: AppTextStyles.h2.copyWith(
            color: colors.textPrimary,
            letterSpacing: 2,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.p16.w,
            vertical: AppSizes.p8.h,
          ),
          decoration: BoxDecoration(
            color: colors.tintIconBackground(colors.primary),
            borderRadius: BorderRadius.circular(AppSizes.radiusFull.r),
          ),
          child: Text(
            'profile_about_version_label'.tr(
              namedArgs: {
                'version': version,
                'build': buildNumber,
              },
            ),
            style: AppTextStyles.labelMedium.copyWith(color: colors.primary),
          ),
        ),
      ],
    );
  }
}

class _AppLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return Container(
      width: 100.w,
      height: 100.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.primary, colors.primaryLight],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'B',
          style: TextStyle(
            fontSize: 48.sp,
            fontWeight: FontWeight.bold,
            color: colors.textOnPrimary,
          ),
        ),
      ),
    );
  }
}
