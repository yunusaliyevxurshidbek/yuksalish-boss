import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../injection_container.dart';
import '../../../../features/app_lock/presentation/bloc/app_lock/app_lock_bloc.dart';
import '../../../../features/app_lock/presentation/bloc/app_lock/app_lock_event.dart';
import '../../../../features/app_lock/presentation/bloc/app_lock/app_lock_state.dart';
import 'settings_tile.dart';

/// Security section for settings screen.
class SettingsSecuritySection extends StatelessWidget {
  const SettingsSecuritySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSizes.p16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
      ),
      child: BlocBuilder<AppLockBloc, AppLockState>(
        bloc: getIt<AppLockBloc>(),
        builder: (context, state) {
          return Column(
            children: [
              SettingsTile.navigation(
                icon: Icons.pin_outlined,
                title: 'settings_change_pin'.tr(),
                onTap: () {
                  // TODO: Navigate to PIN change screen
                },
              ),
              SettingsTile.toggle(
                icon: Icons.fingerprint_outlined,
                title: 'settings_biometric_login'.tr(),
                value: state.isBiometricEnabled,
                onChanged: (value) {
                  getIt<AppLockBloc>().add(AppLockToggleBiometric(value));
                },
              ),
              SettingsTile.navigation(
                icon: Icons.timer_outlined,
                title: 'settings_session_timeout'.tr(),
                value: '15 daq',
                onTap: () {
                  // TODO: Show session timeout picker
                },
                showDivider: false,
              ),
            ],
          );
        },
      ),
    );
  }
}
