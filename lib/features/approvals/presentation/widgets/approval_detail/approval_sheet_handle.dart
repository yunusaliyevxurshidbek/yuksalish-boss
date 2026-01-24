import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_colors.dart';

/// Handle widget for the bottom sheet.
class ApprovalSheetHandle extends StatelessWidget {
  const ApprovalSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: AppSizes.p12.h),
      width: 40.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull.r),
      ),
    );
  }
}
