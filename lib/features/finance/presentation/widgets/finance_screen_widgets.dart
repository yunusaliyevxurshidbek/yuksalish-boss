import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/widgets.dart';
import '../bloc/finance_bloc.dart';

class FinanceTabBar extends StatelessWidget {
  final TabController tabController;

  const FinanceTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBorder : theme.colorScheme.surface;
    final borderColor = theme.dividerColor;
    final unselectedColor = theme.colorScheme.onSurface.withValues(
      alpha: isDark ? 0.7 : 0.6,
    );

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSizes.p16.w,
        vertical: AppSizes.p8.h,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull.r),
        border: isDark ? null : Border.all(color: borderColor),
      ),
      child: TabBar(
        controller: tabController,
        indicator: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(AppSizes.radiusFull.r),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: theme.colorScheme.onPrimary,
        unselectedLabelColor: unselectedColor,
        labelStyle: AppTextStyles.labelMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextStyles.labelMedium,
        labelPadding: EdgeInsets.zero,
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.payments_rounded, size: AppSizes.iconS.w),
                SizedBox(width: AppSizes.p8.w),
                Text('finance_tab_payments'.tr()),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.warning_amber_rounded, size: AppSizes.iconS.w),
                SizedBox(width: AppSizes.p8.w),
                Text('finance_tab_debts'.tr()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FinanceLoadingState extends StatelessWidget {
  const FinanceLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final shimmerColor = isDark ? AppColors.darkBorder : AppColors.grey100;

    return Padding(
      padding: EdgeInsets.all(AppSizes.p16.w),
      child: Column(
        children: [
          // Horizontal KPI cards shimmer
          SizedBox(
            height: 120.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              separatorBuilder: (_, __) => SizedBox(width: AppSizes.p12.w),
              itemBuilder: (_, __) => AppShimmer(
                child: Container(
                  width: 160.w,
                  decoration: BoxDecoration(
                    color: shimmerColor,
                    borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: AppSizes.p24.h),
          // Search bar shimmer
          AppShimmer(
            child: Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: shimmerColor,
                borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
              ),
            ),
          ),
          SizedBox(height: AppSizes.p24.h),
          // Chart shimmer
          AppShimmer(
            child: Container(
              height: 200.h,
              decoration: BoxDecoration(
                color: shimmerColor,
                borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
              ),
            ),
          ),
          SizedBox(height: AppSizes.p24.h),
          // List items shimmer
          ...List.generate(
            3,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: AppSizes.p12.h),
              child: AppShimmer(
                child: Container(
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: shimmerColor,
                    borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FinanceErrorState extends StatelessWidget {
  final String? errorMessage;

  const FinanceErrorState({super.key, this.errorMessage});

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
              Icons.error_outline_rounded,
              size: AppSizes.iconXXL.w,
              color: AppColors.error,
            ),
            SizedBox(height: AppSizes.p16.h),
            Text(
              'finance_loading_error'.tr(),
              style: AppTextStyles.h4.copyWith(
                color: theme.textTheme.titleMedium?.color,
              ),
            ),
            SizedBox(height: AppSizes.p8.h),
            Text(
              errorMessage ?? 'finance_retry'.tr(),
              style: AppTextStyles.bodyMedium.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSizes.p24.h),
            ElevatedButton(
              onPressed: () {
                context.read<FinanceBloc>().add(const LoadFinanceData());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.p24.w,
                  vertical: AppSizes.p12.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
                ),
              ),
              child: Text(
                'Qayta yuklash',
                style: AppTextStyles.button,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
