import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/number_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../widgets/project_detail/project_detail.dart';

/// Project detail screen.
///
/// Shows comprehensive information about a specific project.
class ProjectDetailScreen extends StatelessWidget {
  final String projectId;

  const ProjectDetailScreen({
    super.key,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Loyiha tafsilotlari',
          style: AppTextStyles.h4.copyWith(
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
        iconTheme: IconThemeData(color: theme.iconTheme.color),
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.string(
              AppIcons.moreHorizontal,
              width: AppSizes.iconL.w,
              colorFilter: ColorFilter.mode(
                theme.iconTheme.color ?? theme.textTheme.titleMedium!.color!,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: AppSizes.p32.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProjectDetailHeader(
              name: 'Yuksalish Tower',
              location: 'Toshkent, Chilonzor tumani',
              status: 'Faol',
              totalUnits: 240,
              soldUnits: 186,
              availableUnits: 54,
            ),
            SizedBox(height: AppSizes.p24.h),
            _buildQuickStats(),
            SizedBox(height: AppSizes.p24.h),
            ProjectSalesProgress(
              items: const [
                SalesProgressItem(label: '1-xonali', sold: 48, total: 60, color: AppColors.chartBlue),
                SalesProgressItem(label: '2-xonali', sold: 72, total: 90, color: AppColors.chartGreen),
                SalesProgressItem(label: '3-xonali', sold: 45, total: 60, color: AppColors.chartYellow),
                SalesProgressItem(label: '4-xonali', sold: 21, total: 30, color: AppColors.chartPurple),
              ],
              onDetailTap: () {},
            ),
            SizedBox(height: AppSizes.p24.h),
            ProjectFinancialSummary(
              items: [
                FinancialRow(label: "To'langan", value: 32400000000.currency, color: AppColors.success),
                FinancialRow(label: 'Kutilmoqda', value: 12200000000.currency, color: AppColors.warning),
                FinancialRow(label: 'Kechikkan', value: 3400000000.currency, color: AppColors.error),
              ],
            ),
            SizedBox(height: AppSizes.p24.h),
            ProjectActivityList(
              items: const [
                ActivityItem(
                  title: 'Yangi shartnoma',
                  subtitle: 'Xonadon #412 - Aliyev J.',
                  time: '2 soat oldin',
                  type: BadgeType.success,
                ),
                ActivityItem(
                  title: "To'lov qabul qilindi",
                  subtitle: 'Xonadon #318 - 25 000 000 UZS',
                  time: '5 soat oldin',
                  type: BadgeType.info,
                ),
                ActivityItem(
                  title: "Chegirma so'rovi",
                  subtitle: 'Xonadon #205 - tasdiqlash kutilmoqda',
                  time: 'Kecha',
                  type: BadgeType.warning,
                ),
              ],
              onViewAll: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.p16.w),
      child: Row(
        children: [
          Expanded(
            child: MetricCardCompact(
              title: 'Umumiy qiymat',
              value: 48000000000.short,
              iconSvg: AppIcons.money,
              accentColor: AppColors.success,
            ),
          ),
          SizedBox(width: AppSizes.p12.w),
          Expanded(
            child: MetricCardCompact(
              title: "Yig'ilgan",
              value: 32400000000.short,
              iconSvg: AppIcons.wallet,
              accentColor: AppColors.primary,
            ),
          ),
          SizedBox(width: AppSizes.p12.w),
          Expanded(
            child: MetricCardCompact(
              title: 'Qoldiq',
              value: 15600000000.short,
              iconSvg: AppIcons.clock,
              accentColor: AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }
}
