import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';

/// Action buttons for approval card (approve/reject).
class ApprovalCardActions extends StatelessWidget {
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final VoidCallback? onComment;
  final bool isProcessing;

  const ApprovalCardActions({
    super.key,
    this.onApprove,
    this.onReject,
    this.onComment,
    this.isProcessing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSizes.p12.w),
      child: Row(
        children: [
          Expanded(child: _RejectButton(onReject: onReject, isProcessing: isProcessing)),
          SizedBox(width: AppSizes.p8.w),
          if (onComment != null) ...[
            _CommentButton(onComment: onComment, isProcessing: isProcessing),
            SizedBox(width: AppSizes.p8.w),
          ],
          Expanded(child: _ApproveButton(onApprove: onApprove, isProcessing: isProcessing)),
        ],
      ),
    );
  }
}

class _RejectButton extends StatelessWidget {
  final VoidCallback? onReject;
  final bool isProcessing;

  const _RejectButton({this.onReject, required this.isProcessing});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final errorColor = isDark ? AppColors.darkError : AppColors.error;

    return OutlinedButton(
      onPressed: isProcessing ? null : onReject,
      style: OutlinedButton.styleFrom(
        foregroundColor: errorColor,
        side: BorderSide(color: errorColor.withValues(alpha: 0.5)),
        padding: EdgeInsets.symmetric(vertical: AppSizes.p12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.close_rounded, size: 18.w),
          SizedBox(width: AppSizes.p4.w),
          Text(
            'approvals_reject'.tr(),
            style: AppTextStyles.button.copyWith(
              color: errorColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentButton extends StatelessWidget {
  final VoidCallback? onComment;
  final bool isProcessing;

  const _CommentButton({this.onComment, required this.isProcessing});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final textSecondaryColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return IconButton(
      onPressed: isProcessing ? null : onComment,
      style: IconButton.styleFrom(
        backgroundColor: borderColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
        ),
      ),
      icon: Icon(
        Icons.chat_bubble_outline_rounded,
        size: 20.w,
        color: textSecondaryColor,
      ),
    );
  }
}

class _ApproveButton extends StatelessWidget {
  final VoidCallback? onApprove;
  final bool isProcessing;

  const _ApproveButton({this.onApprove, required this.isProcessing});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final successColor = isDark ? AppColors.darkSuccess : AppColors.success;

    return ElevatedButton(
      onPressed: isProcessing ? null : onApprove,
      style: ElevatedButton.styleFrom(
        backgroundColor: successColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: AppSizes.p12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
        ),
      ),
      child: isProcessing
          ? SizedBox(
              width: 18.w,
              height: 18.w,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_rounded, size: 18.w),
                SizedBox(width: AppSizes.p4.w),
                Text(
                  'approvals_approve'.tr(),
                  style: AppTextStyles.button.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
    );
  }
}
