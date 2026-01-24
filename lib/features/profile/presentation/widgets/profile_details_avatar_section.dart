import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/models.dart';
import '../theme/profile_theme.dart';

class ProfileDetailsAvatarSection extends StatelessWidget {
  final UserProfile profile;

  const ProfileDetailsAvatarSection({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Column(
        children: [
          // Avatar
          Stack(
            children: [
              Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  image: profile.avatarUrl != null
                      ? DecorationImage(
                          image: NetworkImage(profile.avatarUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: profile.avatarUrl == null
                    ? Center(
                        child: Text(
                          profile.initials,
                          style: AppTextStyles.h2.copyWith(
                            color: colors.primary,
                          ),
                        ),
                      )
                    : null,
              ),
              // Camera badge
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      colors.cardShadow,
                    ],
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: colors.textOnPrimary,
                    size: 20.w,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Username and Role
          Text(
            profile.fullName,
            style: AppTextStyles.h3.copyWith(color: colors.textPrimary),
          ),
          SizedBox(height: 4.h),
          Text(
            profile.role,
            style: AppTextStyles.bodyMedium.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
