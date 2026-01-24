import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/lead_model.dart';

class LeadDetailsContactCard extends StatelessWidget {
  final Lead lead;

  const LeadDetailsContactCard({super.key, required this.lead});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(AppSizes.p16.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
          width: AppSizes.borderThin,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'leads_contact_info'.tr(),
            style: AppTextStyles.labelLarge.copyWith(
              color: theme.textTheme.titleMedium?.color,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSizes.p16.h),
          if (lead.phone != null && lead.phone!.isNotEmpty)
            LeadDetailRow(
              icon: Icons.phone_outlined,
              label: 'leads_phone'.tr(),
              value: lead.phone!,
            ),
          if (lead.email != null && lead.email!.isNotEmpty)
            LeadDetailRow(
              icon: Icons.email_outlined,
              label: 'leads_email'.tr(),
              value: lead.email!,
            ),
          if (lead.propertyInterest != null && lead.propertyInterest!.isNotEmpty)
            LeadDetailRow(
              icon: Icons.home_outlined,
              label: 'leads_property_interest'.tr(),
              value: lead.propertyInterest!,
            ),
        ],
      ),
    );
  }
}

class LeadDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const LeadDetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.p12.h),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceElevated : AppColors.background,
              borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
            ),
            child: Icon(
              icon,
              size: 18.w,
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          SizedBox(width: AppSizes.p12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LeadDetailsNotesCard extends StatelessWidget {
  final String notes;

  const LeadDetailsNotesCard({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.p16.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
          width: AppSizes.borderThin,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.note_outlined,
                size: 20.w,
                color: theme.textTheme.bodySmall?.color,
              ),
              SizedBox(width: AppSizes.p8.w),
              Text(
                'Izohlar',
                style: AppTextStyles.labelLarge.copyWith(
                  color: theme.textTheme.titleMedium?.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.p12.h),
          Text(
            notes,
            style: AppTextStyles.bodyMedium.copyWith(
              color: theme.textTheme.bodyMedium?.color,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class LeadDetailsTagsCard extends StatelessWidget {
  final List<String> tags;

  const LeadDetailsTagsCard({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.p16.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
          width: AppSizes.borderThin,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.label_outlined,
                size: 20.w,
                color: theme.textTheme.bodySmall?.color,
              ),
              SizedBox(width: AppSizes.p8.w),
              Text(
                'Teglar',
                style: AppTextStyles.labelLarge.copyWith(
                  color: theme.textTheme.titleMedium?.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.p12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: tags.map((tag) => LeadTagChip(tag: tag)).toList(),
          ),
        ],
      ),
    );
  }
}

class LeadTagChip extends StatelessWidget {
  final String tag;

  const LeadTagChip({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 6.h,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
      ),
      child: Text(
        tag,
        style: AppTextStyles.labelSmall.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class LeadDetailsLinkedCard extends StatelessWidget {
  final Lead lead;

  const LeadDetailsLinkedCard({super.key, required this.lead});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.p16.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
          width: AppSizes.borderThin,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.link_outlined,
                size: 20.w,
                color: theme.textTheme.bodySmall?.color,
              ),
              SizedBox(width: AppSizes.p8.w),
              Text(
                'leads_connected_info'.tr(),
                style: AppTextStyles.labelLarge.copyWith(
                  color: theme.textTheme.titleMedium?.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.p12.h),
          if (lead.clientName != null) ...[
            LeadLinkedItem(
              icon: Icons.person_outline,
              label: 'leads_client'.tr(),
              value: lead.clientName!,
            ),
            SizedBox(height: AppSizes.p8.h),
          ],
          if (lead.mchjName != null)
            LeadLinkedItem(
              icon: Icons.business_outlined,
              label: 'leads_llc'.tr(),
              value: lead.mchjName!,
            ),
        ],
      ),
    );
  }
}

class LeadLinkedItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const LeadLinkedItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          icon,
          size: 18.w,
          color: theme.textTheme.bodySmall?.color,
        ),
        SizedBox(width: AppSizes.p8.w),
        Text(
          '$label: ',
          style: AppTextStyles.bodySmall.copyWith(
            color: theme.textTheme.bodySmall?.color,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: theme.textTheme.bodyLarge?.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class LeadDetailsTimestampsCard extends StatelessWidget {
  final Lead lead;

  const LeadDetailsTimestampsCard({super.key, required this.lead});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.p16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceElevated : AppColors.background,
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
        border: Border.all(
          color: (isDark ? AppColors.darkBorder : AppColors.border).withValues(alpha: 0.5),
          width: AppSizes.borderThin,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: LeadTimestampItem(
              label: 'leads_created'.tr(),
              date: lead.createdAt,
            ),
          ),
          Container(
            width: 1,
            height: 40.h,
            color: theme.dividerColor,
          ),
          Expanded(
            child: LeadTimestampItem(
              label: 'leads_updated'.tr(),
              date: lead.updatedAt,
            ),
          ),
        ],
      ),
    );
  }
}

class LeadTimestampItem extends StatelessWidget {
  final String label;
  final DateTime date;

  const LeadTimestampItem({
    super.key,
    required this.label,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: theme.textTheme.bodySmall?.color,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          _formatDateTime(date),
          style: AppTextStyles.bodySmall.copyWith(
            color: theme.textTheme.bodyMedium?.color,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _formatDateTime(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day.$month.$year\n$hour:$minute';
  }
}
