import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/analytics_period.dart';
import '../theme/analytics_theme.dart';
import 'analytics_period_filter.dart';

class AnalyticsHeaderSection extends StatelessWidget {
  final AnalyticsPeriod period;
  final String? lastUpdatedLabel;
  final bool isOffline;
  final bool isExporting;
  final ValueChanged<AnalyticsPeriod> onPeriodChanged;
  final VoidCallback onExport;

  const AnalyticsHeaderSection({
    super.key,
    required this.period,
    required this.lastUpdatedLabel,
    required this.isOffline,
    required this.isExporting,
    required this.onPeriodChanged,
    required this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AnalyticsPremiumColors.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSizes.p16.w,
        AppSizes.p16.h,
        AppSizes.p16.w,
        AppSizes.p12.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  'analytics_title'.tr(),
                  style: AppTextStyles.h2.copyWith(
                    color: colors.textHeading,
                  ),
                ),
              ),
              if (isExporting)
                Padding(
                  padding: EdgeInsets.all(12.w),
                  child: SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.primary,
                    ),
                  ),
                )
              else
                IconButton(
                  onPressed: onExport,
                  icon: SvgPicture.asset(
                    'assets/icons/export.svg',
                    width: 22.w,
                    height: 22.w,
                    colorFilter: ColorFilter.mode(
                      colors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: AppSizes.p4.h),
          Text(
            'analytics_subtitle'.tr(),
            style: AppTextStyles.bodySmall.copyWith(
              color: colors.textMuted,
            ),
          ),
          SizedBox(height: AppSizes.p12.h),
          AnalyticsPeriodFilter(
            value: period,
            onChanged: onPeriodChanged,
          ),
          if (lastUpdatedLabel != null) ...[
            SizedBox(height: AppSizes.p8.h),
            AnalyticsMetaRow(label: lastUpdatedLabel!),
          ],
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: isOffline
                ? Padding(
                    padding: EdgeInsets.only(top: AppSizes.p8.h),
                    child: const AnalyticsOfflineBanner(),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class AnalyticsMetaRow extends StatelessWidget {
  final String label;

  const AnalyticsMetaRow({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = AnalyticsPremiumColors.of(context);
    return Row(
      children: [
        Container(
          width: 6.w,
          height: 6.w,
          decoration: BoxDecoration(
            color: colors.success,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: colors.textMuted,
            ),
          ),
        ),
      ],
    );
  }
}

class AnalyticsOfflineBanner extends StatelessWidget {
  const AnalyticsOfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AnalyticsPremiumColors.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.p12.w,
        vertical: AppSizes.p8.h,
      ),
      decoration: BoxDecoration(
        color: colors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
        border: Border.all(color: colors.warning.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.wifi_off_rounded,
            size: 16.w,
            color: colors.warning,
          ),
          SizedBox(width: AppSizes.p8.w),
          Expanded(
            child: Text(
              'analytics_offline_mode'.tr(),
              style: AppTextStyles.bodySmall.copyWith(
                color: colors.warning,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
