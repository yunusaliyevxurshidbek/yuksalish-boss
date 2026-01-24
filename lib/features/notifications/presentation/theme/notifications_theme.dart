import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Theme-aware color palette for notifications UI.
class NotificationThemeColors {
  final bool isDark;
  final Color scaffoldBackground;
  final Color surface;
  final Color surfaceElevated;
  final Color cardBackground;
  final Color cardUnreadBackground;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textOnPrimary;
  final Color primary;
  final Color primaryLight;
  final Color success;
  final Color successLight;
  final Color warning;
  final Color warningLight;
  final Color info;
  final Color infoLight;
  final Color error;

  const NotificationThemeColors._({
    required this.isDark,
    required this.scaffoldBackground,
    required this.surface,
    required this.surfaceElevated,
    required this.cardBackground,
    required this.cardUnreadBackground,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textOnPrimary,
    required this.primary,
    required this.primaryLight,
    required this.success,
    required this.successLight,
    required this.warning,
    required this.warningLight,
    required this.info,
    required this.infoLight,
    required this.error,
  });

  static const NotificationThemeColors light = NotificationThemeColors._(
    isDark: false,
    scaffoldBackground: AppColors.background,
    surface: AppColors.surface,
    surfaceElevated: AppColors.grey100,
    cardBackground: AppColors.surface,
    cardUnreadBackground: AppColors.background,
    border: AppColors.border,
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    textMuted: AppColors.textTertiary,
    textOnPrimary: AppColors.textOnPrimary,
    primary: AppColors.primary,
    primaryLight: AppColors.primaryLight,
    success: AppColors.success,
    successLight: AppColors.successLight,
    warning: AppColors.warning,
    warningLight: AppColors.warningLight,
    info: AppColors.info,
    infoLight: AppColors.infoLight,
    error: AppColors.error,
  );

  static const NotificationThemeColors dark = NotificationThemeColors._(
    isDark: true,
    scaffoldBackground: AppColors.darkScaffoldBackground,
    surface: AppColors.darkSurface,
    surfaceElevated: AppColors.darkSurfaceElevated,
    cardBackground: AppColors.darkSurface,
    cardUnreadBackground: AppColors.darkSurfaceElevated,
    border: AppColors.darkBorder,
    textPrimary: AppColors.darkTextPrimary,
    textSecondary: AppColors.darkTextSecondary,
    textMuted: AppColors.darkTextTertiary,
    textOnPrimary: AppColors.textOnPrimary,
    primary: AppColors.darkPrimary,
    primaryLight: AppColors.darkPrimaryLight,
    success: AppColors.darkSuccess,
    successLight: AppColors.darkSuccessLight,
    warning: AppColors.darkWarning,
    warningLight: AppColors.darkWarningLight,
    info: AppColors.darkInfo,
    infoLight: AppColors.darkInfoLight,
    error: AppColors.darkError,
  );

  static NotificationThemeColors of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? dark : light;
  }

  BoxShadow get cardShadow => BoxShadow(
        color: (isDark ? const Color(0xFF000000) : const Color(0xFF1A1F36))
            .withValues(alpha: isDark ? 0.35 : 0.06),
        blurRadius: isDark ? 18 : 10,
        offset: Offset(0, isDark ? 8 : 2),
      );

  Color typeBackground(Color base) {
    if (!isDark) return base;
    return Color.alphaBlend(base.withValues(alpha: 0.18), surface);
  }

  Color get shimmerBase => border;
  Color get shimmerHighlight => surfaceElevated;
}
