import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/repositories/projects_repository.dart';
import '../bloc/projects_state.dart';

class ProjectsFilterChips extends StatelessWidget {
  final ProjectsState state;
  final ValueChanged<ProjectFilter> onFilterChanged;

  const ProjectsFilterChips({
    super.key,
    required this.state,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          _FilterChip(
            label: 'projects_filter_all'.tr(),
            count: state.activeCount + state.completedCount + state.plannedCount,
            isSelected: state.currentFilter == ProjectFilter.all,
            onTap: () => onFilterChanged(ProjectFilter.all),
          ),
          SizedBox(width: 8.w),
          _FilterChip(
            label: 'projects_filter_active'.tr(),
            count: state.activeCount,
            isSelected: state.currentFilter == ProjectFilter.active,
            onTap: () => onFilterChanged(ProjectFilter.active),
          ),
          SizedBox(width: 8.w),
          _FilterChip(
            label: 'projects_filter_completed'.tr(),
            count: state.completedCount,
            isSelected: state.currentFilter == ProjectFilter.completed,
            onTap: () => onFilterChanged(ProjectFilter.completed),
          ),
          SizedBox(width: 8.w),
          _FilterChip(
            label: 'projects_filter_plan'.tr(),
            count: state.plannedCount,
            isSelected: state.currentFilter == ProjectFilter.planned,
            onTap: () => onFilterChanged(ProjectFilter.planned),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : theme.cardColor,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : borderColor,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : theme.textTheme.titleMedium?.color,
              ),
            ),
            SizedBox(width: 4.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withAlpha(50)
                    : theme.colorScheme.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                '$count',
                style: GoogleFonts.inter(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
