import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:yuksalish_mobile/core/constants/app_icons.dart';
import 'package:yuksalish_mobile/core/constants/app_sizes.dart';
import 'package:yuksalish_mobile/core/constants/app_text_styles.dart';
import 'package:yuksalish_mobile/core/constants/app_colors.dart';
import 'package:yuksalish_mobile/core/widgets/widgets.dart';

class DashboardHeader extends StatelessWidget {
  final String userName;
  final String? avatarUrl;
  final int notificationCount;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const DashboardHeader({
    super.key,
    this.userName = 'Direktor',
    this.avatarUrl,
    this.notificationCount = 0,
    this.onNotificationTap,
    this.onProfileTap,
  });

  String get _currentDate {
    final now = DateTime.now();
    final formatter = DateFormat("d MMMM, EEEE", 'uz_UZ');
    try {
      return formatter.format(now);
    } catch (_) {
      // Fallback if uz_UZ locale not available
      return DateFormat("d MMMM, EEEE").format(now);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.p16.w,
        vertical: AppSizes.p12.h,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'dashboard_title'.tr(),
                  style: AppTextStyles.h3.copyWith(
                    color: theme.textTheme.headlineSmall?.color,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  _currentDate,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          ),
          _NotificationButton(
            count: notificationCount,
            onTap: onNotificationTap,
          ),
          SizedBox(width: AppSizes.p12.w),
          _ProfileAvatar(
            avatarUrl: avatarUrl,
            onTap: onProfileTap,
          ),
        ],
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  final int count;
  final VoidCallback? onTap;

  const _NotificationButton({
    required this.count,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.border,
            width: AppSizes.borderThin,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            SvgPicture.string(
              AppIcons.notification,
              width: AppSizes.iconL.w,
              height: AppSizes.iconL.w,
              colorFilter: ColorFilter.mode(
                theme.iconTheme.color ?? AppColors.textPrimary,
                BlendMode.srcIn,
              ),
            ),
            if (count > 0)
              Positioned(
                top: -4.w,
                right: -4.w,
                child: CountBadge(
                  count: count,
                  backgroundColor: theme.colorScheme.primary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final String? avatarUrl;
  final VoidCallback? onTap;

  const _ProfileAvatar({
    this.avatarUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
          border: Border.all(
            color: primaryColor.withValues(alpha: 0.3),
            width: AppSizes.borderThin,
          ),
          image: avatarUrl != null
              ? DecorationImage(
                  image: NetworkImage(avatarUrl!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: avatarUrl == null
            ? Center(
                child: SvgPicture.string(
                  AppIcons.user,
                  width: AppSizes.iconL.w,
                  height: AppSizes.iconL.w,
                  colorFilter: ColorFilter.mode(
                    primaryColor,
                    BlendMode.srcIn,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
