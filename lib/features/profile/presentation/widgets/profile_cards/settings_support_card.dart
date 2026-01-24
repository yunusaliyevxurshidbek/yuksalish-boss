import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../bloc/profile_cubit.dart';
import '../../bloc/profile_state.dart';
import '../../widgets/profile_dialogs.dart';
import '../profile_menu_tile.dart';
import '../../theme/profile_theme.dart';

/// Card containing app settings and support navigation items.
class SettingsSupportCard extends StatelessWidget {
  const SettingsSupportCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final profileCubit = context.read<ProfileCubit>();
        final themeCubit = context.read<ThemeCubit>();
        final languageLabel = _languageLabel(context.locale.languageCode);

        return Container(
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            children: [
              ProfileMenuTile.navigation(
                icon: Icons.language_outlined,
                iconColor: ProfileMenuColors.blueIcon,
                iconBackgroundColor: colors.menuIconBackground(
                  ProfileMenuColors.blue,
                  ProfileMenuColors.blueIcon,
                ),
                title: 'profile_menu_language'.tr(),
                value: languageLabel,
                onTap: () => context.push('/profile/language'),
              ),
              BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, themeState) {
                  return ProfileMenuTile.toggle(
                    icon: Icons.dark_mode_outlined,
                    iconColor: ProfileMenuColors.navyIcon,
                    iconBackgroundColor: colors.menuIconBackground(
                      ProfileMenuColors.navy,
                      ProfileMenuColors.navyIcon,
                    ),
                    title: 'profile_menu_dark_mode'.tr(),
                    value: themeState.isDark,
                    onChanged: (enabled) {
                      // Update both theme cubit and profile settings
                      themeCubit.setDarkMode(enabled);
                      profileCubit.toggleDarkMode(enabled);
                    },
                  );
                },
              ),
              ProfileMenuTile.navigation(
                icon: Icons.delete_outline_rounded,
                iconColor: ProfileMenuColors.greyIcon,
                iconBackgroundColor: colors.menuIconBackground(
                  ProfileMenuColors.grey,
                  ProfileMenuColors.greyIcon,
                ),
                title: 'profile_menu_clear_cache'.tr(),
                value: state.formattedCacheSize,
                onTap: () => ProfileDialogs.showClearCacheDialog(context),
                showDivider: false,
              ),
            ],
          ),
        );
      },
    );
  }

  String _languageLabel(String code) {
    switch (code) {
      case 'uz_latin':
      case 'uz':
        return 'language_uz'.tr();
      case 'ru':
        return 'language_ru'.tr();
      case 'en':
        return 'language_en'.tr();
      default:
        return 'language_uz'.tr();
    }
  }
}
