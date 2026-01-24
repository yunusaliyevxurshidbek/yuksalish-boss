import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_shimmer.dart';

class RevenueDetailsLoadingView extends StatelessWidget {
  const RevenueDetailsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSizes.p16.w),
      child: Column(
        children: [
          AppShimmer(
            child: ShimmerPlaceholder.card(
              height: 140.h,
              borderRadius: AppSizes.radiusL.r,
            ),
          ),
          SizedBox(height: AppSizes.p16.h),
          Row(
            children: [
              Expanded(
                child: AppShimmer(
                  child: ShimmerPlaceholder.card(
                    height: 100.h,
                    borderRadius: AppSizes.radiusM.r,
                  ),
                ),
              ),
              SizedBox(width: AppSizes.p12.w),
              Expanded(
                child: AppShimmer(
                  child: ShimmerPlaceholder.card(
                    height: 100.h,
                    borderRadius: AppSizes.radiusM.r,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.p16.h),
          AppShimmer(
            child: ShimmerPlaceholder.card(
              height: 250.h,
              borderRadius: AppSizes.radiusL.r,
            ),
          ),
          SizedBox(height: AppSizes.p16.h),
          AppShimmer(
            child: ShimmerPlaceholder.card(
              height: 200.h,
              borderRadius: AppSizes.radiusL.r,
            ),
          ),
        ],
      ),
    );
  }
}

class RevenueDetailsErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const RevenueDetailsErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.p24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.w,
              color: theme.colorScheme.error,
            ),
            SizedBox(height: AppSizes.p16.h),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: theme.textTheme.bodyMedium?.color,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSizes.p24.h),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
                ),
              ),
              child: Text('common_retry'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
