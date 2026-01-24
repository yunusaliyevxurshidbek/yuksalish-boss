import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../bloc/profile_cubit.dart';
import '../../bloc/profile_state.dart';
import '../profile_menu_tile.dart';
import '../../theme/profile_theme.dart';

/// Card containing notification toggle settings.
class NotificationsCard extends StatelessWidget {
  const NotificationsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final cubit = context.read<ProfileCubit>();
        final settings = state.settings;

        return Container(
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            children: [
              ProfileMenuTile.toggle(
                icon: Icons.notifications_outlined,
                iconColor: ProfileMenuColors.orangeIcon,
                iconBackgroundColor: colors.menuIconBackground(
                  ProfileMenuColors.orange,
                  ProfileMenuColors.orangeIcon,
                ),
                title: 'profile_notifications_push'.tr(),
                value: settings.pushNotifications,
                onChanged: cubit.togglePushNotifications,
              ),
              ProfileMenuTile.toggle(
                icon: Icons.email_outlined,
                iconColor: ProfileMenuColors.tealIcon,
                iconBackgroundColor: colors.menuIconBackground(
                  ProfileMenuColors.teal,
                  ProfileMenuColors.tealIcon,
                ),
                title: 'profile_notifications_email'.tr(),
                value: settings.emailNotifications,
                onChanged: cubit.toggleEmailNotifications,
              ),
              ProfileMenuTile.toggle(
                icon: Icons.volume_up_outlined,
                iconColor: ProfileMenuColors.greenIcon,
                iconBackgroundColor: colors.menuIconBackground(
                  ProfileMenuColors.green,
                  ProfileMenuColors.greenIcon,
                ),
                title: 'profile_notifications_sound'.tr(),
                value: settings.soundEnabled,
                onChanged: cubit.toggleSound,
              ),
              ProfileMenuTile.toggle(
                icon: Icons.vibration_outlined,
                iconColor: ProfileMenuColors.pinkIcon,
                iconBackgroundColor: colors.menuIconBackground(
                  ProfileMenuColors.pink,
                  ProfileMenuColors.pinkIcon,
                ),
                title: 'profile_notifications_vibration'.tr(),
                value: settings.vibrationEnabled,
                onChanged: cubit.toggleVibration,
                showDivider: false,
              ),
            ],
          ),
        );
      },
    );
  }
}
