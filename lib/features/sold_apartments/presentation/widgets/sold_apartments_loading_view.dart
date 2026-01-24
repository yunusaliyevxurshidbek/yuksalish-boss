import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_shimmer.dart';

class SoldApartmentsLoadingView extends StatelessWidget {
  const SoldApartmentsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSizes.p16.w),
      child: Column(
        children: [
          AppShimmer(
            child: ShimmerPlaceholder.card(
              height: 160.h,
              borderRadius: AppSizes.radiusL.r,
            ),
          ),
          SizedBox(height: AppSizes.p20.h),
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
          SizedBox(height: AppSizes.p12.h),
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
          SizedBox(height: AppSizes.p24.h),
          AppShimmer(
            child: ShimmerPlaceholder.card(
              height: 200.h,
              borderRadius: AppSizes.radiusM.r,
            ),
          ),
        ],
      ),
    );
  }
}
