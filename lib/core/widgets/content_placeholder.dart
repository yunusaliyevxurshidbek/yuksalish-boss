import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_sizes.dart';
import '../constants/app_colors.dart';

/// Placeholder type enumeration.
enum PlaceholderType {
  listItem,
  card,
  text,
}

/// Placeholder widget for loading states with skeleton content.
class ContentPlaceholder extends StatelessWidget {
  /// Number of placeholder items to show.
  final int itemCount;

  /// Type of placeholder.
  final PlaceholderType type;

  const ContentPlaceholder({
    super.key,
    this.itemCount = 3,
    this.type = PlaceholderType.listItem,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final shimmerColor = isDark ? AppColors.darkBorder : AppColors.border;
    final cardColor = theme.cardColor;

    return Column(
      children: List.generate(
        itemCount,
        (index) => _buildPlaceholderItem(shimmerColor, cardColor),
      ),
    );
  }

  Widget _buildPlaceholderItem(Color shimmerColor, Color cardColor) {
    switch (type) {
      case PlaceholderType.listItem:
        return _ListItemPlaceholder(shimmerColor: shimmerColor);
      case PlaceholderType.card:
        return _CardPlaceholder(shimmerColor: shimmerColor, cardColor: cardColor);
      case PlaceholderType.text:
        return _TextPlaceholder(shimmerColor: shimmerColor);
    }
  }
}

class _ListItemPlaceholder extends StatelessWidget {
  final Color shimmerColor;

  const _ListItemPlaceholder({required this.shimmerColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.p16.w,
        vertical: AppSizes.p12.h,
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: shimmerColor,
              borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
            ),
          ),
          SizedBox(width: AppSizes.p12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 150.w,
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: shimmerColor,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  width: 100.w,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: shimmerColor,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardPlaceholder extends StatelessWidget {
  final Color shimmerColor;
  final Color cardColor;

  const _CardPlaceholder({
    required this.shimmerColor,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSizes.p16.w,
        vertical: AppSizes.p8.h,
      ),
      padding: EdgeInsets.all(AppSizes.p16.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 20.h,
            decoration: BoxDecoration(
              color: shimmerColor,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          SizedBox(height: AppSizes.p12.h),
          Container(
            width: 200.w,
            height: 14.h,
            decoration: BoxDecoration(
              color: shimmerColor,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          SizedBox(height: AppSizes.p8.h),
          Container(
            width: 150.w,
            height: 14.h,
            decoration: BoxDecoration(
              color: shimmerColor,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ],
      ),
    );
  }
}

class _TextPlaceholder extends StatelessWidget {
  final Color shimmerColor;

  const _TextPlaceholder({required this.shimmerColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.p16.w,
        vertical: AppSizes.p4.h,
      ),
      child: Container(
        width: double.infinity,
        height: 14.h,
        decoration: BoxDecoration(
          color: shimmerColor,
          borderRadius: BorderRadius.circular(4.r),
        ),
      ),
    );
  }
}
