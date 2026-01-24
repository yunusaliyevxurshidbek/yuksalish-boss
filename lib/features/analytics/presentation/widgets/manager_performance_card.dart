import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../theme/analytics_theme.dart';

class ManagerPerformanceCard extends StatelessWidget {
  final int rank;
  final String name;
  final int deals;
  final String revenue;

  const ManagerPerformanceCard({
    super.key,
    required this.rank,
    required this.name,
    required this.deals,
    required this.revenue,
  });

  String _getMedalOrRank(int rank) {
    switch (rank) {
      case 1:
        return '🥇';
      case 2:
        return '🥈';
      case 3:
        return '🥉';
      default:
        return rank.toString();
    }
  }

  Color _getBadgeColor(int rank, AnalyticsPremiumColors colors) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return colors.cardBorder;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AnalyticsPremiumColors.of(context);
    final isTopThree = rank <= 3;
    final badgeColor = _getBadgeColor(rank, colors);
    final badgeText = _getMedalOrRank(rank);

    return Container(
      padding: EdgeInsets.all(AppSizes.p16.w),
      margin: EdgeInsets.only(bottom: AppSizes.p12.h),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
        border: Border.all(color: colors.cardBorder),
        boxShadow: [
          colors.subtleShadow,
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isTopThree
                  ? badgeColor.withValues(alpha: 0.2)
                  : colors.cardBorder.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              badgeText,
              style: isTopThree
                  ? TextStyle(fontSize: 18.sp)
                  : AppTextStyles.labelMedium.copyWith(
                      color: colors.textHeading,
                      fontWeight: FontWeight.w700,
                    ),
            ),
          ),
          SizedBox(width: AppSizes.p12.w),
          _InitialsAvatar(name: name),
          SizedBox(width: AppSizes.p12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: colors.textHeading,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'analytics_deals_closed'.tr(namedArgs: {'count': '$deals'}),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                revenue,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'analytics_revenue_label'.tr(),
                style: AppTextStyles.caption.copyWith(
                  color: colors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  final String name;

  const _InitialsAvatar({required this.name});

  @override
  Widget build(BuildContext context) {
    final colors = AnalyticsPremiumColors.of(context);
    final initials = _getInitials(name);
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: AppTextStyles.labelLarge.copyWith(
          color: colors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  String _getInitials(String value) {
    final parts = value.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    final first = parts.first.isNotEmpty ? parts.first[0] : '';
    final last = parts.last.isNotEmpty ? parts.last[0] : '';
    return '$first$last'.toUpperCase();
  }
}
