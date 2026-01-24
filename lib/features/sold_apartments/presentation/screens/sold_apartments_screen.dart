import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../injection_container.dart';
import '../bloc/sold_apartments_cubit.dart';
import '../bloc/sold_apartments_state.dart';
import '../widgets/sold_apartments_error_view.dart';
import '../widgets/sold_apartments_kpi_grid.dart';
import '../widgets/sold_apartments_loading_view.dart';
import '../widgets/sold_apartments_main_card.dart';
import '../widgets/sold_apartments_project_chart.dart';
import '../widgets/sold_apartments_recent_list.dart';
import '../widgets/sold_apartments_room_chart.dart';
import '../widgets/sold_apartments_sales_chart.dart';
import '../widgets/sold_apartments_units_distribution.dart';

class SoldApartmentsScreen extends StatelessWidget {
  const SoldApartmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SoldApartmentsCubit>()..loadSoldApartmentsData(),
      child: const _SoldApartmentsView(),
    );
  }
}

class _SoldApartmentsView extends StatelessWidget {
  const _SoldApartmentsView();

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
          'sold_apartments_title'.tr(),
          style: AppTextStyles.h3.copyWith(
            color: theme.textTheme.titleLarge?.color,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<SoldApartmentsCubit, SoldApartmentsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const SoldApartmentsLoadingView();
          }

          if (state.hasError) {
            return SoldApartmentsErrorView(
              message: state.errorMessage ?? 'general_error_message'.tr(),
              onRetry: () =>
                  context.read<SoldApartmentsCubit>().loadSoldApartmentsData(),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<SoldApartmentsCubit>().refresh(),
            color: theme.colorScheme.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(AppSizes.p16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SoldApartmentsMainCard(stats: state.stats),
                  SizedBox(height: AppSizes.p20.h),
                  SoldApartmentsKpiGrid(stats: state.stats),
                  SizedBox(height: AppSizes.p24.h),
                  SoldApartmentsUnitsDistribution(stats: state.stats),
                  SizedBox(height: AppSizes.p24.h),
                  SoldApartmentsSalesChart(monthlySales: state.monthlySales),
                  SizedBox(height: AppSizes.p24.h),
                  SoldApartmentsRoomChart(
                    distribution: state.stats.roomDistribution,
                  ),
                  SizedBox(height: AppSizes.p24.h),
                  SoldApartmentsProjectChart(
                    distribution: state.stats.projectDistribution,
                  ),
                  SizedBox(height: AppSizes.p24.h),
                  SoldApartmentsRecentList(
                    apartments: state.recentSoldApartments,
                    hasMore: state.hasMoreApartments,
                    isLoadingMore: state.isLoadingMore,
                    onLoadMore: () =>
                        context.read<SoldApartmentsCubit>().loadMoreApartments(),
                  ),
                  SizedBox(height: 100.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


