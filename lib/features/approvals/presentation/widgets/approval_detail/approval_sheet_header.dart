import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/app_colors.dart';

/// Header widget for the approval detail sheet.
class ApprovalSheetHeader extends StatelessWidget {
  final String typeLabel;
  final VoidCallback? onClose;

  const ApprovalSheetHeader({
    super.key,
    required this.typeLabel,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSizes.p16.w),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'approvals_sheet_header'.tr(args: [typeLabel]),
              style: AppTextStyles.h4.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          IconButton(
            onPressed: onClose ?? () => context.pop(),
            icon: Icon(
              Icons.close_rounded,
              color: AppColors.textSecondary,
              size: AppSizes.iconL.w,
            ),
          ),
        ],
      ),
    );
  }
}
