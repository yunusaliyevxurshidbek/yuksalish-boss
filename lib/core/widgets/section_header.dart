import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_sizes.dart';
import '../constants/app_text_styles.dart';

/// Section header with title and optional action button.
///
/// Used to separate content sections with a title and optional
/// "See all" or other action button.
///
/// Example:
/// ```dart
/// SectionHeader(
///   title: "Sotuv dinamikasi",
///   actionText: "Barchasi",
///   onActionTap: () => context.push('/path'),
/// )
/// ```
class SectionHeader extends StatelessWidget {
  /// Section title text
  final String title;

  /// Optional subtitle text
  final String? subtitle;

  /// Optional action button text (e.g., "Barchasi", "Ko'proq")
  final String? actionText;

  /// Callback when action button is tapped
  final VoidCallback? onActionTap;

  /// Optional leading widget (icon, badge, etc.)
  final Widget? leading;

  /// Optional trailing widget (replaces action text if provided)
  final Widget? trailing;

  /// Padding around the header
  final EdgeInsets? padding;

  /// Title text style override
  final TextStyle? titleStyle;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onActionTap,
    this.leading,
    this.trailing,
    this.padding,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: AppSizes.p16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (leading != null) ...[
            leading!,
            SizedBox(width: AppSizes.p8.w),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: titleStyle ??
                      AppTextStyles.h4.copyWith(
                        color: theme.textTheme.titleMedium?.color,
                      ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 2.h),
                  Text(
                    subtitle!,
                    style: AppTextStyles.caption.copyWith(
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null)
            trailing!
          else if (actionText != null)
            _buildActionButton(context),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onActionTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSizes.p4.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              actionText!,
              style: AppTextStyles.labelMedium.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            SizedBox(width: 4.w),
            Icon(
              Icons.chevron_right_rounded,
              size: AppSizes.iconS.w,
              color: theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact section header for smaller sections
class SectionHeaderCompact extends StatelessWidget {
  /// Section title text
  final String title;

  /// Optional count badge to show
  final int? count;

  /// Callback when header is tapped
  final VoidCallback? onTap;

  const SectionHeaderCompact({
    super.key,
    required this.title,
    this.count,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.p16.w,
          vertical: AppSizes.p8.h,
        ),
        child: Row(
          children: [
            Text(
              title.toUpperCase(),
              style: AppTextStyles.overline.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
            if (count != null) ...[
              SizedBox(width: AppSizes.p8.w),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 6.w,
                  vertical: 2.h,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withAlpha(26),
                  borderRadius: BorderRadius.circular(AppSizes.radiusFull.r),
                ),
                child: Text(
                  count.toString(),
                  style: AppTextStyles.caption.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            const Spacer(),
            if (onTap != null)
              Icon(
                Icons.chevron_right_rounded,
                size: AppSizes.iconS.w,
                color: theme.textTheme.bodySmall?.color,
              ),
          ],
        ),
      ),
    );
  }
}

/// Section divider with optional label
class SectionDivider extends StatelessWidget {
  /// Optional label to show in the divider
  final String? label;

  /// Divider color
  final Color? color;

  /// Vertical padding around divider
  final double verticalPadding;

  const SectionDivider({
    super.key,
    this.label,
    this.color,
    this.verticalPadding = 16,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dividerColor = color ?? theme.dividerColor;

    if (label == null) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: verticalPadding.h),
        child: Divider(
          height: 1,
          thickness: 1,
          color: dividerColor,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding.h),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              height: 1,
              thickness: 1,
              color: dividerColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.p12.w),
            child: Text(
              label!,
              style: AppTextStyles.caption.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              height: 1,
              thickness: 1,
              color: dividerColor,
            ),
          ),
        ],
      ),
    );
  }
}
