import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../presentation/widgets/custom_snacbar.dart';

/// Action buttons for approval detail screen.
class ApprovalDetailActions extends StatelessWidget {
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  const ApprovalDetailActions({
    super.key,
    this.onApprove,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.p16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onReject,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  padding: EdgeInsets.symmetric(vertical: AppSizes.p12.h),
                ),
                child: Text('approvals_reject'.tr()),
              ),
            ),
            SizedBox(width: AppSizes.p12.w),
            Expanded(
              child: ElevatedButton(
                onPressed: onApprove,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  padding: EdgeInsets.symmetric(vertical: AppSizes.p12.h),
                ),
                child: Text('approvals_approve'.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Shows confirmation dialog for approval/rejection.
  static void showConfirmDialog(BuildContext context, {required bool isApprove}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isApprove ? 'approvals_approve'.tr() : 'approvals_reject'.tr()),
        content: Text(
          isApprove
              ? 'approvals_confirm_approve'.tr()
              : 'approvals_confirm_reject'.tr(),
        ),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(),
            child: Text('common_cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              ctx.pop();
              context.pop();
              CustomSnacbar.show(
                context,
                text: isApprove ? 'approvals_approved_message'.tr() : 'approvals_rejected_message'.tr(),
                isError: !isApprove,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isApprove ? AppColors.success : AppColors.error,
            ),
            child: Text(isApprove ? 'approvals_approve'.tr() : 'approvals_reject'.tr()),
          ),
        ],
      ),
    );
  }
}
