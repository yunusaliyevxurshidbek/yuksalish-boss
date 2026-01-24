import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../injection_container.dart';
import '../../../../presentation/widgets/custom_button_universal.dart';
import '../../data/models/lead_model.dart';
import '../bloc/leads_cubit.dart';
import '../widgets/lead_card.dart';
import '../widgets/lead_stage_filter.dart';

class LeadsScreen extends StatelessWidget {
  const LeadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LeadsCubit>()..loadLeads(),
      child: const _LeadsView(),
    );
  }
}

class _LeadsView extends StatelessWidget {
  const _LeadsView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: theme.iconTheme.color),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'leads_title'.tr(),
          style: AppTextStyles.h3.copyWith(
            color: theme.textTheme.titleLarge?.color,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.h),
          child: BlocBuilder<LeadsCubit, LeadsState>(
            buildWhen: (previous, current) =>
                previous.selectedStage != current.selectedStage,
            builder: (context, state) {
              return LeadStageFilter(
                selectedStage: state.selectedStage,
                onStageSelected: (stage) {
                  context.read<LeadsCubit>().filterByStage(stage);
                },
              );
            },
          ),
        ),
      ),
      body: BlocBuilder<LeadsCubit, LeadsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const _LeadsLoadingView();
          }

          if (state.hasError) {
            return _LeadsErrorView(
              message: state.errorMessage ?? 'common_error'.tr(),
              onRetry: () => context.read<LeadsCubit>().loadLeads(),
            );
          }

          if (state.isEmpty) {
            return const _LeadsEmptyView();
          }

          return _LeadsListView(
            leads: state.leads,
            hasNextPage: state.hasNextPage,
            isLoadingMore: state.isLoadingMore,
            onLoadMore: () => context.read<LeadsCubit>().loadMoreLeads(),
            onRefresh: () => context.read<LeadsCubit>().refresh(),
          );
        },
      ),
    );
  }
}

class _LeadsLoadingView extends StatelessWidget {
  const _LeadsLoadingView();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(AppSizes.p16.w),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: AppSizes.p12.h),
          child: AppShimmer(
            child: ShimmerPlaceholder.card(
              height: 140.h,
              borderRadius: AppSizes.radiusM.r,
            ),
          ),
        );
      },
    );
  }
}

class _LeadsErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _LeadsErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.p24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.w,
              color: theme.colorScheme.error,
            ),
            SizedBox(height: AppSizes.p16.h),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: theme.textTheme.bodyMedium?.color,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSizes.p24.h),
            PressableButton(
              text: 'leads_retry'.tr(),
              onTap: onRetry,
              backgroundColor: theme.colorScheme.primary,
              borderRadius: AppSizes.radiusM.r,
            ),
          ],
        ),
      ),
    );
  }
}

class _LeadsEmptyView extends StatelessWidget {
  const _LeadsEmptyView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.p24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64.w,
              color: theme.textTheme.bodySmall?.color,
            ),
            SizedBox(height: AppSizes.p16.h),
            Text(
              'leads_not_found'.tr(),
              style: AppTextStyles.h4.copyWith(
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
            SizedBox(height: AppSizes.p8.h),
            Text(
              'leads_no_data'.tr(),
              style: AppTextStyles.bodyMedium.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _LeadsListView extends StatelessWidget {
  final List<Lead> leads;
  final bool hasNextPage;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;
  final Future<void> Function() onRefresh;

  const _LeadsListView({
    required this.leads,
    required this.hasNextPage,
    required this.isLoadingMore,
    required this.onLoadMore,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: theme.colorScheme.primary,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification &&
              notification.metrics.extentAfter < 200 &&
              hasNextPage &&
              !isLoadingMore) {
            onLoadMore();
          }
          return false;
        },
        child: ListView.builder(
          padding: EdgeInsets.all(AppSizes.p16.w),
          itemCount: leads.length + (isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == leads.length) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: AppSizes.p16.h),
                child: Center(
                  child: CircularProgressIndicator(
                    color: theme.colorScheme.primary,
                  ),
                ),
              );
            }

            final lead = leads[index];
            return Padding(
              padding: EdgeInsets.only(bottom: AppSizes.p12.h),
              child: LeadCard(
                lead: lead,
                onTap: () => _onLeadTap(context, lead),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onLeadTap(BuildContext context, Lead lead) {
    context.push('/leads/${lead.id}');
  }
}
