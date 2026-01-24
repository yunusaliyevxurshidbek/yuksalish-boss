import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/widgets.dart';
import '../bloc/finance_bloc.dart';

class AllPaymentsLoadingState extends StatelessWidget {
  const AllPaymentsLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final shimmerColor = isDark ? AppColors.darkBorder : AppColors.grey100;

    return Padding(
      padding: EdgeInsets.all(AppSizes.p16.w),
      child: Column(
        children: List.generate(
          5,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: AppSizes.p12.h),
            child: AppShimmer(
              child: Container(
                height: 120.h,
                decoration: BoxDecoration(
                  color: shimmerColor,
                  borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AllPaymentsErrorState extends StatelessWidget {
  final String? errorMessage;

  const AllPaymentsErrorState({super.key, this.errorMessage});

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
                'finance_reload_button'.tr(),
                style: AppTextStyles.button,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AllPaymentsEmptyState extends StatelessWidget {
  const AllPaymentsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.p32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_rounded,
              size: 64.w,
              color: theme.textTheme.bodySmall?.color,
            ),
            SizedBox(height: AppSizes.p16.h),
            Text(
              'finance_no_payments'.tr(),
              style: AppTextStyles.h4.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
            SizedBox(height: AppSizes.p8.h),
            Text(
              'finance_search_empty_message'.tr(),
              style: AppTextStyles.bodyMedium.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
