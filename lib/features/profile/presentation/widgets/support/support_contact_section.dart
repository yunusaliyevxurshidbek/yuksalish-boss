import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../theme/profile_theme.dart';

/// Contact options section for support screen.
class SupportContactSection extends StatelessWidget {
  const SupportContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'profile_support_contact_section'.tr(),
          style: AppTextStyles.labelSmall.copyWith(
            color: colors.textTertiary,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: AppSizes.p12.h),
        Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
          ),
          child: Column(
            children: [
              _ContactTile(
                icon: Icons.phone_outlined,
                iconColor: colors.success,
                title: 'profile_support_contact_call'.tr(),
                subtitle: '+998 71 123 45 67',
                onTap: () {
                  // TODO: Open phone dialer
                },
              ),
              const _SupportDivider(),
              _ContactTile(
                icon: Icons.chat_outlined,
                iconColor: colors.info,
                title: 'profile_support_contact_telegram'.tr(),
                subtitle: '@greatsoft_support',
                onTap: () {
                  // TODO: Open Telegram
                },
              ),
              const _SupportDivider(),
              _ContactTile(
                icon: Icons.email_outlined,
                iconColor: colors.warning,
                title: 'profile_support_contact_email'.tr(),
                subtitle: 'support@greatsoft.uz',
                onTap: () {
                  // TODO: Open email client
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ContactTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(AppSizes.p16.w),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: colors.tintIconBackground(iconColor),
                borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: AppSizes.iconL.w,
              ),
            ),
            SizedBox(width: AppSizes.p12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: colors.textTertiary,
              size: AppSizes.iconM.w,
            ),
          ],
        ),
      ),
    );
  }
}

class _SupportDivider extends StatelessWidget {
  const _SupportDivider();

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return Divider(
      height: 1,
      indent: AppSizes.p16.w,
      endIndent: AppSizes.p16.w,
      color: colors.divider,
    );
  }
}
