import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:yuksalish_mobile/core/constants/app_colors.dart';
import 'package:yuksalish_mobile/core/services/my_shared_preferences.dart';
import 'package:yuksalish_mobile/features/app_lock/presentation/bloc/app_lock/app_lock_bloc.dart';
import 'package:yuksalish_mobile/features/app_lock/presentation/bloc/app_lock/app_lock_event.dart';
import 'package:yuksalish_mobile/injection_container.dart';

class RegistrationPendingPage extends StatelessWidget {
  const RegistrationPendingPage({super.key});

  Future<void> _onLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return AlertDialog(
          title: Text(
            'profile_logout_title'.tr(),
            style: GoogleFonts.urbanist(
              fontWeight: FontWeight.w700,
              fontSize: 18.sp,
            ),
          ),
          content: Text(
            'profile_logout_message'.tr(),
            style: GoogleFonts.urbanist(fontSize: 14.sp),
          ),
          actions: [
            TextButton(
              onPressed: () => ctx.pop(false),
              child: Text(
                'common_cancel'.tr(),
                style: GoogleFonts.urbanist(
                  color: theme.textTheme.bodySmall?.color,
                ),
              ),
            ),
            TextButton(
              onPressed: () => ctx.pop(true),
              child: Text(
                'common_logout'.tr(),
                style: GoogleFonts.urbanist(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true && context.mounted) {
      getIt<AppLockBloc>().add(const AppLockReset());
      await MySharedPreferences.clearUserData();
      if (context.mounted) {
        context.go('/login_page');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Icon container
              Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkPrimary.withValues(alpha: 0.12)
                      : AppColors.primaryNavy.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.hourglass_top_rounded,
                    size: 56.sp,
                    color: isDark ? AppColors.darkPrimary : AppColors.primaryNavy,
                  ),
                ),
              ),

              SizedBox(height: 40.h),

              // Title
              Text(
                'registration_pending_title'.tr(),
                style: GoogleFonts.urbanist(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w700,
                  color: theme.textTheme.titleLarge?.color,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 16.h),

              // Message
              Text(
                'registration_pending_message'.tr(),
                style: GoogleFonts.urbanist(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                  color: theme.textTheme.bodySmall?.color,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 32.h),

              // Status badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 10.h,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkWarningLight.withValues(alpha: 0.3)
                      : AppColors.warningLight,
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 18.sp,
                      color: isDark
                          ? AppColors.darkWarning
                          : AppColors.warning,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'registration_pending_status'.tr(),
                      style: GoogleFonts.urbanist(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkWarning
                            : AppColors.warning,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 3),

              // Logout button
              GestureDetector(
                onTap: () => _onLogout(context),
                child: Text(
                  'registration_pending_logout'.tr(),
                  style: GoogleFonts.urbanist(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.error,
                  ),
                ),
              ),

              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}
