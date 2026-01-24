import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_colors.dart';
import 'settings_tile.dart';

/// Notifications section for settings screen.
class SettingsNotificationsSection extends StatefulWidget {
  const SettingsNotificationsSection({super.key});

  @override
  State<SettingsNotificationsSection> createState() => _SettingsNotificationsSectionState();
}

class _SettingsNotificationsSectionState extends State<SettingsNotificationsSection> {
  bool _pushNotifications = true;
  bool _newLeadsNotifications = true;
  bool _paymentsNotifications = true;
  bool _approvalsNotifications = true;
  bool _soundEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSizes.p16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
      ),
      child: Column(
        children: [
          SettingsTile.toggle(
            icon: Icons.notifications_outlined,
            title: 'settings_push_notifications'.tr(),
            value: _pushNotifications,
            onChanged: (value) => setState(() => _pushNotifications = value),
          ),
          SettingsTile.toggle(
            icon: Icons.person_add_outlined,
            title: 'settings_new_leads'.tr(),
            value: _newLeadsNotifications,
            onChanged: (value) => setState(() => _newLeadsNotifications = value),
          ),
          SettingsTile.toggle(
            icon: Icons.payments_outlined,
            title: 'settings_payments'.tr(),
            value: _paymentsNotifications,
            onChanged: (value) => setState(() => _paymentsNotifications = value),
          ),
          SettingsTile.toggle(
            icon: Icons.check_circle_outline,
            title: 'approvals_title'.tr(),
            value: _approvalsNotifications,
            onChanged: (value) => setState(() => _approvalsNotifications = value),
          ),
          SettingsTile.toggle(
            icon: Icons.volume_up_outlined,
            title: 'settings_sound'.tr(),
            value: _soundEnabled,
            onChanged: (value) => setState(() => _soundEnabled = value),
            showDivider: false,
          ),
        ],
      ),
    );
  }
}
