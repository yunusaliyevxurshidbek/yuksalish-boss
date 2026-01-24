import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/approval.dart';
import 'approval_card_utils.dart';

/// Header widget showing urgent badge and type chip.
class ApprovalCardHeader extends StatelessWidget {
  final Approval approval;

  const ApprovalCardHeader({super.key, required this.approval});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.p16.w,
        vertical: AppSizes.p12.h,
      ),
      child: Row(
        children: [
          if (approval.isUrgent) ...[
            _UrgentBadge(),
            const Spacer(),
          ] else
            const Spacer(),
          _ApprovalTypeChip(approval: approval),
        ],
      ),
    );
  }
}

class _UrgentBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final warningColor = isDark ? AppColors.darkWarning : AppColors.warning;
    final bgAlpha = isDark ? 0.2 : 0.1;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.p8.w,
        vertical: AppSizes.p4.h,
      ),
      decoration: BoxDecoration(
        color: warningColor.withValues(alpha: bgAlpha),
        borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 14.w,
            color: warningColor,
          ),
          SizedBox(width: AppSizes.p4.w),
          Text(
            'approvals_urgent'.tr(),
            style: AppTextStyles.caption.copyWith(
              color: warningColor,
              fontWeight: FontWeight.w700,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _ApprovalTypeChip extends StatelessWidget {
  final Approval approval;

  const _ApprovalTypeChip({required this.approval});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = getApprovalTypeColor(approval.type);
    final bgAlpha = isDark ? 0.2 : 0.1;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.p8.w,
        vertical: AppSizes.p4.h,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: bgAlpha),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            approval.typeEmoji,
            style: TextStyle(fontSize: 12.sp),
          ),
          SizedBox(width: AppSizes.p4.w),
          Text(
            approval.typeLabel.toUpperCase(),
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}
