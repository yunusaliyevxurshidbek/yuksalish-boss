import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_sizes.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_colors.dart';
import 'filter_chip_item.dart';

/// Filter chip group with icons.
class FilterChipGroupWithIcons extends StatelessWidget {
  /// List of filter items with labels and icons.
  final List<FilterChipItem> items;

  /// Currently selected index.
  final int selectedIndex;

  /// Callback when a chip is selected.
  final ValueChanged<int> onSelected;

  /// Horizontal padding around the group.
  final double horizontalPadding;

  const FilterChipGroupWithIcons({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    this.horizontalPadding = 16,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding.w),
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final item = items[index];
          final isSelected = index == selectedIndex;
          return _IconFilterChip(
            item: item,
            isSelected: isSelected,
            onTap: () => onSelected(index),
          );
        },
      ),
    );
  }
}

class _IconFilterChip extends StatelessWidget {
  final FilterChipItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _IconFilterChip({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.p12.w,
          vertical: AppSizes.p8.h,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusFull.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.icon != null) ...[
              Icon(
                item.icon,
                size: AppSizes.iconS.w,
                color: isSelected
                    ? AppColors.textOnPrimary
                    : AppColors.textSecondary,
              ),
              SizedBox(width: 6.w),
            ],
            Text(
              item.label,
              style: AppTextStyles.labelMedium.copyWith(
                color: isSelected
                    ? AppColors.textOnPrimary
                    : AppColors.textSecondary,
              ),
            ),
            if (item.count != null) ...[
              SizedBox(width: 6.w),
              _CountBadge(count: item.count!, isSelected: isSelected),
            ],
          ],
        ),
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  final int count;
  final bool isSelected;

  const _CountBadge({required this.count, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.textOnPrimary.withAlpha(51)
            : AppColors.primary.withAlpha(26),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull.r),
      ),
      child: Text(
        count.toString(),
        style: AppTextStyles.caption.copyWith(
          color: isSelected ? AppColors.textOnPrimary : AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
