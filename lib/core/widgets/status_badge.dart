import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_sizes.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_colors.dart';

/// Badge type enumeration for predefined styles
enum BadgeType {
  /// Green badge for success/completed states
  success,

  /// Yellow badge for warning/pending states
  warning,

  /// Red badge for error/overdue states
  error,

  /// Blue badge for informational states
  info,

  /// Grey badge for neutral/inactive states
  neutral,
}

/// Status badge widget with predefined styles.
///
/// Displays a small colored badge with text, commonly used to show
/// status indicators like "Completed", "Pending", "Overdue", etc.
///
/// Example:
/// ```dart
/// StatusBadge(
///   text: "Qurilish jarayonida",
///   type: BadgeType.success,
/// )
/// ```
class StatusBadge extends StatelessWidget {
  /// Text to display in the badge
  final String text;

  /// Badge type determining color scheme
  final BadgeType type;

  /// Optional custom background color (overrides type)
  final Color? backgroundColor;

  /// Optional custom text color (overrides type)
  final Color? textColor;

  /// Whether to show a dot indicator before text
  final bool showDot;

  /// Badge size variant
  final BadgeSize size;

  const StatusBadge({
    super.key,
    required this.text,
    this.type = BadgeType.neutral,
    this.backgroundColor,
    this.textColor,
    this.showDot = false,
    this.size = BadgeSize.medium,
  });

  /// Creates a success badge
  factory StatusBadge.success(String text, {bool showDot = false}) {
    return StatusBadge(text: text, type: BadgeType.success, showDot: showDot);
  }

  /// Creates a warning badge
  factory StatusBadge.warning(String text, {bool showDot = false}) {
    return StatusBadge(text: text, type: BadgeType.warning, showDot: showDot);
  }

  /// Creates an error badge
  factory StatusBadge.error(String text, {bool showDot = false}) {
    return StatusBadge(text: text, type: BadgeType.error, showDot: showDot);
  }

  /// Creates an info badge
  factory StatusBadge.info(String text, {bool showDot = false}) {
    return StatusBadge(text: text, type: BadgeType.info, showDot: showDot);
  }

  /// Creates a neutral badge
  factory StatusBadge.neutral(String text, {bool showDot = false}) {
    return StatusBadge(text: text, type: BadgeType.neutral, showDot: showDot);
  }

  @override
  Widget build(BuildContext context) {
    final colors = _getColors();
    final padding = _getPadding();
    final textStyle = _getTextStyle();

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.background,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: size == BadgeSize.small ? 4.w : 6.w,
              height: size == BadgeSize.small ? 4.w : 6.w,
              decoration: BoxDecoration(
                color: textColor ?? colors.foreground,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 6.w),
          ],
          Text(
            text,
            style: textStyle.copyWith(
              color: textColor ?? colors.foreground,
            ),
          ),
        ],
      ),
    );
  }

  _BadgeColors _getColors() {
    switch (type) {
      case BadgeType.success:
        return _BadgeColors(
          background: AppColors.successLight,
          foreground: AppColors.success,
        );
      case BadgeType.warning:
        return _BadgeColors(
          background: AppColors.warningLight,
          foreground: AppColors.warning,
        );
      case BadgeType.error:
        return _BadgeColors(
          background: AppColors.errorLight,
          foreground: AppColors.error,
        );
      case BadgeType.info:
        return _BadgeColors(
          background: AppColors.infoLight,
          foreground: AppColors.info,
        );
      case BadgeType.neutral:
        return _BadgeColors(
          background: AppColors.divider,
          foreground: AppColors.textSecondary,
        );
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case BadgeSize.small:
        return EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h);
      case BadgeSize.medium:
        return EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h);
      case BadgeSize.large:
        return EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h);
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case BadgeSize.small:
        return AppTextStyles.caption;
      case BadgeSize.medium:
        return AppTextStyles.labelSmall;
      case BadgeSize.large:
        return AppTextStyles.labelMedium;
    }
  }
}

/// Badge size variants
enum BadgeSize {
  small,
  medium,
  large,
}

/// Internal class for badge color pairs
class _BadgeColors {
  final Color background;
  final Color foreground;

  const _BadgeColors({
    required this.background,
    required this.foreground,
  });
}

/// Notification count badge (typically shown on icons)
class CountBadge extends StatelessWidget {
  /// Count to display
  final int count;

  /// Maximum count before showing "99+"
  final int maxCount;

  /// Badge background color
  final Color? backgroundColor;

  /// Text color
  final Color? textColor;

  /// Whether to show badge when count is 0
  final bool showZero;

  const CountBadge({
    super.key,
    required this.count,
    this.maxCount = 99,
    this.backgroundColor,
    this.textColor,
    this.showZero = false,
  });

  @override
  Widget build(BuildContext context) {
    if (count <= 0 && !showZero) {
      return const SizedBox.shrink();
    }

    final displayText = count > maxCount ? '$maxCount+' : count.toString();

    return Container(
      constraints: BoxConstraints(
        minWidth: 18.w,
        minHeight: 18.w,
      ),
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.error,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull.r),
      ),
      child: Center(
        child: Text(
          displayText,
          style: AppTextStyles.caption.copyWith(
            color: textColor ?? AppColors.textOnPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
