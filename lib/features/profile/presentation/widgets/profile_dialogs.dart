import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../injection_container.dart';
import '../../../../presentation/widgets/custom_snacbar.dart';
import '../../../auth/presentation/bloc/logout/logout_cubit.dart';
import '../../../auth/presentation/bloc/logout/logout_state.dart';
import '../bloc/profile_cubit.dart';
import '../theme/profile_theme.dart';

/// Collection of dialogs used in the profile screen.
abstract class ProfileDialogs {
  /// Shows bottom sheet for picking profile image.
  static void showImagePicker(BuildContext context) {
    final colors = ProfileThemeColors.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusXL.r),
        ),
      ),
      builder: (sheetContext) {
        final sheetColors = ProfileThemeColors.of(sheetContext);

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: AppSizes.p8.h),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: sheetColors.divider,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: AppSizes.p16.h),
              Text(
                'profile_image_picker_title'.tr(),
                style: AppTextStyles.h4.copyWith(
                  color: sheetColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.p16.h),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(AppSizes.p8.w),
                  decoration: BoxDecoration(
                    color: sheetColors.tintIconBackground(sheetColors.primary),
                    borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
                  ),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: sheetColors.primary,
                  ),
                ),
                title: Text(
                  'profile_image_picker_camera'.tr(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: sheetColors.textPrimary,
                  ),
                ),
                onTap: () {
                  sheetContext.pop();
                  // TODO: Open camera
                },
              ),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(AppSizes.p8.w),
                  decoration: BoxDecoration(
                    color: sheetColors.tintIconBackground(sheetColors.primary),
                    borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
                  ),
                  child: Icon(
                    Icons.photo_library_outlined,
                    color: sheetColors.primary,
                  ),
                ),
                title: Text(
                  'profile_image_picker_gallery'.tr(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: sheetColors.textPrimary,
                  ),
                ),
                onTap: () {
                  sheetContext.pop();
                  // TODO: Open gallery
                },
              ),
              SizedBox(height: AppSizes.p16.h),
            ],
          ),
        );
      },
    );
  }

  /// Shows logout confirmation dialog.
  static void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final colors = ProfileThemeColors.of(dialogContext);

        return Dialog(
          backgroundColor: colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon at top
                Container(
                  width: 64.w,
                  height: 64.w,
                  decoration: BoxDecoration(
                    color: colors.tintIconBackground(colors.primary),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    color: colors.primary,
                    size: 32.w,
                  ),
                ),
                SizedBox(height: 20.h),

                // Title
                Text(
                  'profile_logout_title'.tr(),
                  style: AppTextStyles.h4.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),

                // Subtitle
                Text(
                  'profile_logout_message'.tr(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: colors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),

                // Primary button - Chiqish
                BlocProvider(
                  create: (_) => getIt<LogoutCubit>(),
                  child: BlocConsumer<LogoutCubit, LogoutState>(
                    listener: (blocContext, state) {
                      if (state is LogoutSuccess) {
                        dialogContext.pop();
                        context.go('/login_page');
                      } else if (state is LogoutError) {
                        CustomSnacbar.show(
                          context,
                          text: state.message,
                          isError: true,
                        );
                      }
                    },
                    builder: (blocContext, state) {
                      return SizedBox(
                        width: double.infinity,
                        height: 48.h,
                        child: ElevatedButton(
                          onPressed: state is LogoutLoading
                              ? null
                              : () => blocContext.read<LogoutCubit>().logout(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.primary,
                            foregroundColor: colors.textOnPrimary,
                            disabledBackgroundColor:
                                colors.primary.withValues(alpha: 0.6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 0,
                          ),
                          child: state is LogoutLoading
                              ? SizedBox(
                                  width: 20.w,
                                  height: 20.w,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      colors.textOnPrimary,
                                    ),
                                  ),
                                )
                              : Text(
                                  'common_logout'.tr(),
                                  style: AppTextStyles.labelLarge.copyWith(
                                    color: colors.textOnPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 12.h),

                // Secondary button - Bekor qilish
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: TextButton(
                    onPressed: () => dialogContext.pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: colors.textSecondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'common_cancel'.tr(),
                      style: AppTextStyles.labelLarge.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Shows clear cache confirmation dialog.
  static void showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final colors = ProfileThemeColors.of(dialogContext);

        return Dialog(
          backgroundColor: colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon at top
                Container(
                  width: 64.w,
                  height: 64.w,
                  decoration: BoxDecoration(
                    color: colors.tintIconBackground(colors.primary),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.cleaning_services_outlined,
                    color: colors.primary,
                    size: 32.w,
                  ),
                ),
                SizedBox(height: 20.h),

                // Title
                Text(
                  'profile_clear_cache_title'.tr(),
                  style: AppTextStyles.h4.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),

                // Subtitle
                Text(
                  'profile_clear_cache_message'.tr(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: colors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),

                // Primary button - Tozalash
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: () {
                      dialogContext.pop();
                      context.read<ProfileCubit>().clearCache();
                      CustomSnacbar.show(
                        context,
                        text: 'profile_cache_cleared'.tr(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: colors.textOnPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'common_clear'.tr(),
                      style: AppTextStyles.labelLarge.copyWith(
                        color: colors.textOnPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),

                // Secondary button - Bekor qilish
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: TextButton(
                    onPressed: () => dialogContext.pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: colors.textSecondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'common_cancel'.tr(),
                      style: AppTextStyles.labelLarge.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
