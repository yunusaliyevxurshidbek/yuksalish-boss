import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/widgets.dart';

/// Header widget for project detail screen.
class ProjectDetailHeader extends StatelessWidget {
  final String name;
  final String location;
  final String status;
  final int totalUnits;
  final int soldUnits;
  final int availableUnits;

  const ProjectDetailHeader({
    super.key,
    required this.name,
    required this.location,
    this.status = 'Faol',
    required this.totalUnits,
    required this.soldUnits,
    required this.availableUnits,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSizes.p16.w),
      padding: EdgeInsets.all(AppSizes.p20.w),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: AppTextStyles.h3.copyWith(color: AppColors.textOnPrimary),
                ),
              ),
              StatusBadge(
                text: status,
                type: BadgeType.success,
                backgroundColor: AppColors.success.withAlpha(51),
                textColor: AppColors.textOnPrimary,
              ),
            ],
          ),
          SizedBox(height: AppSizes.p8.h),
          Row(
            children: [
              SvgPicture.string(
                AppIcons.mapPin,
                width: 14.w,
                colorFilter: ColorFilter.mode(
                  AppColors.textOnPrimary.withAlpha(179),
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                location,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textOnPrimary.withAlpha(179),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.p16.h),
          Row(
            children: [
              _HeaderStat(label: 'projects_units_total'.tr(), value: '$totalUnits ta'),
              SizedBox(width: AppSizes.p24.w),
              _HeaderStat(label: 'projects_units_sold'.tr(), value: '$soldUnits ta'),
              SizedBox(width: AppSizes.p24.w),
              _HeaderStat(label: 'projects_units_empty'.tr(), value: '$availableUnits ta'),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderStat extends StatelessWidget {
  final String label;
  final String value;

  const _HeaderStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textOnPrimary.withAlpha(153),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: AppTextStyles.labelLarge.copyWith(color: AppColors.textOnPrimary),
        ),
      ],
    );
  }
}
