import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/app_colors.dart';

/// Confirmation widget for rejecting an approval.
class ApprovalRejectConfirmation extends StatelessWidget {
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;

  const ApprovalRejectConfirmation({
    super.key,
    this.onCancel,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.p16.w),
      color: AppColors.errorLight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'approvals_reject_dialog_title'.tr(),
            style: AppTextStyles.h4.copyWith(
              color: AppColors.error,
            ),
          ),
          SizedBox(height: AppSizes.p8.h),
          Text(
            'approvals_reject_dialog_message'.tr(),
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppSizes.p16.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onCancel,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    side: BorderSide(color: AppColors.border),
                    padding: EdgeInsets.symmetric(vertical: AppSizes.p12.h),
                  ),
                  child: Text('common_cancel'.tr()),
                ),
              ),
              SizedBox(width: AppSizes.p12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: AppSizes.p12.h),
                  ),
                  child: Text('approvals_reject_confirm'.tr()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
