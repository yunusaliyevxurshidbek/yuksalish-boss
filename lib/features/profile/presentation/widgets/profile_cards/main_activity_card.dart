import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../profile_menu_tile.dart';
import '../../theme/profile_theme.dart';

/// Card containing profile, company, and devices navigation items.
class MainActivityCard extends StatelessWidget {
  const MainActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);

    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          ProfileMenuTile.navigation(
            icon: Icons.person_outline_rounded,
            iconColor: ProfileMenuColors.blueIcon,
            iconBackgroundColor: colors.menuIconBackground(
              ProfileMenuColors.blue,
              ProfileMenuColors.blueIcon,
            ),
            title: 'profile_menu_profile_details'.tr(),
            onTap: () => context.push('/profile/edit'),
          ),
          ProfileMenuTile.navigation(
            icon: Icons.devices_outlined,
            iconColor: ProfileMenuColors.navyIcon,
            iconBackgroundColor: colors.menuIconBackground(
              ProfileMenuColors.navy,
              ProfileMenuColors.navyIcon,
            ),
            title: 'profile_menu_devices'.tr(),
            onTap: () => context.push('/profile/devices'),
            showDivider: false,
          ),
        ],
      ),
    );
  }
}
