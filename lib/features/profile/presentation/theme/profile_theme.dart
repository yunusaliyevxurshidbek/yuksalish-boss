import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Theme-aware palette for profile screens, dialogs, and sheets.
class ProfileThemeColors {
  final bool isDark;
  final Color background;
  final Color surface;
  final Color surfaceElevated;
  final Color card;
  final Color border;
  final Color divider;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textOnPrimary;
  final Color primary;
  final Color primaryLight;
  final Color success;
  final Color successLight;
  final Color warning;
  final Color warningLight;
  final Color error;
  final Color errorLight;
  final Color info;
  final Color infoLight;

  const ProfileThemeColors._({
    required this.isDark,
    required this.background,
    required this.surface,
    required this.surfaceElevated,
    required this.card,
    required this.border,
    required this.divider,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textOnPrimary,
    required this.primary,
    required this.primaryLight,
    required this.success,
    required this.successLight,
    required this.warning,
    required this.warningLight,
    required this.error,
    required this.errorLight,
    required this.info,
    required this.infoLight,
  });

  static const ProfileThemeColors light = ProfileThemeColors._(
    isDark: false,
    background: AppColors.background,
    surface: AppColors.surface,
    surfaceElevated: AppColors.grey100,
    card: AppColors.surface,
    border: AppColors.border,
    divider: AppColors.divider,
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    textTertiary: AppColors.textTertiary,
    textOnPrimary: AppColors.textOnPrimary,
    primary: AppColors.primary,
    primaryLight: AppColors.primaryLight,
    success: AppColors.success,
    successLight: AppColors.successLight,
    warning: AppColors.warning,
    warningLight: AppColors.warningLight,
    error: AppColors.error,
    errorLight: AppColors.errorLight,
    info: AppColors.info,
    infoLight: AppColors.infoLight,
  );

  static const ProfileThemeColors dark = ProfileThemeColors._(
    isDark: true,
    background: AppColors.darkScaffoldBackground,
    surface: AppColors.darkSurface,
    surfaceElevated: AppColors.darkSurfaceElevated,
    card: AppColors.darkCard,
    border: AppColors.darkBorder,
    divider: AppColors.darkDivider,
    textPrimary: AppColors.darkTextPrimary,
    textSecondary: AppColors.darkTextSecondary,
    textTertiary: AppColors.darkTextTertiary,
    textOnPrimary: AppColors.textOnPrimary,
    primary: AppColors.darkPrimary,
    primaryLight: AppColors.darkPrimaryLight,
    success: AppColors.darkSuccess,
    successLight: AppColors.darkSuccessLight,
    warning: AppColors.darkWarning,
    warningLight: AppColors.darkWarningLight,
    error: AppColors.darkError,
    errorLight: AppColors.darkErrorLight,
    info: AppColors.darkInfo,
    infoLight: AppColors.darkInfoLight,
  );

  static ProfileThemeColors of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? dark : light;
  }

  BoxShadow get cardShadow => BoxShadow(
        color: (isDark ? const Color(0xFF000000) : const Color(0xFF1A1F36))
            .withValues(alpha: isDark ? 0.35 : 0.06),
        blurRadius: isDark ? 18 : 10,
        offset: Offset(0, isDark ? 8 : 2),
      );

  Color tintIconBackground(Color iconColor, {double darkAlpha = 0.2}) {
    if (!isDark) return iconColor.withValues(alpha: 0.1);
    return Color.alphaBlend(iconColor.withValues(alpha: darkAlpha), surface);
  }

  Color menuIconBackground(
    Color lightBackground,
    Color iconColor, {
    double darkAlpha = 0.2,
  }) {
    if (!isDark) return lightBackground;
    return Color.alphaBlend(iconColor.withValues(alpha: darkAlpha), surface);
  }

  Color blendOnSurface(Color color, {double alpha = 0.14}) {
    if (!isDark) return color;
    return Color.alphaBlend(color.withValues(alpha: alpha), surface);
  }
}
