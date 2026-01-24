import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/approval.dart';
import 'approval_card_actions.dart';
import 'approval_card_content.dart';
import 'approval_card_header.dart';

/// Card widget for displaying approval request.
class ApprovalCard extends StatelessWidget {
  final Approval approval;
  final VoidCallback? onTap;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final VoidCallback? onComment;
  final bool isProcessing;

  const ApprovalCard({
    super.key,
    required this.approval,
    this.onTap,
    this.onApprove,
    this.onReject,
    this.onComment,
    this.isProcessing = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final dividerColor = isDark ? AppColors.darkDivider : AppColors.border;
    final warningColor = isDark ? AppColors.darkWarning : AppColors.warning;
    final shadowColor = isDark
        ? Colors.black.withValues(alpha: 0.2)
        : Colors.black.withValues(alpha: 0.04);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: AppSizes.p12.h),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
          border: approval.isUrgent
              ? Border.all(color: warningColor, width: 1.5)
              : Border.all(color: borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ApprovalCardHeader(approval: approval),
            Divider(height: 1, color: dividerColor),
            ApprovalCardContent(approval: approval),
            Divider(height: 1, color: dividerColor),
            ApprovalCardActions(
              onApprove: onApprove,
              onReject: onReject,
              onComment: onComment,
              isProcessing: isProcessing,
            ),
          ],
        ),
      ),
    );
  }
}
