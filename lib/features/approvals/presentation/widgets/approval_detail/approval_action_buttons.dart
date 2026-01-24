import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/app_colors.dart';

/// Action buttons for approve and reject.
class ApprovalActionButtons extends StatelessWidget {
  final bool isProcessing;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  const ApprovalActionButtons({
    super.key,
    this.isProcessing = false,
    this.onApprove,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSizes.p16.w),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: isProcessing ? null : onReject,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: BorderSide(color: AppColors.error),
                padding: EdgeInsets.symmetric(vertical: AppSizes.p16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.close_rounded, size: AppSizes.iconM.w),
                  SizedBox(width: AppSizes.p8.w),
                  Text(
                    'approvals_reject'.tr(),
                    style: AppTextStyles.button.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: AppSizes.p12.w),
          Expanded(
            child: ElevatedButton(
              onPressed: isProcessing ? null : onApprove,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: AppSizes.p16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
                ),
              ),
              child: isProcessing
                  ? SizedBox(
                      width: AppSizes.iconM.w,
                      height: AppSizes.iconM.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_rounded, size: AppSizes.iconM.w),
                        SizedBox(width: AppSizes.p8.w),
                        Text(
                          'approvals_approve'.tr(),
                          style: AppTextStyles.button.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
