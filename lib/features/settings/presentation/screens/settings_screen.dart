import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/settings_sections.dart';
import '../widgets/settings_tile.dart';

/// Settings screen for app configuration.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
            size: AppSizes.iconL.w,
          ),
        ),
        title: Text(
          'settings_title'.tr(),
          style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SettingsProfileSection(),
            SettingsSectionHeader(title: 'settings_security'.tr()),
            const SettingsSecuritySection(),
            SettingsSectionHeader(title: 'settings_notifications'.tr()),
            const SettingsNotificationsSection(),
            SettingsSectionHeader(title: 'settings_language'.tr()),
            const SettingsLanguageSection(),
            SettingsSectionHeader(title: 'settings_about'.tr()),
            const SettingsAboutSection(),
            SettingsSectionHeader(title: 'settings_logout_section'.tr()),
            const SettingsLogoutSection(),
            SizedBox(height: AppSizes.p32.h),
          ],
        ),
      ),
    );
  }
}
