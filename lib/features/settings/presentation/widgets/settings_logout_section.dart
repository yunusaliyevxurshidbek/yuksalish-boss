import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../injection_container.dart';
import '../../../../presentation/widgets/custom_snacbar.dart';
import '../../../../features/auth/presentation/bloc/logout/logout_cubit.dart';
import '../../../../features/auth/presentation/bloc/logout/logout_state.dart';
import 'settings_tile.dart';

/// Logout section for settings screen.
class SettingsLogoutSection extends StatelessWidget {
  const SettingsLogoutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSizes.p16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
      ),
      child: SettingsTile.destructive(
        icon: Icons.logout_rounded,
        title: 'settings_logout_title'.tr(),
        onTap: () => _showLogoutDialog(context),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'settings_logout_title'.tr(),
          style: AppTextStyles.h4.copyWith(color: AppColors.textPrimary),
        ),
        content: Text(
          'settings_logout_confirm'.tr(),
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => dialogContext.pop(),
            child: Text(
              'common_cancel'.tr(),
              style: AppTextStyles.button.copyWith(color: AppColors.textSecondary),
            ),
          ),
          BlocProvider(
            create: (_) => getIt<LogoutCubit>(),
            child: BlocConsumer<LogoutCubit, LogoutState>(
              listener: (context, state) {
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
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: state is LogoutLoading
                      ? null
                      : () => context.read<LogoutCubit>().logout(),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                  child: state is LogoutLoading
                      ? SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          'settings_logout_title'.tr(),
                          style: AppTextStyles.button.copyWith(color: Colors.white),
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
