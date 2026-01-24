import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/lead_model.dart';

class LeadDetailsHeaderCard extends StatelessWidget {
  final Lead lead;

  const LeadDetailsHeaderCard({super.key, required this.lead});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(AppSizes.p20.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
          width: AppSizes.borderThin,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar and Name Row
          Row(
            children: [
              // Large Avatar
              Container(
                width: 72.w,
                height: 72.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withValues(alpha: 0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
                ),
                child: Center(
                  child: Text(
                    _getInitials(lead.name),
                    style: AppTextStyles.h2.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppSizes.p16.w),
              // Name and Stage
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lead.name,
                      style: AppTextStyles.h3.copyWith(
                        color: theme.textTheme.titleLarge?.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: AppSizes.p8.h),
                    LeadStageBadge(stage: lead.stage),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.p16.h),
          Divider(color: theme.dividerColor, height: 1),
          SizedBox(height: AppSizes.p16.h),
          // Source and Expected Amount Row
          Row(
            children: [
              Expanded(
                child: LeadInfoItem(
                  icon: Icons.source_outlined,
                  label: 'leads_source'.tr(),
                  value: lead.source.displayName,
                ),
              ),
              Container(
                width: 1,
                height: 40.h,
                color: theme.dividerColor,
              ),
              Expanded(
                child: LeadInfoItem(
                  icon: Icons.attach_money,
                  label: 'leads_expected_amount'.tr(),
                  value: lead.expectedAmount != null
                      ? _formatAmount(lead.expectedAmount!)
                      : '-',
                ),
              ),
            ],
          ),
        ],
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
      return '${(amount / 1000000000).toStringAsFixed(1)} mlrd UZS';
    } else if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)} mln UZS';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)} ming UZS';
    }
    return '${amount.toStringAsFixed(0)} UZS';
  }
}

class LeadStageBadge extends StatelessWidget {
  final LeadStage stage;

  const LeadStageBadge({super.key, required this.stage});

  @override
  Widget build(BuildContext context) {
    final (color, bgColor) = _getStageColors(stage);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 6.h,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
      ),
      child: Text(
        stage.displayName,
        style: AppTextStyles.labelMedium.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  (Color, Color) _getStageColors(LeadStage stage) {
    return switch (stage) {
      LeadStage.newLead =>
        (AppColors.info, AppColors.info.withValues(alpha: 0.1)),
      LeadStage.contacted =>
        (AppColors.chartCyan, AppColors.chartCyan.withValues(alpha: 0.1)),
      LeadStage.qualified =>
        (AppColors.chartPurple, AppColors.chartPurple.withValues(alpha: 0.1)),
      LeadStage.showing =>
        (AppColors.chartYellow, AppColors.chartYellow.withValues(alpha: 0.1)),
      LeadStage.negotiation =>
        (AppColors.warning, AppColors.warning.withValues(alpha: 0.1)),
      LeadStage.reservation =>
        (AppColors.chartGreen, AppColors.chartGreen.withValues(alpha: 0.1)),
      LeadStage.contract =>
        (AppColors.primary, AppColors.primary.withValues(alpha: 0.1)),
      LeadStage.won =>
        (AppColors.success, AppColors.success.withValues(alpha: 0.1)),
      LeadStage.lost =>
        (AppColors.error, AppColors.error.withValues(alpha: 0.1)),
    };
  }
}

class LeadInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const LeadInfoItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(
          icon,
          size: 20.w,
          color: theme.textTheme.bodySmall?.color,
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: theme.textTheme.bodySmall?.color,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: AppTextStyles.labelMedium.copyWith(
            color: theme.textTheme.bodyLarge?.color,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
