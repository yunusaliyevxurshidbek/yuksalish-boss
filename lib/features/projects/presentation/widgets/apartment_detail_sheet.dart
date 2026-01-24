import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/number_extensions.dart';
import '../../data/models/apartment.dart';
import 'apartment_status_utils.dart';

/// Bottom sheet showing apartment details.
class ApartmentDetailSheet extends StatelessWidget {
  final Apartment apartment;

  const ApartmentDetailSheet({super.key, required this.apartment});

  Color get _statusColor => ApartmentStatusUtils.getStatusColor(apartment.status);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusXL.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _HandleBar(borderColor: borderColor),
          Padding(
            padding: EdgeInsets.all(AppSizes.p20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ApartmentHeader(apartment: apartment, statusColor: _statusColor),
                SizedBox(height: AppSizes.p24.h),
                _DetailGrid(apartment: apartment),
                SizedBox(height: AppSizes.p24.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      padding: EdgeInsets.symmetric(vertical: AppSizes.p12.h),
                    ),
                    child: Text('common_close'.tr()),
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

class _HandleBar extends StatelessWidget {
  final Color borderColor;

  const _HandleBar({required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: AppSizes.p12.h),
      width: 40.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: borderColor,
        borderRadius: BorderRadius.circular(2.r),
      ),
    );
  }
}

class _ApartmentHeader extends StatelessWidget {
  final Apartment apartment;
  final Color statusColor;

  const _ApartmentHeader({required this.apartment, required this.statusColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 64.w,
          height: 64.w,
          decoration: BoxDecoration(
            color: statusColor.withAlpha(26),
            borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '#${apartment.apartmentNumber}',
                style: AppTextStyles.h4.copyWith(color: statusColor),
              ),
              Text(
                '${'apartment_sheet_block_label'.tr()} ${apartment.block}',
                style: AppTextStyles.caption.copyWith(color: statusColor),
              ),
            ],
          ),
        ),
        SizedBox(width: AppSizes.p16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'apartment_sheet_title'.tr(args: ['${apartment.rooms}']),
                style: AppTextStyles.h4.copyWith(
                  color: theme.textTheme.titleLarge?.color,
                ),
              ),
              SizedBox(height: 4.h),
              ApartmentStatusUtils.buildStatusBadge(apartment.status),
            ],
          ),
        ),
        SizedBox(width: AppSizes.p16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'apartment_sheet_title'.tr(args: ['${apartment.rooms}']),
                style: AppTextStyles.h4.copyWith(
                  color: theme.textTheme.titleLarge?.color,
                ),
              ),
              SizedBox(height: 4.h),
              ApartmentStatusUtils.buildStatusBadge(apartment.status),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailGrid extends StatelessWidget {
  final Apartment apartment;

  const _DetailGrid({required this.apartment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.p16.w),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _DetailItem(label: 'apartment_sheet_area_label'.tr(), value: '${apartment.area.toStringAsFixed(1)} m²')),
              Expanded(child: _DetailItem(label: 'apartment_sheet_floor_label'.tr(), value: '${apartment.floor}-qavat')),
            ],
          ),
          SizedBox(height: AppSizes.p12.h),
          Row(
            children: [
              Expanded(child: _DetailItem(label: 'apartment_sheet_rooms_label'.tr(), value: '${apartment.rooms} ta')),
              Expanded(child: _DetailItem(label: 'apartment_sheet_block_label'.tr(), value: apartment.block)),
            ],
          ),
          SizedBox(height: AppSizes.p12.h),
          _DetailItem(label: 'apartment_sheet_price_label'.tr(), value: apartment.price.currencyShort, isHighlighted: true),
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlighted;

  const _DetailItem({
    required this.label,
    required this.value,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
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
          style: isHighlighted
              ? AppTextStyles.h4.copyWith(color: theme.colorScheme.primary)
              : AppTextStyles.labelMedium.copyWith(
                  color: theme.textTheme.titleMedium?.color,
                ),
        ),
      ],
    );
  }
}
