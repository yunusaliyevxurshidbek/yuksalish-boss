import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../theme/profile_theme.dart';

/// Predefined pastel colors for profile menu icons.
abstract class ProfileMenuColors {
  static const Color blue = Color(0xFFE8F0FE);
  static const Color blueIcon = Color(0xFF1A73E8);
  static const Color pink = Color(0xFFFCE8EC);
  static const Color pinkIcon = Color(0xFFE91E63);
  static const Color purple = Color(0xFFF3E8FD);
  static const Color purpleIcon = Color(0xFF9C27B0);
  static const Color orange = Color(0xFFFFF3E0);
  static const Color orangeIcon = Color(0xFFFF9800);
  static const Color green = Color(0xFFE8F5E9);
  static const Color greenIcon = Color(0xFF4CAF50);
  static const Color teal = Color(0xFFE0F2F1);
  static const Color tealIcon = Color(0xFF009688);
  static const Color red = Color(0xFFFFEBEE);
  static const Color redIcon = Color(0xFFF44336);
  static const Color grey = Color(0xFFF5F5F5);
  static const Color greyIcon = Color(0xFF757575);
  static const Color navy = Color(0xFFE8EAF6);
  static const Color navyIcon = Color(0xFF3F51B5);
}

/// A menu tile for profile screen with icon, title, and optional trailing widget.
class ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;
  final bool isDestructive;
  final bool showNotificationDot;

  const ProfileMenuTile({
    super.key,
    required this.icon,
    this.iconColor,
    this.iconBackgroundColor,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.showDivider = true,
    this.isDestructive = false,
    this.showNotificationDot = false,
  });

  /// Factory for navigation tile with chevron.
  factory ProfileMenuTile.navigation({
    Key? key,
    required IconData icon,
    Color? iconColor,
    Color? iconBackgroundColor,
    required String title,
    String? subtitle,
    String? value,
    required VoidCallback onTap,
    bool showDivider = true,
    bool showNotificationDot = false,
  }) {
    return ProfileMenuTile(
      key: key,
      icon: icon,
      iconColor: iconColor,
      iconBackgroundColor: iconBackgroundColor,
      title: title,
      subtitle: subtitle,
      trailing: _NavigationTrailing(value: value),
      onTap: onTap,
      showDivider: showDivider,
      showNotificationDot: showNotificationDot,
    );
  }

  /// Factory for toggle tile with switch.
  factory ProfileMenuTile.toggle({
    Key? key,
    required IconData icon,
    Color? iconColor,
    Color? iconBackgroundColor,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool showDivider = true,
  }) {
    return ProfileMenuTile(
      key: key,
      icon: icon,
      iconColor: iconColor,
      iconBackgroundColor: iconBackgroundColor,
      title: title,
      subtitle: subtitle,
      trailing: Builder(
        builder: (context) {
          final colors = ProfileThemeColors.of(context);
          return Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: colors.textOnPrimary,
            activeTrackColor: colors.primary,
            inactiveThumbColor:
                colors.isDark ? colors.textTertiary : colors.textSecondary,
            inactiveTrackColor:
                colors.isDark ? colors.surfaceElevated : colors.divider,
          );
        },
      ),
      showDivider: showDivider,
    );
  }

  /// Factory for destructive action tile (like logout).
  factory ProfileMenuTile.destructive({
    Key? key,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool showDivider = false,
  }) {
    return ProfileMenuTile(
      key: key,
      icon: icon,
      title: title,
      onTap: onTap,
      showDivider: showDivider,
      isDestructive: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);

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
                _buildIcon(context),
                SizedBox(width: AppSizes.p12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isDestructive
                              ? colors.error
                              : colors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: 2.h),
                        Text(
                          subtitle!,
                          style: AppTextStyles.caption.copyWith(
                            color: colors.textSecondary,
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
            color: colors.divider,
          ),
      ],
    );
  }

  Widget _buildIcon(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    final color = isDestructive
        ? colors.error
        : (iconColor ?? colors.primary);
    final bgColor = iconBackgroundColor ?? colors.tintIconBackground(color);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
          ),
          child: Icon(
            icon,
            color: color,
            size: AppSizes.iconM.w,
          ),
        ),
        if (showNotificationDot)
          Positioned(
            top: -2.w,
            right: -2.w,
            child: Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: colors.error,
                shape: BoxShape.circle,
                border: Border.all(
                  color: colors.surface,
                  width: 1.5.w,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Helper widget for navigation trailing to access theme context.
class _NavigationTrailing extends StatelessWidget {
  final String? value;

  const _NavigationTrailing({this.value});

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (value != null)
          Text(
            value!,
            style: AppTextStyles.bodySmall.copyWith(
              color: colors.textSecondary,
            ),
          ),
        SizedBox(width: AppSizes.p8.w),
        Icon(
          Icons.chevron_right_rounded,
          color: colors.textSecondary,
          size: AppSizes.iconM.w,
        ),
      ],
    );
  }
}
