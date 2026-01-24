import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/analytics_bloc.dart';

/// Custom segmented tab bar for analytics screen
class AnalyticsTabBar extends StatelessWidget {
  const AnalyticsTabBar({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  final AnalyticsTab selectedTab;
  final ValueChanged<AnalyticsTab> onTabChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSizes.p16.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
      ),
      child: Row(
        children: AnalyticsTab.values.map((tab) {
          final isSelected = tab == selectedTab;
          return Expanded(
            child: _TabItem(
              label: _getTabLabel(tab),
              isSelected: isSelected,
              onTap: () => onTabChanged(tab),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getTabLabel(AnalyticsTab tab) {
    return switch (tab) {
      AnalyticsTab.sales => 'analytics_tab_sales'.tr(),
      AnalyticsTab.finance => 'analytics_tab_finance'.tr(),
      AnalyticsTab.leads => 'analytics_tab_leads'.tr(),
    };
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          vertical: 10.h,
          horizontal: 16.w,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.textPrimary.withValues(alpha: 0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.labelMedium.copyWith(
            color: isSelected
                ? AppColors.primary
                : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
