import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';

/// Period selector tabs for sales dynamics.
class PeriodSelector extends StatelessWidget {
  final List<String> periods;
  final int selectedIndex;
  final ValueChanged<int>? onSelected;

  const PeriodSelector({
    super.key,
    required this.periods,
    required this.selectedIndex,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.salesTabInactive,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: List.generate(periods.length, (index) {
          final isActive = index == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: onSelected == null ? null : () => onSelected!(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 10.h),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.salesPrimary
                      : AppColors.salesTabInactive,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  periods[index],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: isActive
                        ? AppColors.salesCard
                        : AppColors.salesTextSecondary,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
