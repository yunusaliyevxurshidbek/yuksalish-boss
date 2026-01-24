import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/approvals_cubit.dart';

/// App bar for approvals screen with pending count badge.
class ApprovalsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ApprovalsAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;

    return AppBar(
      title: BlocBuilder<ApprovalsCubit, ApprovalsState>(
        builder: (context, state) {
          return Row(
            children: [
              Text(
                'approvals_title'.tr(),
                style: AppTextStyles.h3.copyWith(
                  color: textColor,
                ),
              ),
              if (state.pendingCount > 0) ...[
                SizedBox(width: AppSizes.p8.w),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.p8.w,
                    vertical: AppSizes.p4.h,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkError : AppColors.error,
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull.r),
                  ),
                  child: Text(
                    '${state.pendingCount}',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
      backgroundColor: backgroundColor,
      surfaceTintColor: backgroundColor,
      elevation: 0,
      centerTitle: false,
    );
  }
}

/// Pending count indicator row.
class ApprovalsPendingCount extends StatelessWidget {
  final int count;

  const ApprovalsPendingCount({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tertiaryColor = isDark ? AppColors.darkTextTertiary : AppColors.textTertiary;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.p16.w),
      child: Row(
        children: [
          Icon(
            Icons.hourglass_empty_rounded,
            size: AppSizes.iconS.w,
            color: tertiaryColor,
          ),
          SizedBox(width: AppSizes.p8.w),
          Text(
            '$count ta kutmoqda',
            style: AppTextStyles.bodySmall.copyWith(
              color: tertiaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
