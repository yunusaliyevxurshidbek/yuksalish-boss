import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/extensions/number_extensions.dart';
import '../bloc/sold_apartments_state.dart';

class SoldApartmentsMainCard extends StatelessWidget {
  final SoldApartmentsStats stats;

  const SoldApartmentsMainCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final isPositive = stats.apartmentsTrend >= 0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.p20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'sold_apartments_total'.tr(),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${stats.soldCount}',
                    style: AppTextStyles.h1.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 36.sp,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.p12.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive
                          ? Icons.trending_up_rounded
                          : Icons.trending_down_rounded,
                      color: Colors.white,
                      size: 16.w,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${isPositive ? '+' : ''}${stats.apartmentsTrend.toStringAsFixed(1)}%',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.p16.h),
          Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.2),
          ),
          SizedBox(height: AppSizes.p16.h),
          Row(
            children: [
              Expanded(
                child: SoldStatItem(
                  label: 'sold_apartments_total_value'.tr(),
                  value: stats.soldValue.currencyShort,
                ),
              ),
              Container(
                width: 1,
                height: 40.h,
                color: Colors.white.withValues(alpha: 0.2),
              ),
              Expanded(
                child: SoldStatItem(
                  label: 'sold_apartments_average_price'.tr(),
                  value: stats.averagePrice.currencyShort,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SoldStatItem extends StatelessWidget {
  final String label;
  final String value;

  const SoldStatItem({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.h4.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
