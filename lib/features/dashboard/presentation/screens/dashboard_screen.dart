import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:yuksalish_mobile/core/constants/app_sizes.dart';
import 'package:yuksalish_mobile/core/widgets/widgets.dart';
import 'package:yuksalish_mobile/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:yuksalish_mobile/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:yuksalish_mobile/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:yuksalish_mobile/features/dashboard/presentation/widgets/funnel_chart.dart';
import 'package:yuksalish_mobile/features/dashboard/presentation/widgets/metrics_grid.dart';
import 'package:yuksalish_mobile/features/dashboard/presentation/widgets/sales_chart.dart';
import 'package:yuksalish_mobile/features/notifications/notifications.dart';
import 'package:yuksalish_mobile/injection_container.dart';
import 'package:yuksalish_mobile/presentation/widgets/custom_snacbar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DashboardBloc>()..add(const LoadDashboard()),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<DashboardBloc>().add(const RefreshDashboard());
                await Future.delayed(const Duration(milliseconds: 1500));
              },
              color: theme.colorScheme.primary,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder<NotificationsCubit, NotificationsState>(
                          builder: (context, notificationState) {
                            return DashboardHeader(
                              userName: 'dashboard_director'.tr(),
                              notificationCount: notificationState.unreadCount,
                              onNotificationTap: () => _onNotificationTap(context),
                              onProfileTap: () => _onProfileTap(context),
                            );
                          },
                        ),
                        SizedBox(height: AppSizes.p8.h),
                        _PeriodFilterChips(
                          selectedPeriod: state.selectedPeriod,
                          onPeriodChanged: (period) {
                            context.read<DashboardBloc>().add(ChangePeriod(period));
                          },
                        ),
                        SizedBox(height: AppSizes.p20.h),
                        MetricsGrid(
                          metrics: state.metrics,
                          isLoading: state.isLoading,
                          onRevenueTap: () => _onMetricTap(context, 'revenue'),
                          onLeadsTap: () => _onMetricTap(context, 'leads'),
                          onSoldTap: () => _onMetricTap(context, 'sold'),
                          onConversionTap: () => _onMetricTap(context, 'conversion'),
                        ),
                        SizedBox(height: AppSizes.p24.h),
                        SalesChart(
                          data: state.salesData,
                          isLoading: state.isLoading,
                          onSeeAllTap: () => _onSalesDetailTap(context),
                        ),
                        SizedBox(height: AppSizes.p24.h),
                        FunnelChart(
                          data: state.funnelData,
                          isLoading: state.isLoading,
                          onSeeAllTap: () => _onFunnelDetailTap(context),
                        ),
                        // Bottom padding: navbar (70) + margin (12) + safe area (~34) + buffer
                        SizedBox(height: 130.h),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _onNotificationTap(BuildContext context) {
    context.push('/notifications');
  }

  void _onProfileTap(BuildContext context) {
    context.push('/profile');
  }

  void _onMetricTap(BuildContext context, String metric) {
    switch (metric) {
      case 'revenue':
        context.push('/revenue-details');
        break;
      case 'leads':
        context.push('/leads');
        break;
      case 'sold':
        context.push('/sold-apartments');
        break;
      default:
        CustomSnacbar.show(
          context,
          text: 'dashboard_metric_info'.tr(namedArgs: {'metric': metric}),
        );
    }
  }

  void _onSalesDetailTap(BuildContext context) {
    context.push('/sales-dynamics');
  }

  void _onFunnelDetailTap(BuildContext context) {
    context.push('/funnel-analysis');
  }
}

class _PeriodFilterChips extends StatelessWidget {
  final DashboardPeriod selectedPeriod;
  final ValueChanged<DashboardPeriod> onPeriodChanged;

  const _PeriodFilterChips({
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final periods = [
      (DashboardPeriod.today, 'dashboard_period_today'.tr()),
      (DashboardPeriod.week, 'dashboard_period_week'.tr()),
      (DashboardPeriod.month, 'dashboard_period_month'.tr()),
      (DashboardPeriod.quarter, 'dashboard_period_quarter'.tr()),
      (DashboardPeriod.year, 'dashboard_period_year'.tr()),
    ];

    final selectedIndex = periods.indexWhere((p) => p.$1 == selectedPeriod);

    return FilterChipGroup(
      items: periods.map((p) => p.$2).toList(),
      selectedIndex: selectedIndex >= 0 ? selectedIndex : 2,
      horizontalPadding: AppSizes.p16,
      onSelected: (index) {
        if (index >= 0 && index < periods.length) {
          onPeriodChanged(periods[index].$1);
        }
      },
    );
  }
}
