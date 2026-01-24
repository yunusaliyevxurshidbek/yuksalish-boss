import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/user_profile.dart';
import '../theme/profile_theme.dart';
import 'profile_avatar.dart';

class ProfileHeaderCard extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onEditTap;

  const ProfileHeaderCard({
    super.key,
    required this.profile,
    this.onAvatarTap,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.p24.w),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          // Avatar
          ProfileAvatar(
            imageUrl: profile.avatarUrl,
            initials: profile.initials,
            size: 80,
          ),

          SizedBox(height: AppSizes.p16.h),

          // Full Name
          Text(
            profile.fullName,
            style: AppTextStyles.h3.copyWith(
              color: colors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 4.h),

          // Position
          Text(
            profile.role,
            style: AppTextStyles.bodyMedium.copyWith(
              color: colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 4.h),

          // Phone number
          Text(
            profile.phone,
            style: AppTextStyles.bodySmall.copyWith(
              color: colors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),

          if (onEditTap != null) ...[
            SizedBox(height: AppSizes.p20.h),
            _buildEditButton(context),
          ],
        ],
      ),
    );
  }

  Widget _buildEditButton(BuildContext context) {
    final colors = ProfileThemeColors.of(context);

    return GestureDetector(
      onTap: onEditTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 32.w,
          vertical: 12.h,
        ),
        decoration: BoxDecoration(
          color: colors.primary,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.edit_rounded,
              size: AppSizes.iconS.w,
              color: colors.textOnPrimary,
            ),
            SizedBox(width: 8.w),
            Text(
              'common_edit'.tr(),
              style: AppTextStyles.labelMedium.copyWith(
                color: colors.textOnPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
