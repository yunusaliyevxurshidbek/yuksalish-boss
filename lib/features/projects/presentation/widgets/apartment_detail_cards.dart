import 'package:easy_localization/easy_localization.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';import 'package:easy_localization/easy_localization.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/apartment.dart';

class ApartmentDetailSliverAppBar extends StatelessWidget {
  final Apartment apartment;
  final Widget backButton;

  const ApartmentDetailSliverAppBar({
    super.key,
    required this.apartment,
    required this.backButton,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final shimmerColor = isDark ? AppColors.darkBorder : AppColors.border;

    return SliverAppBar(
      expandedHeight: 280.h,
      pinned: true,
      backgroundColor: theme.cardColor,
      surfaceTintColor: Colors.transparent,
      leading: backButton,
      flexibleSpace: FlexibleSpaceBar(
        background: apartment.layoutImage != null
            ? CachedNetworkImage(
                imageUrl: apartment.layoutImage!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: shimmerColor.withAlpha(100),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) =>
                    const ApartmentPlaceholderImage(),
              )
            : const ApartmentPlaceholderImage(),
      ),
    );
  }
}

class ApartmentPlaceholderImage extends StatelessWidget {
  const ApartmentPlaceholderImage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final shimmerColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Container(
      color: shimmerColor.withAlpha(100),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_outlined,
              size: 64.w,
              color: theme.textTheme.bodySmall?.color,
            ),
            SizedBox(height: 8.h),
            Text(
              'Planirovka mavjud emas',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ApartmentBackButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ApartmentBackButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(100),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.arrow_back_rounded,
          color: Colors.white,
          size: 20.w,
        ),
      ),
    );
  }
}

class ApartmentDetailHeader extends StatelessWidget {
  final Apartment apartment;

  const ApartmentDetailHeader({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                apartment.apartmentNumber,
                style: GoogleFonts.inter(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: theme.textTheme.titleLarge?.color,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                apartment.projectName ?? 'Loyiha',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: theme.textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ),
        ApartmentStatusBadge(status: apartment.status),
      ],
    );
  }
}

class ApartmentStatusBadge extends StatelessWidget {
  final ApartmentStatus status;

  const ApartmentStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: status.backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: status.color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            status.badgeLabel,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: status.color,
            ),
          ),
        ],
      ),
    );
  }
}

class ApartmentMainInfoCard extends StatelessWidget {
  final Apartment apartment;

  const ApartmentMainInfoCard({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor.withAlpha(100)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'apartment_detail_basic_info'.tr(),
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.titleMedium?.color,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: ApartmentInfoItem(
                  icon: Icons.apartment_rounded,
                  label: 'apartment_detail_block'.tr(),
                  value: apartment.block,
                ),
              ),
              Expanded(
                child: ApartmentInfoItem(
                  icon: Icons.layers_rounded,
                  label: 'apartment_detail_floor'.tr(),
                  value: '${apartment.floor}',
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: ApartmentInfoItem(
                  icon: Icons.bed_rounded,
                  label: 'apartment_detail_rooms'.tr(),
                  value: '${apartment.rooms} xona',
                ),
              ),
              Expanded(
                child: ApartmentInfoItem(
                  icon: Icons.square_foot_rounded,
                  label: 'apartment_detail_area'.tr(),
                  value: apartment.areaText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ApartmentInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ApartmentInfoItem({
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
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withAlpha(20),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            icon,
            size: 20.w,
            color: theme.colorScheme.primary,
          ),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: theme.textTheme.titleMedium?.color,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ApartmentPriceCard extends StatelessWidget {
  final Apartment apartment;

  const ApartmentPriceCard({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withAlpha(200),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'apartment_detail_price'.tr(),
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: Colors.white.withAlpha(200),
                ),
              ),
              if (apartment.pricePerSqm > 0)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(50),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    '${_formatPrice(apartment.pricePerSqm)} ${apartment.currency}/m²',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            '${_formatPrice(apartment.price)} ${apartment.currency}',
            style: GoogleFonts.inter(
              fontSize: 28.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    if (price >= 1000000000) {
      return '${(price / 1000000000).toStringAsFixed(1)} mlrd';
    }
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)} mln';
    }
    return price.toStringAsFixed(0);
  }
}

class ApartmentDetailsCard extends StatelessWidget {
  final Apartment apartment;

  const ApartmentDetailsCard({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor.withAlpha(100)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'apartment_detail_additional_info'.tr(),
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.titleMedium?.color,
            ),
          ),
          SizedBox(height: 16.h),
          ApartmentDetailRow(
            label: 'apartment_detail_repair_status'.tr(),
            value: apartment.renovationStatus ?? 'apartment_detail_not_specified'.tr(),
          ),
          Divider(color: borderColor.withAlpha(100), height: 1),
          ApartmentDetailRow(
            label: 'apartment_detail_habitable'.tr(),
            value: apartment.isLiveable ? 'apartment_detail_yes'.tr() : 'apartment_detail_no'.tr(),
            valueColor: apartment.isLiveable
                ? const Color(0xFF27AE60)
                : null,
          ),
          Divider(color: borderColor.withAlpha(100), height: 1),
          ApartmentDetailRow(
            label: 'apartment_detail_number'.tr(),
            value: apartment.apartmentNumber,
          ),
        ],
      ),
    );
  }
}

class ApartmentDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const ApartmentDetailRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: valueColor ?? theme.textTheme.titleMedium?.color,
            ),
          ),
        ],
      ),
    );
  }
}
