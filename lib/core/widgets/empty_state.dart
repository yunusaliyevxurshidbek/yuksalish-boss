import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_icons.dart';
import '../constants/app_sizes.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_colors.dart';

// Re-export for backward compatibility
export 'content_placeholder.dart';

/// Empty state widget for displaying when no data is available.
///
/// Shows a centered message with optional icon, title, description,
/// and action button. Used for empty lists, search results, etc.
class EmptyState extends StatelessWidget {
  /// SVG icon string to display.
  final String? iconSvg;

  /// Icon widget (alternative to iconSvg).
  final Widget? icon;

  /// Main title text.
  final String title;

  /// Optional description text.
  final String? description;

  /// Optional action button text.
  final String? actionText;

  /// Callback when action button is tapped.
  final VoidCallback? onAction;

  /// Icon size.
  final double iconSize;

  /// Icon color.
  final Color? iconColor;

  /// Whether to use compact layout.
  final bool compact;

  const EmptyState({
    super.key,
    this.iconSvg,
    this.icon,
    required this.title,
    this.description,
    this.actionText,
    this.onAction,
    this.iconSize = 64,
    this.iconColor,
    this.compact = false,
  });

  /// Creates an empty state for no search results.
  factory EmptyState.noResults({
    String title = "Natija topilmadi",
    String? description,
    VoidCallback? onClear,
  }) {
    return EmptyState(
      iconSvg: AppIcons.search,
      title: title,
      description: description ?? "Qidiruv so'rovingizga mos natija topilmadi",
      actionText: onClear != null ? "Tozalash" : null,
      onAction: onClear,
    );
  }

  /// Creates an empty state for no data.
  factory EmptyState.noData({
    required String title,
    String? description,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return EmptyState(
      iconSvg: AppIcons.document,
      title: title,
      description: description,
      actionText: actionText,
      onAction: onAction,
    );
  }

  /// Creates an empty state for errors.
  factory EmptyState.error({
    String title = "Xatolik yuz berdi",
    String? description,
    VoidCallback? onRetry,
  }) {
    return EmptyState(
      iconSvg: AppIcons.warning,
      title: title,
      description: description ?? "Iltimos, qaytadan urinib ko'ring",
      actionText: onRetry != null ? "Qayta urinish" : null,
      onAction: onRetry,
      iconColor: AppColors.error,
    );
  }

  /// Creates an empty state for offline/no connection.
  factory EmptyState.offline({VoidCallback? onRetry}) {
    return EmptyState(
      iconSvg: AppIcons.warning,
      title: "Internet aloqasi yo'q",
      description: "Internet ulanishini tekshiring va qaytadan urinib ko'ring",
      actionText: onRetry != null ? "Qayta urinish" : null,
      onAction: onRetry,
      iconColor: AppColors.warning,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _EmptyStateCompact(
        icon: _buildIcon(size: 40),
        title: title,
        description: description,
        actionText: actionText,
        onAction: onAction,
      );
    }
    return _EmptyStateFull(
      icon: _buildIcon(),
      title: title,
      description: description,
      actionText: actionText,
      onAction: onAction,
    );
  }

  Widget _buildIcon({double? size}) {
    final effectiveSize = size ?? iconSize;

    if (icon != null) {
      return icon!;
    }

    if (iconSvg != null) {
      return Container(
        width: effectiveSize.w,
        height: effectiveSize.w,
        decoration: BoxDecoration(
          color: (iconColor ?? AppColors.textTertiary).withAlpha(26),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: SvgPicture.string(
            iconSvg!,
            width: (effectiveSize * 0.5).w,
            height: (effectiveSize * 0.5).w,
            colorFilter: ColorFilter.mode(
              iconColor ?? AppColors.textTertiary,
              BlendMode.srcIn,
            ),
          ),
        ),
      );
    }

    return Container(
      width: effectiveSize.w,
      height: effectiveSize.w,
      decoration: BoxDecoration(
        color: AppColors.divider,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          Icons.inbox_outlined,
          size: (effectiveSize * 0.5).w,
          color: AppColors.textTertiary,
        ),
      ),
    );
  }
}

class _EmptyStateFull extends StatelessWidget {
  final Widget icon;
  final String title;
  final String? description;
  final String? actionText;
  final VoidCallback? onAction;

  const _EmptyStateFull({
    required this.icon,
    required this.title,
    this.description,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.p32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            SizedBox(height: AppSizes.p24.h),
            Text(
              title,
              style: AppTextStyles.h4,
              textAlign: TextAlign.center,
            ),
            if (description != null) ...[
              SizedBox(height: AppSizes.p8.h),
              Text(
                description!,
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
            if (actionText != null && onAction != null) ...[
              SizedBox(height: AppSizes.p24.h),
              _EmptyStateActionButton(text: actionText!, onPressed: onAction!),
            ],
          ],
        ),
      ),
    );
  }
}

class _EmptyStateCompact extends StatelessWidget {
  final Widget icon;
  final String title;
  final String? description;
  final String? actionText;
  final VoidCallback? onAction;

  const _EmptyStateCompact({
    required this.icon,
    required this.title,
    this.description,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSizes.p16.w),
      child: Row(
        children: [
          icon,
          SizedBox(width: AppSizes.p16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: AppTextStyles.labelLarge),
                if (description != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    description!,
                    style: AppTextStyles.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (actionText != null && onAction != null) ...[
            SizedBox(width: AppSizes.p12.w),
            TextButton(
              onPressed: onAction,
              child: Text(
                actionText!,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptyStateActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _EmptyStateActionButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.p24.w,
          vertical: AppSizes.p12.h,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
        ),
      ),
      child: Text(text, style: AppTextStyles.button),
    );
  }
}
