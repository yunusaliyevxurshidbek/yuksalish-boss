import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../injection_container.dart';
import '../bloc/revenue_details_cubit.dart';
import '../bloc/revenue_details_state.dart';
import '../widgets/revenue_details_kpi_grid.dart';
import '../widgets/revenue_details_main_card.dart';
import '../widgets/revenue_details_payment_breakdown.dart';
import '../widgets/revenue_details_sales_chart.dart';
import '../widgets/revenue_details_states.dart';

class RevenueDetailsScreen extends StatelessWidget {
  const RevenueDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<RevenueDetailsCubit>()..loadRevenueDetails(),
      child: const _RevenueDetailsView(),
    );
  }
}

class _RevenueDetailsView extends StatelessWidget {
  const _RevenueDetailsView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        surfaceTintColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: theme.iconTheme.color),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'revenue_details_title'.tr(),
          style: AppTextStyles.h3.copyWith(
            color: theme.textTheme.titleLarge?.color,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<RevenueDetailsCubit, RevenueDetailsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const RevenueDetailsLoadingView();
          }

          if (state.hasError) {
            return RevenueDetailsErrorView(
              message: state.errorMessage ?? 'common_error'.tr(),
              onRetry: () =>
                  context.read<RevenueDetailsCubit>().loadRevenueDetails(),
            );
          }

          return _RevenueContent(stats: state.stats);
        },
      ),
    );
  }
}

class _RevenueContent extends StatelessWidget {
  final RevenueStats stats;

  const _RevenueContent({required this.stats});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () => context.read<RevenueDetailsCubit>().refresh(),
      color: theme.colorScheme.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(AppSizes.p16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Revenue Card
            RevenueDetailsMainCard(stats: stats),
            SizedBox(height: AppSizes.p16.h),

            // KPI Grid
            RevenueDetailsKpiGrid(stats: stats),
            SizedBox(height: AppSizes.p20.h),

            // Sales Chart
            RevenueDetailsSalesChart(monthlySales: stats.monthlySales),
            SizedBox(height: AppSizes.p20.h),

            // Payment Breakdown
            RevenueDetailsPaymentBreakdown(stats: stats),
            SizedBox(height: AppSizes.p24.h),
          ],
        ),
      ),
    );
  }
}

