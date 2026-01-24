import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/extensions/number_extensions.dart';
import '../../data/models/apartment_model.dart';

class SoldApartmentsRecentList extends StatelessWidget {
  final List<Apartment> apartments;
  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;

  const SoldApartmentsRecentList({
    super.key,
    required this.apartments,
    required this.hasMore,
    required this.isLoadingMore,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (apartments.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'sold_apartments_recent'.tr(),
          style: AppTextStyles.h4.copyWith(
            color: theme.textTheme.titleLarge?.color,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppSizes.p12.h),
        ...apartments.map((apartment) => SoldApartmentCard(apartment: apartment)),
        if (hasMore) ...[
          SizedBox(height: AppSizes.p12.h),
          Center(
            child: isLoadingMore
                ? CircularProgressIndicator(color: theme.colorScheme.primary)
                : TextButton(
                    onPressed: onLoadMore,
                    child: Text(
                      'sold_apartments_show_more'.tr(),
                      style: AppTextStyles.labelMedium.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
          ),
        ],
      ],
    );
  }
}

class SoldApartmentCard extends StatelessWidget {
  final Apartment apartment;

  const SoldApartmentCard({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.p12.h),
      padding: EdgeInsets.all(AppSizes.p16.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
            ),
            child: Center(
              child: Text(
                '${apartment.rooms}',
                style: AppTextStyles.h3.copyWith(
                  color: const Color(0xFF6366F1),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: AppSizes.p12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  apartment.projectName,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: theme.textTheme.bodyMedium?.color,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  'sold_apartments_block_floor'.tr(args: [
                    apartment.block,
                    '${apartment.floor}',
                    apartment.area.toStringAsFixed(1),
                  ]),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                apartment.price.currencyShort,
                style: AppTextStyles.labelMedium.copyWith(
                  color: theme.textTheme.titleMedium?.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4.h),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 2.h,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  'sold_apartments_sold'.tr(),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: const Color(0xFF6366F1),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
