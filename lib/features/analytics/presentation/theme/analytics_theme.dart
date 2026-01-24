import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Premium analytics color palette for fintech dashboard aesthetic.
/// Provides light/dark variants based on the current theme.
class AnalyticsPremiumColors {
  final bool isDark;

  // Backgrounds
  final Color scaffoldBackground;
  final Color cardBackground;
  final Color cardBorder;

  // Primary/Accent
  final Color primary;
  final Color primaryGradientStart;
  final Color primaryGradientEnd;

  // Semantic
  final Color success;
  final Color successLight;
  final Color warning;
  final Color warningLight;
  final Color danger;
  final Color dangerLight;
  final Color info;
  final Color infoLight;

  // Inventory segments
  final Color available;
  final Color sold;
  final Color reserved;

  // Text
  final Color textHeading;
  final Color textSubtitle;
  final Color textMuted;
  final Color textOnPrimary;

  // Charts
  final Color chartGridLine;
  final Color chartLine;
  final Color tooltipBackground;

  // Additional KPI colors
  final Color teal;
  final Color purple;
  final Color orange;

  const AnalyticsPremiumColors._({
    required this.isDark,
    required this.scaffoldBackground,
    required this.cardBackground,
    required this.cardBorder,
    required this.primary,
    required this.primaryGradientStart,
    required this.primaryGradientEnd,
    required this.success,
    required this.successLight,
    required this.warning,
    required this.warningLight,
    required this.danger,
    required this.dangerLight,
    required this.info,
    required this.infoLight,
    required this.available,
    required this.sold,
    required this.reserved,
    required this.textHeading,
    required this.textSubtitle,
    required this.textMuted,
    required this.textOnPrimary,
    required this.chartGridLine,
    required this.chartLine,
    required this.tooltipBackground,
    required this.teal,
    required this.purple,
    required this.orange,
  });

  static const AnalyticsPremiumColors light = AnalyticsPremiumColors._(
    isDark: false,
    scaffoldBackground: Color(0xFFF5F7FA),
    cardBackground: Color(0xFFFFFFFF),
    cardBorder: Color(0xFFE2E8F0),
    primary: Color(0xFF3B82F6),
    primaryGradientStart: Color(0xFF3B82F6),
    primaryGradientEnd: Color(0xFF60A5FA),
    success: Color(0xFF22C55E),
    successLight: Color(0xFFDCFCE7),
    warning: Color(0xFFF59E0B),
    warningLight: Color(0xFFFEF3C7),
    danger: Color(0xFFEF4444),
    dangerLight: Color(0xFFFEE2E2),
    info: Color(0xFF0EA5E9),
    infoLight: Color(0xFFE0F2FE),
    available: Color(0xFF22C55E),
    sold: Color(0xFF3B82F6),
    reserved: Color(0xFFF59E0B),
    textHeading: Color(0xFF1E293B),
    textSubtitle: Color(0xFF64748B),
    textMuted: Color(0xFF94A3B8),
    textOnPrimary: Color(0xFFFFFFFF),
    chartGridLine: Color(0xFFE2E8F0),
    chartLine: Color(0xFF3B82F6),
    tooltipBackground: Color(0xFF1E293B),
    teal: Color(0xFF14B8A6),
    purple: Color(0xFF8B5CF6),
    orange: Color(0xFFF97316),
  );

  static const AnalyticsPremiumColors dark = AnalyticsPremiumColors._(
    isDark: true,
    scaffoldBackground: AppColors.darkScaffoldBackground,
    cardBackground: AppColors.darkSurface,
    cardBorder: AppColors.darkBorder,
    primary: AppColors.darkPrimary,
    primaryGradientStart: AppColors.darkPrimary,
    primaryGradientEnd: AppColors.darkPrimaryLight,
    success: AppColors.darkSuccess,
    successLight: AppColors.darkSuccessLight,
    warning: AppColors.darkWarning,
    warningLight: AppColors.darkWarningLight,
    danger: AppColors.darkError,
    dangerLight: AppColors.darkErrorLight,
    info: AppColors.darkInfo,
    infoLight: AppColors.darkInfoLight,
    available: AppColors.darkSuccess,
    sold: AppColors.darkPrimary,
    reserved: AppColors.darkWarning,
    textHeading: AppColors.darkTextPrimary,
    textSubtitle: AppColors.darkTextSecondary,
    textMuted: AppColors.darkTextTertiary,
    textOnPrimary: AppColors.white,
    chartGridLine: AppColors.darkBorder,
    chartLine: AppColors.darkPrimaryLight,
    tooltipBackground: AppColors.darkSurfaceElevated,
    teal: Color(0xFF2DD4BF),
    purple: Color(0xFFA78BFA),
    orange: Color(0xFFFB923C),
  );

  static AnalyticsPremiumColors of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? dark : light;
  }

  LinearGradient get primaryGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          primaryGradientStart,
          primaryGradientEnd,
        ],
      );

  BoxShadow get cardShadow => BoxShadow(
        color: (isDark ? const Color(0xFF000000) : const Color(0xFF1A1F36))
            .withValues(alpha: isDark ? 0.35 : 0.05),
        blurRadius: isDark ? 16 : 20,
        offset: Offset(0, isDark ? 8 : 10),
      );

  BoxShadow get subtleShadow => BoxShadow(
        color: (isDark ? const Color(0xFF000000) : const Color(0xFF1A1F36))
            .withValues(alpha: isDark ? 0.25 : 0.03),
        blurRadius: 10,
        offset: const Offset(0, 4),
      );

  BoxShadow get elevatedShadow => BoxShadow(
        color: (isDark ? const Color(0xFF000000) : const Color(0xFF1A1F36))
            .withValues(alpha: isDark ? 0.45 : 0.08),
        blurRadius: isDark ? 24 : 30,
        offset: Offset(0, isDark ? 12 : 15),
      );

  BoxShadow get innerShadow => BoxShadow(
        color: (isDark ? const Color(0xFF000000) : const Color(0xFF1A1F36))
            .withValues(alpha: isDark ? 0.25 : 0.04),
        blurRadius: isDark ? 6 : 4,
        offset: Offset(0, isDark ? 3 : 2),
      );
}

/// Premium border radius presets
class AnalyticsRadius {
  AnalyticsRadius._();

  /// Small radius for buttons, chips
  static const double small = 8.0;

  /// Medium radius for inputs, small cards
  static const double medium = 12.0;

  /// Card radius - premium look
  static const double card = 20.0;

  /// Extra large for bottom sheets
  static const double extraLarge = 24.0;

  /// Chip/pill shape - fully rounded
  static const double chip = 100.0;

  /// Progress bar radius
  static const double progressBar = 8.0;
}

/// Premium gradients for analytics
class AnalyticsGradients {
  AnalyticsGradients._();

  /// Primary blue gradient
  static LinearGradient primary(AnalyticsPremiumColors colors) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          colors.primaryGradientStart,
          colors.primaryGradientEnd,
        ],
      );

  /// Success gradient
  static const LinearGradient success = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF22C55E),
      Color(0xFF4ADE80),
    ],
  );

  /// Chart area gradient (vertical, fades to transparent)
  static LinearGradient chartArea(Color color) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withValues(alpha: 0.25),
          color.withValues(alpha: 0.0),
        ],
      );
}
