import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../presentation/widgets/custom_snacbar.dart';
import '../theme/profile_theme.dart';
import '../widgets/about/about.dart';

/// Screen showing app information.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_rounded,
            color: colors.textPrimary,
            size: AppSizes.iconL.w,
          ),
        ),
        title: Text(
          'profile_about_title'.tr(),
          style: AppTextStyles.h3.copyWith(color: colors.textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSizes.p16.w),
        child: Column(
          children: [
            SizedBox(height: AppSizes.p24.h),
            const AboutHeader(),
            SizedBox(height: AppSizes.p32.h),
            _DescriptionCard(),
            SizedBox(height: AppSizes.p24.h),
            _DeveloperInfoCard(),
            SizedBox(height: AppSizes.p24.h),
            _Copyright(),
            SizedBox(height: AppSizes.p24.h),
            _ActionLinksCard(context: context),
            SizedBox(height: AppSizes.p32.h),
          ],
        ),
      ),
    );
  }
}

class _DescriptionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.p20.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
        boxShadow: [colors.cardShadow],
      ),
      child: Column(
        children: [
          Icon(Icons.apartment_rounded, color: colors.primary, size: 40.w),
          SizedBox(height: AppSizes.p12.h),
          Text(
            'profile_about_description'.tr(),
            style: AppTextStyles.bodyMedium.copyWith(color: colors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _DeveloperInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.p16.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
      ),
      child: Column(
        children: [
          AboutInfoRow(
            icon: Icons.business_outlined,
            label: 'profile_about_developer_label'.tr(),
            value: 'GreatSoft LLC',
          ),
          Divider(height: AppSizes.p24.h, color: colors.divider),
          AboutInfoRow(
            icon: Icons.language_outlined,
            label: 'profile_about_website_label'.tr(),
            value: 'www.greatsoft.uz',
            isLink: true,
          ),
          Divider(height: AppSizes.p24.h, color: colors.divider),
          AboutInfoRow(
            icon: Icons.email_outlined,
            label: 'profile_about_email_label'.tr(),
            value: 'info@greatsoft.uz',
            isLink: true,
          ),
          Divider(height: AppSizes.p24.h, color: colors.divider),
          AboutInfoRow(
            icon: Icons.phone_outlined,
            label: 'profile_about_phone_label'.tr(),
            value: '+998 71 123 45 67',
            isLink: true,
          ),
        ],
      ),
    );
  }
}

class _Copyright extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return Text(
      'profile_about_copyright'.tr(),
      style: AppTextStyles.caption.copyWith(color: colors.textTertiary),
      textAlign: TextAlign.center,
    );
  }
}

class _ActionLinksCard extends StatelessWidget {
  final BuildContext context;

  const _ActionLinksCard({required this.context});

  @override
  Widget build(BuildContext buildContext) {
    final colors = ProfileThemeColors.of(buildContext);
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
      ),
      child: Column(
        children: [
          AboutActionTile(
            icon: Icons.update_outlined,
            title: 'profile_about_check_updates'.tr(),
            onTap: () {
              CustomSnacbar.show(
                context,
                text: 'profile_about_latest_version'.tr(),
              );
            },
          ),
          Divider(height: 1, indent: AppSizes.p16.w + 40.w, color: colors.divider),
          AboutActionTile(
            icon: Icons.history_outlined,
            title: 'profile_about_changelog'.tr(),
            onTap: () {},
          ),
          Divider(height: 1, indent: AppSizes.p16.w + 40.w, color: colors.divider),
          AboutActionTile(
            icon: Icons.code_outlined,
            title: 'profile_about_open_source'.tr(),
            onTap: () {
              showLicensePage(
                context: context,
                applicationName: 'profile_about_app_name'.tr(),
                applicationVersion: 'profile_about_app_version'.tr(),
              );
            },
          ),
        ],
      ),
    );
  }
}
