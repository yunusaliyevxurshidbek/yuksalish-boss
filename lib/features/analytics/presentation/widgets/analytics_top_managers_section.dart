import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_sizes.dart';
import '../utils/analytics_utils.dart';
import 'analytics_empty_state.dart';
import 'manager_performance_card.dart';

class ManagerPerformanceData {
  final int rank;
  final String name;
  final int deals;
  final double revenue;

  const ManagerPerformanceData({
    required this.rank,
    required this.name,
    required this.deals,
    required this.revenue,
  });

  String get revenueLabel => formatCurrency(revenue);

  ManagerPerformanceData copyWith({
    int? rank,
    String? name,
    int? deals,
    double? revenue,
  }) {
    return ManagerPerformanceData(
      rank: rank ?? this.rank,
      name: name ?? this.name,
      deals: deals ?? this.deals,
      revenue: revenue ?? this.revenue,
    );
  }
}

class AnalyticsTopManagersSection extends StatelessWidget {
  final List<ManagerPerformanceData> managers;

  const AnalyticsTopManagersSection({super.key, required this.managers});

  @override
  Widget build(BuildContext context) {
    if (managers.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.p16.w),
        child: AnalyticsEmptyState.noData(
          title: 'analytics_agents_no_data'.tr(),
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.p16.w),
      child: Column(
        children: managers
            .map(
              (manager) => ManagerPerformanceCard(
                rank: manager.rank,
                name: manager.name,
                deals: manager.deals,
                revenue: manager.revenueLabel,
              ),
            )
            .toList(),
      ),
    );
  }
}
