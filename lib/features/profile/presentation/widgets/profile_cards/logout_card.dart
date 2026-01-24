import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../widgets/profile_dialogs.dart';
import '../profile_menu_tile.dart';
import '../../theme/profile_theme.dart';

/// Card containing logout button.
class LogoutCard extends StatelessWidget {
  const LogoutCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: ProfileMenuTile.destructive(
        icon: Icons.logout_rounded,
        title: 'profile_menu_logout'.tr(),
        onTap: () => ProfileDialogs.showLogoutDialog(context),
      ),
    );
  }
}
