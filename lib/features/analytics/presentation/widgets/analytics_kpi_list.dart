import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_sizes.dart';
import 'analytics_empty_state.dart';
import 'analytics_kpi_card.dart';

class KpiCardData {
  final String title;
  final String? subtitle;
  final String value;
  final IconData icon;
  final Color color;
  final double? trend;
  final bool isNegativeBetter;

  const KpiCardData({
    required this.title,
    this.subtitle,
    required this.value,
    required this.icon,
    required this.color,
    this.trend,
    this.isNegativeBetter = false,
  });
}

class AnalyticsKpiList extends StatelessWidget {
  final List<KpiCardData> cards;

  const AnalyticsKpiList({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.p16.w),
        child: AnalyticsEmptyState.noData(),
      );
    }
    return SizedBox(
      height: 180.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppSizes.p16.w),
        itemBuilder: (context, index) {
          final item = cards[index];
          return AnalyticsKpiCard(
            title: item.title,
            subtitle: item.subtitle,
            value: item.value,
            icon: item.icon,
            color: item.color,
            trend: item.trend,
            isNegativeBetter: item.isNegativeBetter,
          );
        },
        separatorBuilder: (_, __) => SizedBox(width: AppSizes.p12.w),
        itemCount: cards.length,
      ),
    );
  }
}
