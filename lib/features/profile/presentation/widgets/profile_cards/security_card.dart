import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../injection_container.dart';
import '../../../../../features/app_lock/presentation/bloc/app_lock/app_lock_bloc.dart';
import '../../../../../features/app_lock/presentation/bloc/app_lock/app_lock_event.dart';
import '../../../../../features/app_lock/presentation/bloc/app_lock/app_lock_state.dart';
import '../profile_menu_tile.dart';
import '../../theme/profile_theme.dart';

/// Card containing security settings (PIN, biometric).
class SecurityCard extends StatelessWidget {
  const SecurityCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);

    return BlocBuilder<AppLockBloc, AppLockState>(
      bloc: getIt<AppLockBloc>(),
      builder: (context, appLockState) {
        return Container(
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            children: [
              ProfileMenuTile.navigation(
                icon: Icons.pin_outlined,
                iconColor: ProfileMenuColors.navyIcon,
                iconBackgroundColor: colors.menuIconBackground(
                  ProfileMenuColors.navy,
                  ProfileMenuColors.navyIcon,
                ),
                title: 'profile_menu_change_pin'.tr(),
                onTap: () {
                  getIt<AppLockBloc>().add(const AppLockStartChange());
                  context.push('/profile/pin-change');
                },
                showDivider: appLockState.isBiometricAvailable,
              ),
              if (appLockState.isBiometricAvailable)
                ProfileMenuTile.toggle(
                  icon: Icons.fingerprint_outlined,
                  iconColor: ProfileMenuColors.purpleIcon,
                  iconBackgroundColor: colors.menuIconBackground(
                    ProfileMenuColors.purple,
                    ProfileMenuColors.purpleIcon,
                  ),
                  title: 'profile_menu_biometric'.tr(),
                  value: appLockState.isBiometricEnabled,
                  onChanged: (value) {
                    getIt<AppLockBloc>().add(AppLockToggleBiometric(value));
                  },
                  showDivider: false,
                ),
            ],
          ),
        );
      },
    );
  }
}
