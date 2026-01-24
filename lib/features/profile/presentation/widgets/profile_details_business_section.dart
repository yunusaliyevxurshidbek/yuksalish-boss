import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/models.dart';
import '../theme/profile_theme.dart';

class ProfileDetailsBusinessSection extends StatelessWidget {
  final UserProfile profile;

  const ProfileDetailsBusinessSection({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Text(
          'profile_business_section_title'.tr(),
          style: AppTextStyles.bodyMedium.copyWith(
            color: colors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 12.h),

        // Business Info Card
        Container(
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [colors.cardShadow],
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Company
                ProfileReadOnlyField(
                  label: 'profile_business_company_label'.tr(),
                  value: profile.company?.name ?? 'common_unknown'.tr(),
                ),
                SizedBox(height: 16.h),

                // Internal Number
                ProfileReadOnlyField(
                  label: 'profile_business_internal_number_label'.tr(),
                  value: '101',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ProfileReadOnlyField extends StatelessWidget {
  final String label;
  final String value;

  const ProfileReadOnlyField({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: colors.surfaceElevated,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: colors.border),
          ),
          child: Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: colors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
