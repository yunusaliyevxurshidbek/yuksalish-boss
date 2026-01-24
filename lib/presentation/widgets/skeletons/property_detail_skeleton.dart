import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'property_detail/property_detail.dart';
import 'shimmer_wrapper.dart';

/// Skeleton loader for property detail screen.
class PropertyDetailSkeleton extends StatelessWidget {
  const PropertyDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PropertyDetailHeaderSkeleton(),
          _ContentSkeleton(),
        ],
      ),
    );
  }
}

class _ContentSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.scaffoldBackgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: ShimmerWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StatusBadgeSkeleton(),
            SizedBox(height: 12.h),
            const TitleSkeleton(),
            SizedBox(height: 8.h),
            const BuilderLinkSkeleton(),
            SizedBox(height: 12.h),
            const LocationSkeleton(),
            SizedBox(height: 16.h),
            const PriceSectionSkeleton(),
            SizedBox(height: 16.h),
            const StatsSectionSkeleton(),
            SizedBox(height: 24.h),
            const AboutSectionSkeleton(),
            SizedBox(height: 24.h),
            const PaymentTermsSectionSkeleton(),
            SizedBox(height: 24.h),
            const DividerSkeleton(),
            SizedBox(height: 24.h),
            const BlocsSectionSkeleton(),
            SizedBox(height: 24.h),
            const AmenitiesSectionSkeleton(),
            SizedBox(height: 24.h),
            const LocationMapSkeleton(),
            SizedBox(height: 60.h),
          ],
        ),
      ),
    );
  }
}
