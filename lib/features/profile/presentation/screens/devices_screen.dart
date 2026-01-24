import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../injection_container.dart';
import '../../../devices/domain/entities/user_device.dart';
import '../../../devices/presentation/bloc/devices_bloc.dart';
import '../theme/profile_theme.dart';

/// Screen showing authorized devices with ability to manage sessions.
class DevicesScreen extends StatelessWidget {
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DevicesBloc>()..add(const LoadDevices()),
      child: const _DevicesScreenContent(),
    );
  }
}

class _DevicesScreenContent extends StatelessWidget {
  const _DevicesScreenContent();

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_rounded,
            color: colors.textPrimary,
            size: AppSizes.iconL.w,
          ),
        ),
        title: Text(
          'profile_devices_title'.tr(),
          style: AppTextStyles.h3.copyWith(color: colors.textPrimary),
        ),
        actions: [
          BlocBuilder<DevicesBloc, DevicesState>(
            builder: (context, state) {
              if (state.isRefreshing) {
                return Padding(
                  padding: EdgeInsets.only(right: AppSizes.p16.w),
                  child: SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.primary,
                    ),
                  ),
                );
              }
              return IconButton(
                onPressed: () =>
                    context.read<DevicesBloc>().add(const RefreshDevices()),
                icon: Icon(
                  Icons.refresh_rounded,
                  color: colors.textPrimary,
                  size: AppSizes.iconM.w,
                ),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<DevicesBloc, DevicesState>(
        listener: (context, state) {
          // Show snackbar on operation success/failure
          if (state.operationStatus == DeviceOperationStatus.terminated ||
              state.operationStatus == DeviceOperationStatus.loggedOutAll) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage ?? 'Operation completed'),
                backgroundColor: colors.success,
                behavior: SnackBarBehavior.floating,
              ),
            );
            context.read<DevicesBloc>().clearOperationStatus();
          } else if (state.operationStatus == DeviceOperationStatus.failed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Operation failed'),
                backgroundColor: colors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
            context.read<DevicesBloc>().clearOperationStatus();
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: colors.primary),
            );
          }

          if (state.hasError && state.currentDevice == null) {
            return _ErrorView(
              message: state.errorMessage ?? 'Failed to load devices',
              onRetry: () =>
                  context.read<DevicesBloc>().add(const LoadDevices()),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<DevicesBloc>().add(const RefreshDevices());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(AppSizes.p16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.currentDevice != null) ...[
                    _SectionHeader(titleKey: 'profile_devices_current_section'),
                    SizedBox(height: AppSizes.p8.h),
                    _DeviceCard(
                      device: state.currentDevice!,
                      isCurrent: true,
                    ),
                  ],
                  if (state.hasOtherDevices) ...[
                    SizedBox(height: AppSizes.p24.h),
                    _SectionHeader(titleKey: 'profile_devices_other_section'),
                    SizedBox(height: AppSizes.p8.h),
                    ...state.otherDevices.map((device) => Padding(
                          padding: EdgeInsets.only(bottom: AppSizes.p12.h),
                          child: _DeviceCard(
                            device: device,
                            isOperating:
                                state.operatingDeviceId == device.id &&
                                    state.isOperating,
                            onRemove: () => _showRemoveDialog(context, device),
                          ),
                        )),
                    SizedBox(height: AppSizes.p16.h),
                    _RemoveAllButton(
                      isLoading: state.operationStatus ==
                          DeviceOperationStatus.loggingOutAll,
                      onPressed: () => _showRemoveAllDialog(context),
                    ),
                  ] else if (state.currentDevice != null) ...[
                    SizedBox(height: AppSizes.p24.h),
                    const _EmptyOtherDevices(),
                  ],
                  SizedBox(height: AppSizes.p32.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showRemoveDialog(BuildContext context, UserDevice device) {
    final colors = ProfileThemeColors.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusL),
          ),
          title: Text(
            'profile_devices_remove_title'.tr(),
            style: AppTextStyles.h4.copyWith(color: colors.textPrimary),
          ),
          content: Text(
            'profile_devices_remove_message'.tr(),
            style:
                AppTextStyles.bodyMedium.copyWith(color: colors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => dialogContext.pop(),
              child: Text(
                'common_cancel'.tr(),
                style: AppTextStyles.labelMedium
                    .copyWith(color: colors.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                dialogContext.pop();
                context.read<DevicesBloc>().add(
                      TerminateDeviceSession(deviceId: device.id),
                    );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.error,
                foregroundColor: colors.textOnPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusS),
                ),
              ),
              child: Text(
                'common_delete'.tr(),
                style: AppTextStyles.labelMedium
                    .copyWith(color: colors.textOnPrimary),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showRemoveAllDialog(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusL),
          ),
          title: Text(
            'profile_devices_remove_all_title'.tr(),
            style: AppTextStyles.h4.copyWith(color: colors.textPrimary),
          ),
          content: Text(
            'profile_devices_remove_all_message'.tr(),
            style:
                AppTextStyles.bodyMedium.copyWith(color: colors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => dialogContext.pop(),
              child: Text(
                'common_cancel'.tr(),
                style: AppTextStyles.labelMedium
                    .copyWith(color: colors.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                dialogContext.pop();
                context.read<DevicesBloc>().add(
                      const LogoutFromAllDevices(keepCurrent: true),
                    );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.error,
                foregroundColor: colors.textOnPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusS),
                ),
              ),
              child: Text(
                'profile_devices_remove_all_action'.tr(),
                style: AppTextStyles.labelMedium
                    .copyWith(color: colors.textOnPrimary),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String titleKey;

  const _SectionHeader({required this.titleKey});

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return Text(
      titleKey.tr(),
      style: AppTextStyles.labelSmall.copyWith(
        color: colors.textTertiary,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _DeviceCard extends StatelessWidget {
  final UserDevice device;
  final bool isCurrent;
  final bool isOperating;
  final VoidCallback? onRemove;

  const _DeviceCard({
    required this.device,
    this.isCurrent = false,
    this.isOperating = false,
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
            ? Border.all(
                color: colors.success.withValues(alpha: 0.5), width: 1.5)
            : null,
        boxShadow: [colors.cardShadow],
      ),
      child: Row(
        children: [
          _DeviceIcon(platform: device.platform),
          SizedBox(width: AppSizes.p12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        device.displayName,
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
                  device.platformInfo,
                  style: AppTextStyles.bodySmall
                      .copyWith(color: colors.textSecondary),
                ),
                SizedBox(height: 2.h),
                Text(
                  'profile_devices_last_active'.tr(
                    namedArgs: {'time': device.lastActiveRelative},
                  ),
                  style: AppTextStyles.caption
                      .copyWith(color: colors.textTertiary),
                ),
              ],
            ),
          ),
          if (onRemove != null)
            isOperating
                ? SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.error,
                    ),
                  )
                : IconButton(
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

class _RemoveAllButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const _RemoveAllButton({
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? SizedBox(
                width: 18.w,
                height: 18.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colors.error,
                ),
              )
            : Icon(
                Icons.logout_rounded,
                color: colors.error,
                size: AppSizes.iconM.w,
              ),
        label: Text(
          'profile_devices_remove_all'.tr(),
          style: AppTextStyles.labelMedium.copyWith(color: colors.error),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: colors.error),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
          ),
          padding: EdgeInsets.symmetric(vertical: AppSizes.p12.h),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.p24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64.w,
              color: colors.error,
            ),
            SizedBox(height: AppSizes.p16.h),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSizes.p24.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text('common_retry'.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.textOnPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyOtherDevices extends StatelessWidget {
  const _EmptyOtherDevices();

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return Container(
      padding: EdgeInsets.all(AppSizes.p24.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
        boxShadow: [colors.cardShadow],
      ),
      child: Column(
        children: [
          Icon(
            Icons.devices_rounded,
            size: 48.w,
            color: colors.textTertiary,
          ),
          SizedBox(height: AppSizes.p12.h),
          Text(
            'profile_devices_no_other_devices'.tr(),
            style: AppTextStyles.bodyMedium.copyWith(
              color: colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
