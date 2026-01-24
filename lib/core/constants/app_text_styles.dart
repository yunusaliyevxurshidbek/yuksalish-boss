import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// App-wide text styles using Google Fonts Inter.
///
/// All font sizes are defined in sp (scaled pixels) for responsive typography.
/// Use ScreenUtil extension (.sp) when applying these styles.
///
/// Hierarchy:
/// - H1: 28sp Bold - Main screen titles
/// - H2: 24sp SemiBold - Section headers
/// - H3: 20sp SemiBold - Card titles
/// - H4: 18sp Medium - Subsection headers
/// - bodyLarge: 16sp Regular - Primary body text
/// - bodyMedium: 14sp Regular - Secondary body text
/// - bodySmall: 12sp Regular - Tertiary body text
/// - labelLarge: 14sp SemiBold - Button text, emphasized labels
/// - labelMedium: 12sp Medium - Tags, chips, small labels
/// - caption: 11sp Regular - Timestamps, helper text
abstract class AppTextStyles {
  // ═══════════════════════════════════════════════════════════════════════════
  // HEADINGS
  // ═══════════════════════════════════════════════════════════════════════════

  /// H1 - Main screen titles
  /// 28sp Bold
  static TextStyle get h1 => GoogleFonts.inter(
        fontSize: 28.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  /// H2 - Section headers
  /// 24sp SemiBold
  static TextStyle get h2 => GoogleFonts.inter(
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  /// H3 - Card titles, modal headers
  /// 20sp SemiBold
  static TextStyle get h3 => GoogleFonts.inter(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  /// H4 - Subsection headers
  /// 18sp Medium
  static TextStyle get h4 => GoogleFonts.inter(
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // BODY TEXT
  // ═══════════════════════════════════════════════════════════════════════════

  /// Body Large - Primary body text
  /// 16sp Regular
  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.5,
      );

  /// Body Medium - Secondary body text
  /// 14sp Regular
  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.5,
      );

  /// Body Small - Tertiary body text
  /// 12sp Regular
  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.5,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // LABELS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Label Large - Button text, emphasized labels
  /// 14sp SemiBold
  static TextStyle get labelLarge => GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  /// Label Medium - Tags, chips, small labels
  /// 12sp Medium
  static TextStyle get labelMedium => GoogleFonts.inter(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        height: 1.4,
      );

  /// Label Small - Tiny labels
  /// 11sp Medium
  static TextStyle get labelSmall => GoogleFonts.inter(
        fontSize: 11.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textTertiary,
        height: 1.4,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // SPECIAL STYLES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Caption - Timestamps, helper text, metadata
  /// 11sp Regular
  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 11.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textTertiary,
        height: 1.4,
      );

  /// Overline - Section labels, category titles
  /// 10sp Medium, uppercase, letter-spacing 1.2
  static TextStyle get overline => GoogleFonts.inter(
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textTertiary,
        letterSpacing: 1.2,
        height: 1.4,
      );

  /// Metric Value Large - Big numbers on dashboard
  /// 32sp Bold
  static TextStyle get metricLarge => GoogleFonts.inter(
        fontSize: 32.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.2,
      );

  /// Metric Value Medium - Medium numbers on cards
  /// 24sp Bold
  static TextStyle get metricMedium => GoogleFonts.inter(
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.2,
      );

  /// Metric Value Small - Small numbers, percentages
  /// 18sp SemiBold
  static TextStyle get metricSmall => GoogleFonts.inter(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.2,
      );

  /// Button Text - Primary button labels
  /// 14sp SemiBold
  static TextStyle get button => GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textOnPrimary,
        height: 1.4,
      );

  /// Navigation Label - Bottom nav labels
  /// 10sp Medium
  static TextStyle get navLabel => GoogleFonts.inter(
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
        height: 1.4,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // STYLE MODIFIERS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Apply primary text color
  static TextStyle withPrimaryColor(TextStyle style) =>
      style.copyWith(color: AppColors.textPrimary);

  /// Apply secondary text color
  static TextStyle withSecondaryColor(TextStyle style) =>
      style.copyWith(color: AppColors.textSecondary);

  /// Apply tertiary text color
  static TextStyle withTertiaryColor(TextStyle style) =>
      style.copyWith(color: AppColors.textTertiary);

  /// Apply white text color (for dark backgrounds)
  static TextStyle withWhiteColor(TextStyle style) =>
      style.copyWith(color: AppColors.textOnPrimary);

  /// Apply success color
  static TextStyle withSuccessColor(TextStyle style) =>
      style.copyWith(color: AppColors.success);

  /// Apply warning color
  static TextStyle withWarningColor(TextStyle style) =>
      style.copyWith(color: AppColors.warning);

  /// Apply error color
  static TextStyle withErrorColor(TextStyle style) =>
      style.copyWith(color: AppColors.error);

  /// Apply custom color
  static TextStyle withColor(TextStyle style, Color color) =>
      style.copyWith(color: color);

  /// Make text bold
  static TextStyle bold(TextStyle style) =>
      style.copyWith(fontWeight: FontWeight.w700);

  /// Make text semi-bold
  static TextStyle semiBold(TextStyle style) =>
      style.copyWith(fontWeight: FontWeight.w600);

  /// Make text medium weight
  static TextStyle medium(TextStyle style) =>
      style.copyWith(fontWeight: FontWeight.w500);
}
