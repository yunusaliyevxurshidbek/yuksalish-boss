import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../bloc/profile_cubit.dart';
import '../theme/profile_theme.dart';

/// Dialogs for device management.
class DevicesDialogs {
  DevicesDialogs._();

  /// Shows dialog to confirm removing a single device.
  static void showRemoveDialog(BuildContext context, String deviceId) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final colors = ProfileThemeColors.of(dialogContext);
        return AlertDialog(
          backgroundColor: colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusL),
          ),
          title: Text(
            'profile_devices_remove_title'.tr(),
            style: AppTextStyles.h4.copyWith(color: colors.textPrimary),
          ),
          content: Text(
            'profile_devices_remove_message'.tr(),
            style: AppTextStyles.bodyMedium.copyWith(color: colors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => dialogContext.pop(),
              child: Text(
                'common_cancel'.tr(),
                style: AppTextStyles.labelMedium.copyWith(color: colors.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                dialogContext.pop();
                context.read<ProfileCubit>().removeDevice(deviceId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.error,
                foregroundColor: colors.textOnPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusS),
                ),
              ),
              child: Text(
                'common_delete'.tr(),
                style: AppTextStyles.labelMedium.copyWith(color: colors.textOnPrimary),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Shows dialog to confirm removing all devices.
  static void showRemoveAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final colors = ProfileThemeColors.of(dialogContext);
        return AlertDialog(
          backgroundColor: colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusL),
          ),
          title: Text(
            'profile_devices_remove_all_title'.tr(),
            style: AppTextStyles.h4.copyWith(color: colors.textPrimary),
          ),
          content: Text(
            'profile_devices_remove_all_message'.tr(),
            style: AppTextStyles.bodyMedium.copyWith(color: colors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => dialogContext.pop(),
              child: Text(
                'common_cancel'.tr(),
                style: AppTextStyles.labelMedium.copyWith(color: colors.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                dialogContext.pop();
                context.read<ProfileCubit>().removeAllDevices();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.error,
                foregroundColor: colors.textOnPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusS),
                ),
              ),
              child: Text(
                'profile_devices_remove_all_action'.tr(),
                style: AppTextStyles.labelMedium.copyWith(color: colors.textOnPrimary),
              ),
            ),
          ],
        );
      },
    );
  }
}
