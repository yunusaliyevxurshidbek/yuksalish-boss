import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../theme/profile_theme.dart';

/// Info row widget for displaying label-value pairs with icon.
class AboutInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLink;
  final VoidCallback? onTap;

  const AboutInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.isLink = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return GestureDetector(
      onTap: isLink ? onTap : null,
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: colors.tintIconBackground(colors.primary),
              borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
            ),
            child: Icon(
              icon,
              color: colors.primary,
              size: AppSizes.iconM.w,
            ),
          ),
          SizedBox(width: AppSizes.p12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(color: colors.textTertiary),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isLink ? colors.primary : colors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (isLink)
            Icon(
              Icons.open_in_new_rounded,
              color: colors.textTertiary,
              size: AppSizes.iconS.w,
            ),
        ],
      ),
    );
  }
}
