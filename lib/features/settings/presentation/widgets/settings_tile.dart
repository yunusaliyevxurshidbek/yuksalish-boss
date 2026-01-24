import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';

/// A tile widget for settings items
class SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;
  final bool isDestructive;

  const SettingsTile({
    super.key,
    required this.icon,
    this.iconColor,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.showDivider = true,
    this.isDestructive = false,
  });

  /// Factory for navigation tile with chevron
  factory SettingsTile.navigation({
    Key? key,
    required IconData icon,
    Color? iconColor,
    required String title,
    String? subtitle,
    String? value,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return SettingsTile(
      key: key,
      icon: icon,
      iconColor: iconColor,
      title: title,
      subtitle: subtitle,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null)
            Text(
              value,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          SizedBox(width: AppSizes.p8.w),
          Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textTertiary,
            size: AppSizes.iconM.w,
          ),
        ],
      ),
      onTap: onTap,
      showDivider: showDivider,
    );
  }

  /// Factory for toggle tile with switch
  factory SettingsTile.toggle({
    Key? key,
    required IconData icon,
    Color? iconColor,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool showDivider = true,
  }) {
    return SettingsTile(
      key: key,
      icon: icon,
      iconColor: iconColor,
      title: title,
      subtitle: subtitle,
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
      showDivider: showDivider,
    );
  }

  /// Factory for destructive action tile (like logout)
  factory SettingsTile.destructive({
    Key? key,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool showDivider = false,
  }) {
    return SettingsTile(
      key: key,
      icon: icon,
      iconColor: AppColors.error,
      title: title,
      onTap: onTap,
      showDivider: showDivider,
      isDestructive: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.p16.w,
              vertical: AppSizes.p12.h,
            ),
            child: Row(
              children: [
                _buildIcon(),
                SizedBox(width: AppSizes.p12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isDestructive
                              ? AppColors.error
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: 2.h),
                        Text(
                          subtitle!,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: AppSizes.p16.w + 40.w + AppSizes.p12.w,
            color: AppColors.divider,
          ),
      ],
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: (iconColor ?? AppColors.primary).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
      ),
      child: Icon(
        icon,
        color: iconColor ?? AppColors.primary,
        size: AppSizes.iconM.w,
      ),
    );
  }
}

/// Section header for settings groups
class SettingsSectionHeader extends StatelessWidget {
  final String title;

  const SettingsSectionHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSizes.p16.w,
        AppSizes.p24.h,
        AppSizes.p16.w,
        AppSizes.p8.h,
      ),
      child: Text(
        title,
        style: AppTextStyles.labelMedium.copyWith(
          color: AppColors.textTertiary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
