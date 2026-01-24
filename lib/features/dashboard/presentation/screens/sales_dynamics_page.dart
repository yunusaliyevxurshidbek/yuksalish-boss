import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/widgets/app_shimmer.dart';
import '../../../../injection_container.dart';
import '../bloc/sales_dynamics_cubit.dart';
import '../bloc/sales_dynamics_state.dart';
import '../widgets/sales_dynamics/sales_dynamics.dart';

/// Re-export models for backward compatibility.
export '../../data/models/sales_dynamics_models.dart';

/// Sales dynamics analysis page with comprehensive analytics.
class SalesDynamicsPage extends StatelessWidget {
  const SalesDynamicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SalesDynamicsCubit>()..loadData(),
      child: const _SalesDynamicsView(),
    );
  }
}

class _SalesDynamicsView extends StatelessWidget {
  const _SalesDynamicsView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: BlocBuilder<SalesDynamicsCubit, SalesDynamicsState>(
        builder: (context, state) {
          if (state.isLoading && !state.isRefreshing) {
            return const _LoadingView();
          }

          if (state.hasError && !state.hasData) {
            return _ErrorView(
              message: state.errorMessage ?? 'dashboard_error'.tr(),
              onRetry: () => context.read<SalesDynamicsCubit>().loadData(),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<SalesDynamicsCubit>().refresh(),
            color: theme.colorScheme.primary,
            child: _ContentView(state: state),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: Icon(
          Icons.arrow_back_rounded,
          size: 20.w,
          color: theme.textTheme.titleLarge?.color,
        ),
      ),
      title: Text(
        'dashboard_sales_dynamics'.tr(),
        style: GoogleFonts.inter(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: theme.textTheme.titleLarge?.color,
        ),
      ),
      actions: [
        BlocBuilder<SalesDynamicsCubit, SalesDynamicsState>(
          builder: (context, state) {
            return PopupMenuButton<SalesDynamicsPeriod>(
              onSelected: (period) {
                context.read<SalesDynamicsCubit>().changePeriod(period);
              },
              offset: Offset(0, 40.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              icon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.selectedPeriod.translationKey.tr(),
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20.w,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),
              itemBuilder: (context) => SalesDynamicsPeriod.values.map((period) {
                return PopupMenuItem<SalesDynamicsPeriod>(
                  value: period,
                  child: Row(
                    children: [
                      if (period == state.selectedPeriod)
                        Icon(
                          Icons.check_rounded,
                          size: 18.w,
                          color: theme.colorScheme.primary,
                        )
                      else
                        SizedBox(width: 18.w),
                      SizedBox(width: 8.w),
                      Text(
                        period.translationKey.tr(),
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: period == state.selectedPeriod
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: period == state.selectedPeriod
                              ? theme.colorScheme.primary
                              : theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
        SizedBox(width: 8.w),
      ],
    );
  }
}

class _ContentView extends StatelessWidget {
  final SalesDynamicsState state;

  const _ContentView({required this.state});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Section 1: Summary KPI Cards
              SummaryCardsSection(state: state),
              SizedBox(height: 20.h),

              // Section 2: Monthly Sales Chart
              MonthlySalesChart(monthlySales: state.monthlySales),
              SizedBox(height: 20.h),

              // Section 3: Funnel Distribution
              FunnelDistributionChart(leadsByStage: state.leadsByStage),
              SizedBox(height: 20.h),

              // Section 4: Revenue Breakdown
              RevenueBreakdownSection(
                totalPaid: state.totalPaid,
                pendingPayments: state.pendingPayments,
                overduePayments: state.overduePaymentsTotal,
              ),
              SizedBox(height: 20.h),

              // Section 5: Inventory Status
              InventoryStatusSection(
                totalUnits: state.totalUnits,
                availableUnits: state.availableUnits,
                reservedUnits: state.reservedUnits,
                soldUnits: state.soldUnits,
                soldValue: state.soldValue,
              ),
              SizedBox(height: 20.h),

              // Section 6: Contracts by Status
              ContractsStatusSection(contractsByStatus: state.contractsByStatus),
              SizedBox(height: 20.h),

              // Section 7: Overdue Payments Alert
              OverduePaymentsAlert(
                payments: state.overduePayments,
                onViewAllPressed: () {
                  // TODO: Navigate to overdue payments list
                },
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // KPI Cards shimmer (2x2 grid)
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 1.15,
            children: List.generate(
              4,
              (index) => AppShimmer(
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          // Chart shimmer
          AppShimmer(
            child: Container(
              height: 260.h,
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          // Funnel shimmer
          AppShimmer(
            child: Container(
              height: 220.h,
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          // Revenue breakdown shimmer
          AppShimmer(
            child: Container(
              height: 180.h,
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          // Inventory shimmer
          AppShimmer(
            child: Container(
              height: 160.h,
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ),
        ],
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
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64.w,
              color: theme.colorScheme.error,
            ),
            SizedBox(height: 16.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'dashboard_retry'.tr(),
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
