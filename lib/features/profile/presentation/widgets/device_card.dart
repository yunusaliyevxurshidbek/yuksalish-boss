import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/device_info.dart';
import '../theme/profile_theme.dart';

/// Card widget displaying device information.
class DeviceCard extends StatelessWidget {
  final DeviceInfo device;
  final bool isCurrent;
  final VoidCallback? onRemove;

  const DeviceCard({
    super.key,
    required this.device,
    this.isCurrent = false,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return Container(
      padding: EdgeInsets.all(AppSizes.p16.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
        border: isCurrent
            ? Border.all(color: colors.success.withValues(alpha: 0.5), width: 1.5)
            : null,
        boxShadow: [colors.cardShadow],
      ),
      child: Row(
        children: [
          _DeviceIcon(platform: device.platform),
          SizedBox(width: AppSizes.p12.w),
          Expanded(child: _DeviceInfo(device: device, isCurrent: isCurrent)),
          if (onRemove != null)
            IconButton(
              onPressed: onRemove,
              icon: Icon(
                Icons.delete_outline_rounded,
                color: colors.error,
                size: AppSizes.iconM.w,
              ),
            ),
        ],
      ),
    );
  }
}

class _DeviceIcon extends StatelessWidget {
  final String platform;

  const _DeviceIcon({required this.platform});

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        color: colors.tintIconBackground(colors.primary),
        borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
      ),
      child: Icon(
        _getDeviceIcon(),
        color: colors.primary,
        size: AppSizes.iconL.w,
      ),
    );
  }

  IconData _getDeviceIcon() {
    switch (platform.toLowerCase()) {
      case 'ios':
        return Icons.phone_iphone_rounded;
      case 'android':
        return Icons.phone_android_rounded;
      case 'web':
        return Icons.computer_rounded;
      default:
        return Icons.devices_rounded;
    }
  }
}

class _DeviceInfo extends StatelessWidget {
  final DeviceInfo device;
  final bool isCurrent;

  const _DeviceInfo({required this.device, required this.isCurrent});

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                device.name,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (isCurrent) const _CurrentBadge(),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          '${device.platform} ${device.osVersion}',
          style: AppTextStyles.bodySmall.copyWith(color: colors.textSecondary),
        ),
        SizedBox(height: 2.h),
        Text(
          'profile_devices_last_active'
              .tr(namedArgs: {'time': device.lastActiveText}),
          style: AppTextStyles.caption.copyWith(color: colors.textTertiary),
        ),
      ],
    );
  }
}

class _CurrentBadge extends StatelessWidget {
  const _CurrentBadge();

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: colors.successLight,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              color: colors.success,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            'profile_devices_current_badge'.tr(),
            style: AppTextStyles.caption.copyWith(
              color: colors.success,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
