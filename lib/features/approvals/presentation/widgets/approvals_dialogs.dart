import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../presentation/widgets/custom_snacbar.dart';
import '../bloc/approvals_cubit.dart';

/// Dialogs for approval actions.
abstract class ApprovalsDialogs {
  /// Show approve confirmation dialog.
  static void showApproveDialog(BuildContext context, String id) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimaryColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondaryColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final successColor = isDark ? AppColors.darkSuccess : AppColors.success;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.surface;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: surfaceColor,
        title: Text(
          'approvals_approve_dialog_title'.tr(),
          style: AppTextStyles.h4.copyWith(
            color: textPrimaryColor,
          ),
        ),
        content: Text(
          'approvals_approve_dialog_message'.tr(),
          style: AppTextStyles.bodyMedium.copyWith(
            color: textSecondaryColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => dialogContext.pop(),
            child: Text(
              'common_cancel'.tr(),
              style: AppTextStyles.button.copyWith(
                color: textSecondaryColor,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              dialogContext.pop();
              context.read<ApprovalsCubit>().approve(id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: successColor,
            ),
            child: Text(
              'approvals_approve_confirm'.tr(),
              style: AppTextStyles.button.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Show reject dialog with comment input.
  static void showRejectDialog(BuildContext context, String id) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final errorColor = isDark ? AppColors.darkError : AppColors.error;
    final textSecondaryColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final textTertiaryColor = isDark ? AppColors.darkTextTertiary : AppColors.textTertiary;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.surface;

    final commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: surfaceColor,
        title: Text(
          'approvals_reject_dialog_title'.tr(),
          style: AppTextStyles.h4.copyWith(
            color: errorColor,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'approvals_reject_dialog_message'.tr(),
              style: AppTextStyles.bodySmall.copyWith(
                color: textSecondaryColor,
              ),
            ),
            SizedBox(height: AppSizes.p12.h),
            TextField(
              controller: commentController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'approvals_reject_reason_hint'.tr(),
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: textTertiaryColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => dialogContext.pop(),
            child: Text(
              'common_cancel'.tr(),
              style: AppTextStyles.button.copyWith(
                color: textSecondaryColor,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final reason = commentController.text.trim();
              if (reason.isEmpty) {
                CustomSnacbar.show(
                  dialogContext,
                  text: 'approvals_reject_reason_required'.tr(),
                  isError: true,
                );
                return;
              }
              dialogContext.pop();
              context.read<ApprovalsCubit>().reject(id, reason);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: errorColor,
            ),
            child: Text(
              'approvals_reject_confirm'.tr(),
              style: AppTextStyles.button.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Show action result snackbar.
  static void showActionSnackBar(BuildContext context, ApprovalsState state) {
    final isApproved = state.lastAction == ApprovalAction.approved;
    CustomSnacbar.show(
      context,
      text: isApproved ? 'approvals_approved_message'.tr() : 'approvals_rejected_message'.tr(),
      isError: !isApproved,
    );
  }
}
