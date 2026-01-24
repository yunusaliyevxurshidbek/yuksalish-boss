import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/lead_model.dart';

/// Horizontal scrolling filter for lead stages
class LeadStageFilter extends StatelessWidget {
  final LeadStage? selectedStage;
  final ValueChanged<LeadStage?> onStageSelected;

  const LeadStageFilter({
    super.key,
    required this.selectedStage,
    required this.onStageSelected,
  });

  @override
  Widget build(BuildContext context) {
    final stages = [
      (null, 'leads_filter_all'.tr()),
      (LeadStage.newLead, 'leads_stage_new'.tr()),
      (LeadStage.contacted, 'leads_stage_contacted'.tr()),
      (LeadStage.qualified, 'leads_stage_qualified'.tr()),
      (LeadStage.showing, 'leads_stage_showing'.tr()),
      (LeadStage.negotiation, 'leads_stage_negotiation'.tr()),
      (LeadStage.reservation, 'leads_stage_reservation'.tr()),
      (LeadStage.contract, 'leads_stage_contract'.tr()),
      (LeadStage.won, 'leads_stage_won'.tr()),
      (LeadStage.lost, 'leads_stage_lost'.tr()),
    ];

    return Container(
      height: 48.h,
      margin: EdgeInsets.only(bottom: AppSizes.p8.h),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppSizes.p16.w),
        itemCount: stages.length,
        separatorBuilder: (context, index) => SizedBox(width: AppSizes.p8.w),
        itemBuilder: (context, index) {
          final (stage, label) = stages[index];
          final isSelected = selectedStage == stage;

          return _StageChip(
            label: label,
            isSelected: isSelected,
            onTap: () => onStageSelected(stage),
          );
        },
      ),
    );
  }
}

class _StageChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _StageChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.p16.w,
          vertical: AppSizes.p8.h,
        ),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : theme.cardColor,
          borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : (isDark ? AppColors.darkBorder : AppColors.border),
            width: AppSizes.borderThin,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(
              color: isSelected
                  ? theme.colorScheme.onPrimary
                  : theme.textTheme.bodyMedium?.color,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
