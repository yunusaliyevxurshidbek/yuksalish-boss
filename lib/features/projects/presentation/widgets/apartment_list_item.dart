import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/number_extensions.dart';
import '../../data/models/apartment.dart';
import 'apartment_detail_sheet.dart';
import 'apartment_status_utils.dart';

/// List item widget for displaying apartment information.
class ApartmentListItem extends StatelessWidget {
  final Apartment apartment;
  final VoidCallback? onTap;

  const ApartmentListItem({
    super.key,
    required this.apartment,
    this.onTap,
  });

  Color get _statusColor => ApartmentStatusUtils.getStatusColor(apartment.status);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return GestureDetector(
      onTap: onTap ?? () => _showApartmentDetails(context),
      child: Container(
        padding: EdgeInsets.all(AppSizes.p16.w),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            _ApartmentNumberBadge(apartment: apartment, statusColor: _statusColor),
            SizedBox(width: AppSizes.p12.w),
            Expanded(child: _ApartmentInfo(apartment: apartment)),
            ApartmentStatusUtils.buildStatusBadge(apartment.status),
          ],
        ),
      ),
    );
  }

  void _showApartmentDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ApartmentDetailSheet(apartment: apartment),
    );
  }
}

class _ApartmentNumberBadge extends StatelessWidget {
  final Apartment apartment;
  final Color statusColor;

  const _ApartmentNumberBadge({required this.apartment, required this.statusColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56.w,
      height: 56.w,
      decoration: BoxDecoration(
        color: statusColor.withAlpha(26),
        borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '#${apartment.apartmentNumber}',
            style: AppTextStyles.labelLarge.copyWith(
              color: statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            apartment.block,
            style: AppTextStyles.caption.copyWith(color: statusColor),
          ),
        ],
      ),
    );
  }
}

class _ApartmentInfo extends StatelessWidget {
  final Apartment apartment;

  const _ApartmentInfo({required this.apartment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dividerColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              apartment.roomsText,
              style: AppTextStyles.labelMedium.copyWith(
                color: theme.textTheme.titleMedium?.color,
              ),
            ),
            SizedBox(width: AppSizes.p8.w),
            _Dot(color: theme.textTheme.bodySmall?.color ?? dividerColor),
            SizedBox(width: AppSizes.p8.w),
            Text(
              '${apartment.area.toStringAsFixed(1)} m²',
              style: AppTextStyles.labelMedium.copyWith(
                color: theme.textTheme.titleMedium?.color,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Text(
              'Qavat: ${apartment.floor}',
              style: AppTextStyles.caption.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
            SizedBox(width: AppSizes.p8.w),
            _Dot(color: dividerColor),
            SizedBox(width: AppSizes.p8.w),
            Text(
              apartment.price.currencyShort,
              style: AppTextStyles.labelMedium.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;

  const _Dot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4.w,
      height: 4.w,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
