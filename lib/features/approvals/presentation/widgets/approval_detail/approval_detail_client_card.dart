import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/widgets.dart';

/// Client info card for approval detail screen.
class ApprovalDetailClientCard extends StatelessWidget {
  final String name;
  final String phone;
  final String initials;
  final VoidCallback? onCall;

  const ApprovalDetailClientCard({
    super.key,
    required this.name,
    required this.phone,
    required this.initials,
    this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'approvals_client_info'.tr()),
        SizedBox(height: AppSizes.p12.h),
        Container(
          margin: EdgeInsets.symmetric(horizontal: AppSizes.p16.w),
          padding: EdgeInsets.all(AppSizes.p16.w),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
          ),
          child: Row(
            children: [
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withAlpha(26),
                  borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: AppTextStyles.h4.copyWith(color: AppColors.primary),
                  ),
                ),
              ),
              SizedBox(width: AppSizes.p16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppTextStyles.labelLarge),
                    SizedBox(height: 4.h),
                    Text(phone, style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              IconButton(
                onPressed: onCall,
                icon: Icon(
                  Icons.phone_outlined,
                  color: AppColors.primary,
                  size: AppSizes.iconL.w,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
