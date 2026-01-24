import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:yuksalish_mobile/core/constants/app_icons.dart';
import 'package:yuksalish_mobile/core/constants/app_sizes.dart';
import 'package:yuksalish_mobile/core/constants/app_text_styles.dart';
import 'package:yuksalish_mobile/core/constants/app_colors.dart';
import 'package:yuksalish_mobile/core/widgets/widgets.dart';

class QuickActionItem {
  final String label;
  final String icon;
  final Color color;
  final VoidCallback? onTap;

  const QuickActionItem({
    required this.label,
    required this.icon,
    required this.color,
    this.onTap,
  });
}

class QuickActions extends StatelessWidget {
  final List<QuickActionItem> actions;
  final bool isLoading;

  const QuickActions({
    super.key,
    required this.actions,
    this.isLoading = false,
  });

  factory QuickActions.defaultActions({
    VoidCallback? onNewLead,
    VoidCallback? onAddPayment,
    VoidCallback? onApprovals,
    VoidCallback? onReports,
  }) {
    return QuickActions(
      actions: [
        QuickActionItem(
          label: 'dashboard_action_new_lead'.tr(),
          icon: AppIcons.plus,
          color: AppColors.success,
          onTap: onNewLead,
        ),
        QuickActionItem(
          label: 'dashboard_action_add_payment'.tr(),
          icon: AppIcons.wallet,
          color: AppColors.info,
          onTap: onAddPayment,
        ),
        QuickActionItem(
          label: 'dashboard_action_approvals'.tr(),
          icon: AppIcons.checkCircle,
          color: AppColors.warning,
          onTap: onApprovals,
        ),
        QuickActionItem(
          label: 'dashboard_action_reports'.tr(),
          icon: AppIcons.document,
          color: AppColors.chartPurple,
          onTap: onReports,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.p16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'dashboard_quick_actions'.tr(),
          ),
          SizedBox(height: AppSizes.p12.h),
          SizedBox(
            height: 100.h,
            child: isLoading
                ? const _QuickActionsShimmer()
                : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: actions.length,
                    separatorBuilder: (_, __) => SizedBox(width: AppSizes.p12.w),
                    itemBuilder: (context, index) {
                      final action = actions[index];
                      return _QuickActionCard(
                        label: action.label,
                        icon: action.icon,
                        color: action.color,
                        onTap: action.onTap,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatefulWidget {
  final String label;
  final String icon;
  final Color color;
  final VoidCallback? onTap;

  const _QuickActionCard({
    required this.label,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  State<_QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<_QuickActionCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 90.w,
        padding: EdgeInsets.all(AppSizes.p12.w),
        decoration: BoxDecoration(
          color: _isPressed
              ? widget.color.withValues(alpha: 0.1)
              : theme.cardColor,
          borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
          border: Border.all(
            color: _isPressed
                ? widget.color
                : (isDark ? AppColors.darkBorder : AppColors.border),
            width: _isPressed ? AppSizes.borderMedium : AppSizes.borderThin,
          ),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: _isPressed ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
              ),
              child: Center(
                child: SvgPicture.string(
                  widget.icon,
                  width: AppSizes.iconM.w,
                  height: AppSizes.iconM.w,
                  colorFilter: ColorFilter.mode(
                    widget.color,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            SizedBox(height: 6.h),
            Flexible(
              child: Text(
                widget.label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: _isPressed
                      ? widget.color
                      : theme.textTheme.bodyMedium?.color,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionsShimmer extends StatelessWidget {
  const _QuickActionsShimmer();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final shimmerColor = isDark ? AppColors.darkBorder : AppColors.grey100;

    return AppShimmer(
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        separatorBuilder: (_, __) => SizedBox(width: AppSizes.p12.w),
        itemBuilder: (context, index) {
          return Container(
            width: 90.w,
            decoration: BoxDecoration(
              color: shimmerColor,
              borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
            ),
          );
        },
      ),
    );
  }
}
