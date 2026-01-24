import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/apartment.dart';

class ApartmentListRow extends StatelessWidget {
  final Apartment apartment;
  final int index;
  final VoidCallback? onTap;

  const ApartmentListRow({
    super.key,
    required this.apartment,
    required this.index,
    this.onTap,
  });

  String _formatPrice(double price) {
    if (price >= 1000000000) {
      return '${(price / 1000000000).toStringAsFixed(1)} mlrd';
    }
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)} mln';
    }
    return '${price.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            // Number badge
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: apartment.status.backgroundColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: apartment.status.color,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Info column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Apartment number and block/floor
                  Row(
                    children: [
                      Text(
                        apartment.apartmentNumber,
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: theme.textTheme.titleMedium?.color,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        apartment.blockFloorText,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  // Rooms and area
                  Row(
                    children: [
                      Icon(
                        Icons.bed_outlined,
                        size: 14.w,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        apartment.roomsText,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Icon(
                        Icons.square_foot_outlined,
                        size: 14.w,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        apartment.areaText,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  // Price and status
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (apartment.pricePerSqm > 0)
                            Text(
                              '${_formatPrice(apartment.pricePerSqm)} ${apartment.currency}/m²',
                              style: GoogleFonts.inter(
                                fontSize: 11.sp,
                                color: theme.textTheme.bodySmall?.color,
                              ),
                            ),
                          Text(
                            '${_formatPrice(apartment.price)} ${apartment.currency}',
                            style: GoogleFonts.inter(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: theme.textTheme.titleLarge?.color,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Status badge
                      _buildStatusBadge(),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            // Arrow
            Icon(
              Icons.chevron_right_rounded,
              size: 24.w,
              color: theme.textTheme.bodySmall?.color,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: apartment.status.backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              color: apartment.status.color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            apartment.status.badgeLabel,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: apartment.status.color,
            ),
          ),
        ],
      ),
    );
  }
}

class ApartmentListSkeleton extends StatelessWidget {
  const ApartmentListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final shimmerColor = isDark ? AppColors.darkBorder : AppColors.border;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: shimmerColor.withAlpha(50)),
          ),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: shimmerColor.withAlpha(100),
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 150.w,
                      height: 14.h,
                      decoration: BoxDecoration(
                        color: shimmerColor.withAlpha(100),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: 100.w,
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: shimmerColor.withAlpha(80),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Container(
                          width: 80.w,
                          height: 16.h,
                          decoration: BoxDecoration(
                            color: shimmerColor.withAlpha(100),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 60.w,
                          height: 24.h,
                          decoration: BoxDecoration(
                            color: shimmerColor.withAlpha(80),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
