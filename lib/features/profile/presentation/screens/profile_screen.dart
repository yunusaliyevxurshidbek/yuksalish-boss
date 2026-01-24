import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../injection_container.dart';
import '../bloc/profile_cubit.dart';
import '../bloc/profile_state.dart';
import '../theme/profile_theme.dart';
import '../widgets/profile_cards/profile_cards.dart';
import '../widgets/profile_dialogs.dart';
import '../widgets/profile_header_card.dart';

/// Main profile screen with user info, stats, and settings.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Load profile when screen opens
    getIt<ProfileCubit>().loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<ProfileCubit>(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.isDark ? colors.surface : colors.primary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_rounded,
            color: colors.isDark ? colors.textPrimary : colors.textOnPrimary,
            size: AppSizes.iconL.w,
          ),
        ),
        title: Text(
          'profile_title'.tr(),
          style: AppTextStyles.h3.copyWith(
            color: colors.isDark ? colors.textPrimary : colors.textOnPrimary,
          ),
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.isLoading && state.profile == null) {
            return Center(
              child: CircularProgressIndicator(
                color: colors.primary,
              ),
            );
          }

          if (state.hasError && state.profile == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'common_error'.tr(),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  SizedBox(height: AppSizes.p16.h),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProfileCubit>().loadProfile();
                    },
                    child: Text('common_retry'.tr()),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<ProfileCubit>().refresh();
            },
            color: colors.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    SizedBox(height: 16.h),

                    // Profile Header Card
                    if (state.profile != null)
                      ProfileHeaderCard(
                        profile: state.profile!,
                        onAvatarTap: () => ProfileDialogs.showImagePicker(context),
                        onEditTap: () => context.push('/profile/edit'),
                      ),

                    SizedBox(height: 16.h),

                    // Card 1: Main Activity
                    const MainActivityCard(),

                    SizedBox(height: 16.h),

                    // Card 3: Security
                    const SecurityCard(),

                    SizedBox(height: 16.h),

                    // Card 4: App Settings & Support
                    const SettingsSupportCard(),

                    SizedBox(height: 16.h),

                    // Card 5: Logout
                    const LogoutCard(),

                    SizedBox(height: 24.h),

                    // Version Info
                    Text(
                      'profile_version'.tr(
                        namedArgs: {
                          'version': '1.0.0',
                          'build': '24',
                        },
                      ),
                      style: AppTextStyles.caption.copyWith(
                        color: colors.textTertiary,
                      ),
                    ),

                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
