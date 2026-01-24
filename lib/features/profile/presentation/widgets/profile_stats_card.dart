import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/repositories/profile_repository.dart';
import '../theme/profile_theme.dart';

/// Statistics card showing approval counts (approved, rejected, pending).
class ProfileStatsCard extends StatelessWidget {
  final ProfileStatistics statistics;
  final bool isLoading;

  const ProfileStatsCard({
    super.key,
    required this.statistics,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSizes.p16.w),
      padding: EdgeInsets.symmetric(vertical: AppSizes.p16.h),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
        boxShadow: [colors.cardShadow],
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              value: statistics.approvedCount,
              labelKey: 'profile_stats_approved',
              color: colors.success,
              isLoading: isLoading,
            ),
          ),
          _buildDivider(context),
          Expanded(
            child: _StatItem(
              value: statistics.rejectedCount,
              labelKey: 'profile_stats_rejected',
              color: colors.error,
              isLoading: isLoading,
            ),
          ),
          _buildDivider(context),
          Expanded(
            child: _StatItem(
              value: statistics.pendingCount,
              labelKey: 'profile_stats_pending',
              color: colors.warning,
              isLoading: isLoading,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return Container(
      width: 1,
      height: 40.h,
      color: colors.divider,
    );
  }
}

class _StatItem extends StatelessWidget {
  final int value;
  final String labelKey;
  final Color color;
  final bool isLoading;

  const _StatItem({
    required this.value,
    required this.labelKey,
    required this.color,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isLoading)
          SizedBox(
            width: 24.w,
            height: 24.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          )
        else
          Text(
            value.toString(),
            style: AppTextStyles.metricMedium.copyWith(
              color: color,
            ),
          ),
        SizedBox(height: 4.h),
        Text(
          labelKey.tr(),
          style: AppTextStyles.caption.copyWith(
            color: colors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
