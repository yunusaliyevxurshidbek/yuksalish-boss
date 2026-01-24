import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/app_colors.dart';

/// Section showing attachments count.
class ApprovalAttachmentsSection extends StatelessWidget {
  final int count;
  final VoidCallback? onTap;

  const ApprovalAttachmentsSection({
    super.key,
    required this.count,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSizes.p12.w),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(
              Icons.attach_file_rounded,
              size: AppSizes.iconM.w,
              color: AppColors.textSecondary,
            ),
            SizedBox(width: AppSizes.p8.w),
            Expanded(
              child: Text(
                'approvals_attachments'.tr(args: ['$count']),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: AppSizes.iconM.w,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
