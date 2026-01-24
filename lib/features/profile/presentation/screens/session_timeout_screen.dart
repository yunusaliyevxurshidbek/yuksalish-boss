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

/// Screen for selecting session timeout duration.
class SessionTimeoutScreen extends StatelessWidget {
  const SessionTimeoutScreen({super.key});

  static const List<_TimeoutOption> _options = [
    _TimeoutOption(minutes: 5, labelKey: 'profile_session_timeout_5m'),
    _TimeoutOption(minutes: 10, labelKey: 'profile_session_timeout_10m'),
    _TimeoutOption(
      minutes: 15,
      labelKey: 'profile_session_timeout_15m',
      isRecommended: true,
    ),
    _TimeoutOption(minutes: 30, labelKey: 'profile_session_timeout_30m'),
    _TimeoutOption(minutes: 60, labelKey: 'profile_session_timeout_60m'),
    _TimeoutOption(
      minutes: 0,
      labelKey: 'profile_session_timeout_disable',
      isWarning: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return BlocProvider.value(
      value: getIt<ProfileCubit>(),
      child: Scaffold(
        backgroundColor: colors.background,
        appBar: AppBar(
          backgroundColor: colors.surface,
          elevation: 0,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: Icon(
              Icons.arrow_back_rounded,
              color: colors.textPrimary,
              size: AppSizes.iconL.w,
            ),
          ),
          title: Text(
            'profile_session_timeout_title'.tr(),
            style: AppTextStyles.h3.copyWith(
              color: colors.textPrimary,
            ),
          ),
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            final currentTimeout = state.settings.sessionTimeoutMinutes;

            return SingleChildScrollView(
              padding: EdgeInsets.all(AppSizes.p16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  Container(
                    padding: EdgeInsets.all(AppSizes.p16.w),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          color: colors.primary,
                          size: AppSizes.iconL.w,
                        ),
                        SizedBox(width: AppSizes.p12.w),
                        Expanded(
                          child: Text(
                            'profile_session_timeout_description'.tr(),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppSizes.p24.h),

                  // Options
                  Container(
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
                    ),
                    child: Column(
                      children: _options.asMap().entries.map((entry) {
                        final index = entry.key;
                        final option = entry.value;
                        final isSelected = currentTimeout == option.minutes;
                        final isLast = index == _options.length - 1;

                        return Column(
                          children: [
                            _TimeoutOptionTile(
                              option: option,
                              isSelected: isSelected,
                              onTap: () {
                                context
                                    .read<ProfileCubit>()
                                    .setSessionTimeout(option.minutes);
                              },
                            ),
                            if (!isLast)
                              Divider(
                                height: 1,
                                indent: AppSizes.p16.w,
                                endIndent: AppSizes.p16.w,
                                color: colors.divider,
                              ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(height: AppSizes.p24.h),

                  // Warning Note
                  Container(
                    padding: EdgeInsets.all(AppSizes.p16.w),
                    decoration: BoxDecoration(
                      color: colors.warningLight,
                      borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
                      border: Border.all(
                        color: colors.warning.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: colors.warning,
                          size: AppSizes.iconM.w,
                        ),
                        SizedBox(width: AppSizes.p12.w),
                        Expanded(
                          child: Text(
                            'profile_session_timeout_warning'.tr(),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: colors.warning,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TimeoutOption {
  final int minutes;
  final String labelKey;
  final bool isRecommended;
  final bool isWarning;

  const _TimeoutOption({
    required this.minutes,
    required this.labelKey,
    this.isRecommended = false,
    this.isWarning = false,
  });
}

class _TimeoutOptionTile extends StatelessWidget {
  final _TimeoutOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _TimeoutOptionTile({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.p16.w,
          vertical: AppSizes.p12.h,
        ),
        child: Row(
          children: [
            // Radio
            Container(
              width: 24.w,
              height: 24.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? colors.primary
                        : colors.textTertiary,
                    width: 2,
                  ),
                ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.primary,
                        ),
                      ),
                    )
                  : null,
            ),

            SizedBox(width: AppSizes.p12.w),

            // Label
            Expanded(
              child: Text(
                option.labelKey.tr(),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: option.isWarning
                      ? colors.warning
                      : colors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),

            // Badges
            if (option.isRecommended)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  color: colors.successLight,
                  borderRadius: BorderRadius.circular(AppSizes.radiusFull.r),
                ),
                child: Text(
                  'profile_session_timeout_badge_recommended'.tr(),
                  style: AppTextStyles.caption.copyWith(
                    color: colors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

            if (option.isWarning)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  color: colors.warningLight,
                  borderRadius: BorderRadius.circular(AppSizes.radiusFull.r),
                ),
                child: Text(
                  'profile_session_timeout_badge_not_recommended'.tr(),
                  style: AppTextStyles.caption.copyWith(
                    color: colors.warning,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
