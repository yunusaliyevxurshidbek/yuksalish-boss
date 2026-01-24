import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/extensions/number_extensions.dart';
import '../../../../../core/widgets/widgets.dart';

/// Header card for approval detail screen.
class ApprovalDetailHeader extends StatelessWidget {
  final String approvalId;
  final String title;
  final double amount;

  const ApprovalDetailHeader({
    super.key,
    required this.approvalId,
    required this.title,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSizes.p16.w),
      padding: EdgeInsets.all(AppSizes.p20.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: AppColors.warningLight,
                  borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
                ),
                child: Icon(
                  Icons.payments_outlined,
                  color: AppColors.warning,
                  size: AppSizes.iconL.w,
                ),
              ),
              SizedBox(width: AppSizes.p16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.h4),
                    SizedBox(height: 4.h),
                    Text('approvals_request_number'.tr(args: [approvalId]), style: AppTextStyles.caption),
                  ],
                ),
              ),
              StatusBadge.warning('approvals_status_pending'.tr()),
            ],
          ),
          SizedBox(height: AppSizes.p20.h),
          Container(
            padding: EdgeInsets.all(AppSizes.p16.w),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withAlpha(26),
              borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  amount.currency,
                  style: AppTextStyles.h2.copyWith(color: AppColors.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
