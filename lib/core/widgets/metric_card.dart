import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_icons.dart';
import '../constants/app_sizes.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_colors.dart';
import 'app_shimmer.dart';

/// Reusable metric card for displaying KPIs and statistics.
///
/// Features:
/// - Title, value, and optional subtitle
/// - Trend indicator (up/down arrow with percentage)
/// - Optional leading icon
/// - Tap callback for navigation
/// - Loading shimmer state
///
/// Example:
/// ```dart
/// MetricCard(
///   title: "Umumiy daromad",
///   value: "2.4 mlrd",
///   subtitle: "UZS",
///   trend: 12.5, // positive = green up, negative = red down
///   onTap: () => context.push('/path'),
/// )
/// ```
class MetricCard extends StatelessWidget {
  /// Card title displayed at the top
  final String title;

  /// Main value displayed prominently
  final String value;

  /// Optional subtitle below the value (e.g., currency code)
  final String? subtitle;

  /// Trend percentage (positive = up/green, negative = down/red)
  /// If null, no trend indicator is shown
  final double? trend;

  /// Optional SVG icon string to display
  final String? iconSvg;

  /// Background color for the icon container
  final Color? iconBackgroundColor;

  /// Icon color
  final Color? iconColor;

  /// Callback when card is tapped
  final VoidCallback? onTap;

  /// Whether to show loading shimmer
  final bool isLoading;

  /// Card background color
  final Color? backgroundColor;

  /// Custom width (defaults to expand)
  final double? width;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.trend,
    this.iconSvg,
    this.iconBackgroundColor,
    this.iconColor,
    this.onTap,
    this.isLoading = false,
    this.backgroundColor,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildShimmer(context);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: EdgeInsets.all(AppSizes.p16.w),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top row: Icon and title
            Row(
              children: [
                if (iconSvg != null) ...[
                  _buildIcon(),
                  SizedBox(width: AppSizes.p12.w),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.labelMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (trend != null) _buildTrendBadge(),
              ],
            ),
            SizedBox(height: AppSizes.p12.h),
            // Value
            Text(
              value,
              style: AppTextStyles.metricMedium,
            ),
            if (subtitle != null) ...[
              SizedBox(height: AppSizes.p4.h),
              Text(
                subtitle!,
                style: AppTextStyles.caption,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: iconBackgroundColor ?? AppColors.primaryLight.withAlpha(26),
        borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
      ),
      child: Center(
        child: SvgPicture.string(
          iconSvg!,
          width: AppSizes.iconM.w,
          height: AppSizes.iconM.w,
          colorFilter: ColorFilter.mode(
            iconColor ?? AppColors.primary,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  Widget _buildTrendBadge() {
    final isPositive = trend! >= 0;
    final color = isPositive ? AppColors.success : AppColors.error;
    final bgColor = isPositive ? AppColors.successLight : AppColors.errorLight;
    final icon = isPositive ? AppIcons.trendingUp : AppIcons.trendingDown;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.p8.w,
        vertical: AppSizes.p4.h,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.string(
            icon,
            width: 12.w,
            height: 12.w,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          SizedBox(width: 4.w),
          Text(
            '${isPositive ? '+' : ''}${trend!.toStringAsFixed(1)}%',
            style: AppTextStyles.labelSmall.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final shimmerColor = isDark ? AppColors.darkBorder : AppColors.border;

    return AppShimmer(
      child: Container(
        width: width,
        padding: EdgeInsets.all(AppSizes.p16.w),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: shimmerColor,
                    borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
                  ),
                ),
                SizedBox(width: AppSizes.p12.w),
                Container(
                  width: 80.w,
                  height: 14.h,
                  decoration: BoxDecoration(
                    color: shimmerColor,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.p12.h),
            Container(
              width: 120.w,
              height: 28.h,
              decoration: BoxDecoration(
                color: shimmerColor,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(height: AppSizes.p4.h),
            Container(
              width: 60.w,
              height: 12.h,
              decoration: BoxDecoration(
                color: shimmerColor,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact metric card for grid layouts
class MetricCardCompact extends StatelessWidget {
  final String title;
  final String value;
  final String? iconSvg;
  final Color? accentColor;
  final VoidCallback? onTap;
  final bool isLoading;

  const MetricCardCompact({
    super.key,
    required this.title,
    required this.value,
    this.iconSvg,
    this.accentColor,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (isLoading) {
      final shimmerColor = isDark ? AppColors.darkBorder : AppColors.border;

      return AppShimmer(
        child: Container(
          padding: EdgeInsets.all(AppSizes.p12.w),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: shimmerColor,
                  borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
                ),
              ),
              SizedBox(height: AppSizes.p8.h),
              Container(
                width: 60.w,
                height: 20.h,
                color: shimmerColor,
              ),
              SizedBox(height: AppSizes.p4.h),
              Container(
                width: 40.w,
                height: 12.h,
                color: shimmerColor,
              ),
            ],
          ),
        ),
      );
    }

    final color = accentColor ?? AppColors.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSizes.p12.w),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(isDark ? 20 : 10),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (iconSvg != null)
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: color.withAlpha(isDark ? 51 : 26),
                  borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
                ),
                child: Center(
                  child: SvgPicture.string(
                    iconSvg!,
                    width: 16.w,
                    height: 16.w,
                    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                  ),
                ),
              ),
            SizedBox(height: AppSizes.p8.h),
            Text(
              value,
              style: AppTextStyles.metricSmall,
            ),
            SizedBox(height: AppSizes.p4.h),
            Text(
              title,
              style: AppTextStyles.caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
