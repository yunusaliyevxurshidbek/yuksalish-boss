import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/widgets.dart';

/// History item data.
class ApprovalHistoryItem {
  final String title;
  final String subtitle;
  final String time;
  final bool isPending;

  const ApprovalHistoryItem({
    required this.title,
    required this.subtitle,
    required this.time,
    this.isPending = false,
  });
}

/// History timeline section for approval detail screen.
class ApprovalDetailHistory extends StatelessWidget {
  final List<ApprovalHistoryItem> items;

  const ApprovalDetailHistory({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'approvals_history'.tr()),
        SizedBox(height: AppSizes.p12.h),
        ...List.generate(items.length, (index) {
          final item = items[index];
          final isLast = index == items.length - 1;
          return _HistoryTimelineItem(item: item, isLast: isLast);
        }),
      ],
    );
  }
}

class _HistoryTimelineItem extends StatelessWidget {
  final ApprovalHistoryItem item;
  final bool isLast;

  const _HistoryTimelineItem({required this.item, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSizes.p16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: item.isPending ? AppColors.warning : AppColors.success,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Container(
                  width: 2.w,
                  height: 50.h,
                  color: AppColors.border,
                ),
            ],
          ),
          SizedBox(width: AppSizes.p12.w),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(bottom: AppSizes.p16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: AppTextStyles.labelMedium),
                  SizedBox(height: 2.h),
                  Text(item.subtitle, style: AppTextStyles.caption),
                  SizedBox(height: 4.h),
                  Text(
                    item.time,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
