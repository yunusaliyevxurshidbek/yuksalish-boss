import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import 'settings_tile.dart';

/// Language section for settings screen.
class SettingsLanguageSection extends StatelessWidget {
  const SettingsLanguageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSizes.p16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
      ),
      child: SettingsTile.navigation(
        icon: Icons.language_outlined,
        title: 'settings_language_option'.tr(),
        onTap: () {
          // TODO: Show language picker
        },
        showDivider: false,
      ),
    );
  }
}

/// About section for settings screen.
class SettingsAboutSection extends StatelessWidget {
  const SettingsAboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSizes.p16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
      ),
      child: Column(
        children: [
          SettingsTile(
            icon: Icons.info_outline,
            title: 'settings_version'.tr(),
            trailing: Text(
              '1.0.0',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
            ),
          ),
          SettingsTile.navigation(
            icon: Icons.description_outlined,
            title: 'settings_terms'.tr(),
            onTap: () {
              // TODO: Open terms of service
            },
          ),
          SettingsTile.navigation(
            icon: Icons.privacy_tip_outlined,
            title: 'settings_privacy'.tr(),
            onTap: () {
              // TODO: Open privacy policy
            },
            showDivider: false,
          ),
        ],
      ),
    );
  }
}
