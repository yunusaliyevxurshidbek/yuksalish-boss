import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_sizes.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_colors.dart';

/// Toggle filter group (like segmented control).
class ToggleFilterGroup extends StatelessWidget {
  /// List of filter labels.
  final List<String> items;

  /// Currently selected index.
  final int selectedIndex;

  /// Callback when selection changes.
  final ValueChanged<int> onSelected;

  /// Background color.
  final Color? backgroundColor;

  const ToggleFilterGroup({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.divider,
        borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
      ),
      child: Row(
        children: List.generate(
          items.length,
          (index) => Expanded(
            child: _ToggleItem(
              label: items[index],
              isSelected: index == selectedIndex,
              onTap: () => onSelected(index),
            ),
          ),
        ),
      ),
    );
  }
}

class _ToggleItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: AppSizes.p8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withAlpha(13),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(
              color: isSelected
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
