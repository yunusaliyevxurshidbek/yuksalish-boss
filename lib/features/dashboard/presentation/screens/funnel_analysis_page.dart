import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/widgets/app_shimmer.dart';
import '../../../../injection_container.dart';
import '../../data/models/funnel_models.dart';
import '../bloc/funnel_analysis_cubit.dart';
import '../bloc/funnel_analysis_state.dart';
import '../widgets/funnel_analysis/funnel_analysis.dart';

/// Re-export models for backward compatibility.
export '../../data/models/funnel_models.dart';

/// Funnel analysis page with chart, KPIs, and stage breakdown.
class FunnelAnalysisPage extends StatelessWidget {
  const FunnelAnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<FunnelAnalysisCubit>()..loadFunnelData(),
      child: const _FunnelAnalysisView(),
    );
  }
}

class _FunnelAnalysisView extends StatelessWidget {
  const _FunnelAnalysisView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: BlocBuilder<FunnelAnalysisCubit, FunnelAnalysisState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const _LoadingView();
          }

          if (state.hasError) {
            return _ErrorView(
              message: state.errorMessage ?? 'dashboard_error'.tr(),
              onRetry: () => context.read<FunnelAnalysisCubit>().loadFunnelData(),
            );
          }

          if (state.stages.isEmpty) {
            return const _EmptyView();
          }

          return RefreshIndicator(
            onRefresh: () => context.read<FunnelAnalysisCubit>().refresh(),
            color: theme.colorScheme.primary,
            child: _ContentView(
              stages: state.stages,
              kpis: state.kpis,
              totalCount: state.totalCount,
            ),
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
          color: theme.textTheme.titleLarge?.color,
          size: 20.w,
        ),
      ),
      title: Text(
        'dashboard_funnel_analysis'.tr(),
        style: GoogleFonts.inter(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: theme.textTheme.titleLarge?.color,
        ),
      ),
    );
  }
}

class _ContentView extends StatelessWidget {
  final List<FunnelStage> stages;
  final List<FunnelKpi> kpis;
  final int totalCount;

  const _ContentView({
    required this.stages,
    required this.kpis,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: SizedBox(height: 8.h)),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: FunnelChartCard(stages: stages),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 16.h)),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: FunnelKpiRow(kpis: kpis),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 12.h),
            child: Text(
              'dashboard_funnel_by_stages'.tr(),
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: theme.textTheme.titleLarge?.color,
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final stage = stages[index];
              return Padding(
                padding: EdgeInsets.fromLTRB(
                  16.w,
                  0,
                  16.w,
                  index == stages.length - 1 ? 24.h : 12.h,
                ),
                child: FunnelStageTile(
                  stage: stage,
                  total: totalCount,
                ),
              );
            },
            childCount: stages.length,
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
          // Chart shimmer
          AppShimmer(
            child: Container(
              height: 280.h,
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          // KPIs shimmer
          AppShimmer(
            child: Container(
              height: 80.h,
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          // Stages shimmer
          ...List.generate(
            6,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: AppShimmer(
                child: Container(
                  height: 72.h,
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
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

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.filter_alt_off_rounded,
            size: 64.w,
            color: theme.textTheme.bodySmall?.color,
          ),
          SizedBox(height: 16.h),
          Text(
            'dashboard_no_data'.tr(),
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }
}
