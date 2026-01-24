import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../bloc/approvals_cubit.dart';

/// Loading state with shimmer skeletons.
class ApprovalsLoadingState extends StatelessWidget {
  const ApprovalsLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final shimmerColor = isDark ? AppColors.darkBorder : AppColors.grey100;

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(AppSizes.p16.w),
      itemCount: 4,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(bottom: AppSizes.p12.h),
        child: AppShimmer(
          child: Container(
            height: 200.h,
            decoration: BoxDecoration(
              color: shimmerColor,
              borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
            ),
          ),
        ),
      ),
    );
  }
}

/// Error state with retry button.
class ApprovalsErrorState extends StatelessWidget {
  final String? errorMessage;

  const ApprovalsErrorState({super.key, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final errorColor = isDark ? AppColors.darkError : AppColors.error;
    final textPrimaryColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondaryColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.primary;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(AppSizes.p24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: AppSizes.iconXXL.w,
                      color: errorColor,
                    ),
                    SizedBox(height: AppSizes.p16.h),
                    Text(
                      "Ma'lumotlarni yuklashda xatolik",
                      style: AppTextStyles.h4.copyWith(
                        color: textPrimaryColor,
                      ),
                    ),
                    SizedBox(height: AppSizes.p8.h),
                    Text(
                      errorMessage ?? 'approvals_loading_error_retry'.tr(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: textSecondaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppSizes.p24.h),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ApprovalsCubit>().loadApprovals();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: AppColors.textOnPrimary,
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.p24.w,
                          vertical: AppSizes.p12.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
                        ),
                      ),
                      child: Text(
                        'approvals_reload'.tr(),
                        style: AppTextStyles.button,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Empty state when no approvals are pending.
class ApprovalsEmptyState extends StatelessWidget {
  const ApprovalsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final successColor = isDark ? AppColors.darkSuccess : AppColors.success;
    final textPrimaryColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondaryColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(AppSizes.p40.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      size: AppSizes.iconXXL.w * 1.5,
                      color: successColor,
                    ),
                    SizedBox(height: AppSizes.p24.h),
                    Text(
                      "Barcha so'rovlar ko'rib chiqilgan",
                      style: AppTextStyles.h4.copyWith(
                        color: textPrimaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppSizes.p8.h),
                    Text(
                      'approvals_no_pending_subtitle'.tr(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: textSecondaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
