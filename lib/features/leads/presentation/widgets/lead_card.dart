import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/lead_model.dart';

/// Card widget for displaying a single lead
class LeadCard extends StatelessWidget {
  final Lead lead;
  final VoidCallback? onTap;

  const LeadCard({
    super.key,
    required this.lead,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSizes.p16.w),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.border,
            width: AppSizes.borderThin,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: Name + Stage badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
                  ),
                  child: Center(
                    child: Text(
                      _getInitials(lead.name),
                      style: AppTextStyles.labelLarge.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppSizes.p12.w),
                // Name and phone
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lead.name,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (lead.phone != null && lead.phone!.isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        Text(
                          lead.phone!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Stage badge
                _StageBadge(stage: lead.stage),
              ],
            ),

            SizedBox(height: AppSizes.p12.h),

            // Info row
            Row(
              children: [
                // Source
                _InfoChip(
                  icon: Icons.link,
                  label: lead.source.translationKey.tr(),
                ),
                SizedBox(width: AppSizes.p8.w),
                // Expected amount if available
                if (lead.expectedAmount != null && lead.expectedAmount! > 0)
                  _InfoChip(
                    icon: Icons.attach_money,
                    label: _formatAmount(lead.expectedAmount!),
                  ),
              ],
            ),

            // Property interest if available
            if (lead.propertyInterest != null && lead.propertyInterest!.isNotEmpty) ...[
              SizedBox(height: AppSizes.p8.h),
              Text(
                lead.propertyInterest!,
                style: AppTextStyles.bodySmall.copyWith(
                  color: theme.textTheme.bodySmall?.color,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            // Bottom row: Date
            SizedBox(height: AppSizes.p8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.access_time,
                  size: 12.w,
                  color: theme.textTheme.bodySmall?.color,
                ),
                SizedBox(width: 4.w),
                Text(
                  _formatDate(lead.createdAt),
                  style: AppTextStyles.caption.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '?';
  }

  String _formatAmount(double amount) {
    if (amount >= 1000000000) {
      return '${(amount / 1000000000).toStringAsFixed(1)} mlrd';
    } else if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)} mln';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)} ming';
    }
    return amount.toStringAsFixed(0);
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return 'leads_date_today'.tr();
    } else if (diff.inDays == 1) {
      return 'leads_date_yesterday'.tr();
    } else if (diff.inDays < 7) {
      return 'leads_date_days_ago'.tr(namedArgs: {'count': diff.inDays.toString()});
    } else {
      return '${date.day}.${date.month.toString().padLeft(2, '0')}.${date.year}';
    }
  }
}

class _StageBadge extends StatelessWidget {
  final LeadStage stage;

  const _StageBadge({required this.stage});

  @override
  Widget build(BuildContext context) {
    final (color, bgColor) = _getStageColors(stage);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
      ),
      child: Text(
        stage.translationKey.tr(),
        style: AppTextStyles.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  (Color, Color) _getStageColors(LeadStage stage) {
    return switch (stage) {
      LeadStage.newLead => (AppColors.info, AppColors.info.withValues(alpha: 0.1)),
      LeadStage.contacted => (AppColors.chartCyan, AppColors.chartCyan.withValues(alpha: 0.1)),
      LeadStage.qualified => (AppColors.chartPurple, AppColors.chartPurple.withValues(alpha: 0.1)),
      LeadStage.showing => (AppColors.chartYellow, AppColors.chartYellow.withValues(alpha: 0.1)),
      LeadStage.negotiation => (AppColors.warning, AppColors.warning.withValues(alpha: 0.1)),
      LeadStage.reservation => (AppColors.chartGreen, AppColors.chartGreen.withValues(alpha: 0.1)),
      LeadStage.contract => (AppColors.primary, AppColors.primary.withValues(alpha: 0.1)),
      LeadStage.won => (AppColors.success, AppColors.success.withValues(alpha: 0.1)),
      LeadStage.lost => (AppColors.error, AppColors.error.withValues(alpha: 0.1)),
    };
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceElevated : AppColors.background,
        borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12.w,
            color: theme.textTheme.bodySmall?.color,
          ),
          SizedBox(width: 4.w),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }
}
