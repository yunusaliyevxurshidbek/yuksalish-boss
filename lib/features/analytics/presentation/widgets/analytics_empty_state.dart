import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../theme/analytics_theme.dart';

/// Beautiful empty state widget for analytics dashboard
/// Features a grey icon inside a circular background with friendly text
class AnalyticsEmptyState extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final double iconSize;
  final VoidCallback? onAction;
  final String? actionLabel;

  const AnalyticsEmptyState({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.bar_chart_rounded,
    this.iconSize = 64,
    this.onAction,
    this.actionLabel,
  });

  /// Factory for generic no data state
  factory AnalyticsEmptyState.noData({
    String? title,
    String? subtitle,
  }) {
    return AnalyticsEmptyState(
      title: title ?? 'analytics_no_data'.tr(),
      subtitle: subtitle ?? 'analytics_no_data_subtitle'.tr(),
      icon: Icons.bar_chart_rounded,
    );
  }

  /// Factory for loading/waiting state
  factory AnalyticsEmptyState.waiting({
    String? title,
    String? subtitle,
  }) {
    return AnalyticsEmptyState(
      title: title ?? 'analytics_waiting_data'.tr(),
      subtitle: subtitle ?? 'analytics_please_wait_loading'.tr(),
      icon: Icons.hourglass_empty_rounded,
    );
  }

  /// Factory for chart-specific empty state
  factory AnalyticsEmptyState.chart({
    required String chartName,
  }) {
    return AnalyticsEmptyState(
      title: 'analytics_chart_no_data'.tr(namedArgs: {'chartName': chartName}),
      subtitle: 'analytics_period_no_data'.tr(),
      icon: Icons.show_chart_rounded,
    );
  }

  /// Factory for KPI empty state
  factory AnalyticsEmptyState.kpi() {
    return AnalyticsEmptyState(
      title: 'analytics_kpi_not_found'.tr(),
      subtitle: 'analytics_kpi_no_data'.tr(),
      icon: Icons.analytics_outlined,
    );
  }

  /// Factory for error state with retry
  factory AnalyticsEmptyState.error({
    String? title,
    String? subtitle,
    VoidCallback? onRetry,
  }) {
    return AnalyticsEmptyState(
      title: title ?? 'analytics_error_occurred'.tr(),
      subtitle: subtitle ?? 'analytics_error_loading_data'.tr(),
      icon: Icons.error_outline_rounded,
      onAction: onRetry,
      actionLabel: 'analytics_retry'.tr(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AnalyticsPremiumColors.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.p24.w,
        vertical: AppSizes.p32.h,
      ),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(AnalyticsRadius.card.r),
        boxShadow: [colors.subtleShadow],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon with circular background
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              color: colors.scaffoldBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: iconSize.w,
              color: colors.textMuted,
            ),
          ),
          SizedBox(height: AppSizes.p20.h),

          // Title
          Text(
            title,
            style: AppTextStyles.h4.copyWith(
              color: colors.textHeading,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),

          // Subtitle
          if (subtitle != null) ...[
            SizedBox(height: AppSizes.p8.h),
            Text(
              subtitle!,
              style: AppTextStyles.bodySmall.copyWith(
                color: colors.textSubtitle,
              ),
              textAlign: TextAlign.center,
            ),
          ],

          // Action button
          if (onAction != null && actionLabel != null) ...[
            SizedBox(height: AppSizes.p20.h),
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                foregroundColor: colors.primary,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.p16.w,
                  vertical: AppSizes.p8.h,
                ),
              ),
              child: Text(
                actionLabel!,
                style: AppTextStyles.labelLarge.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Compact empty state for inline use within cards
class AnalyticsEmptyStateCompact extends StatelessWidget {
  final String message;
  final IconData icon;

  const AnalyticsEmptyStateCompact({
    super.key,
    required this.message,
    this.icon = Icons.inbox_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AnalyticsPremiumColors.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.p24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: colors.scaffoldBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 28.w,
              color: colors.textMuted,
            ),
          ),
          SizedBox(height: AppSizes.p12.h),
          Text(
            message,
            style: AppTextStyles.bodySmall.copyWith(
              color: colors.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
