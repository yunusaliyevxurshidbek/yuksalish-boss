import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../injection_container.dart';
import '../../../../presentation/widgets/custom_snacbar.dart';
import '../../data/services/analytics_pdf_generator.dart';
import '../bloc/analytics_bloc.dart';
import '../models/analytics_view_model.dart';
import '../theme/analytics_theme.dart';
import '../widgets/analytics_content.dart';
import '../widgets/analytics_error_state.dart';
import '../widgets/analytics_header_section.dart';
import '../widgets/analytics_loading_state.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AnalyticsBloc>()..add(const LoadAnalytics()),
      child: const AnalysisPage(),
    );
  }
}

class AnalysisPage extends StatelessWidget {
  const AnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = AnalyticsPremiumColors.of(context);

    return Scaffold(
      backgroundColor: colors.scaffoldBackground,
      body: SafeArea(
        bottom: false,
        child: BlocConsumer<AnalyticsBloc, AnalyticsState>(
          listenWhen: (previous, current) =>
              previous.exportSuccessPath != current.exportSuccessPath ||
              previous.exportError != current.exportError ||
              previous.isExporting != current.isExporting ||
              previous.savedToDownloads != current.savedToDownloads,
          listener: (context, state) {
            _handleExportState(context, state);
          },
          builder: (context, state) {
            final viewModel = AnalyticsViewModel.fromState(state);
            final isInitialLoading =
                (state.status == AnalyticsStatus.initial ||
                        state.status == AnalyticsStatus.loading) &&
                    !state.hasData;

            return RefreshIndicator(
              color: theme.colorScheme.primary,
              onRefresh: () async {
                context.read<AnalyticsBloc>().add(const RefreshAnalytics());
                await Future.delayed(const Duration(milliseconds: 600));
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(bottom: 140.h),
                children: [
                  AnalyticsHeaderSection(
                    period: viewModel.period,
                    lastUpdatedLabel: viewModel.lastUpdatedLabel,
                    isOffline: state.isOffline,
                    isExporting: state.isExporting,
                    onPeriodChanged: (period) {
                      context.read<AnalyticsBloc>().add(ChangePeriod(period));
                    },
                    onExport: () {
                      context.read<AnalyticsBloc>().add(
                            ExportAnalyticsPdf(
                              translations: PdfTranslations(
                                reportTitle: 'analytics_pdf_report_title'.tr(),
                                period: 'analytics_pdf_period'.tr(),
                                keyMetrics: 'analytics_pdf_key_metrics'.tr(),
                                totalRevenue: 'analytics_pdf_total_revenue'.tr(),
                                closedDeals: 'analytics_pdf_closed_deals'.tr(),
                                activeLeads: 'analytics_pdf_active_leads'.tr(),
                                totalClients: 'analytics_pdf_total_clients'.tr(),
                                activeContracts: 'analytics_pdf_active_contracts'.tr(),
                                conversion: 'analytics_pdf_conversion'.tr(),
                                contractStatus: 'analytics_pdf_contract_status'.tr(),
                                status: 'analytics_pdf_status'.tr(),
                                count: 'analytics_pdf_count'.tr(),
                                leadStages: 'analytics_pdf_lead_stages'.tr(),
                                stage: 'analytics_pdf_stage'.tr(),
                                recentContracts: 'analytics_pdf_recent_contracts'.tr(),
                                number: 'analytics_pdf_number'.tr(),
                                client: 'analytics_pdf_client'.tr(),
                                amount: 'analytics_pdf_amount'.tr(),
                                pageFormat: 'analytics_pdf_page'.tr(),
                                moreContracts: 'analytics_pdf_more_contracts'.tr(),
                                statusTranslations: {
                                  'draft': 'analytics_pdf_status_draft'.tr(),
                                  'active': 'analytics_pdf_status_active'.tr(),
                                  'completed': 'analytics_pdf_status_completed'.tr(),
                                  'terminated': 'analytics_pdf_status_terminated'.tr(),
                                  'cancelled': 'analytics_pdf_status_cancelled'.tr(),
                                  'rejected': 'analytics_pdf_status_rejected'.tr(),
                                  'pending': 'analytics_pdf_status_pending'.tr(),
                                },
                                stageTranslations: {
                                  'new': 'analytics_pdf_stage_new'.tr(),
                                  'contacted': 'analytics_pdf_stage_contacted'.tr(),
                                  'qualified': 'analytics_pdf_stage_qualified'.tr(),
                                  'showing': 'analytics_pdf_stage_showing'.tr(),
                                  'negotiation': 'analytics_pdf_stage_negotiation'.tr(),
                                  'reservation': 'analytics_pdf_stage_reservation'.tr(),
                                  'contract': 'analytics_pdf_stage_contract'.tr(),
                                  'won': 'analytics_pdf_stage_won'.tr(),
                                  'lost': 'analytics_pdf_stage_lost'.tr(),
                                },
                              ),
                            ),
                          );
                    },
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: isInitialLoading
                        ? const AnalyticsLoadingState()
                        : state.status == AnalyticsStatus.error && !state.hasData
                            ? AnalyticsErrorState(
                                errorMessage: state.errorMessage,
                                onRetry: () {
                                  context.read<AnalyticsBloc>().add(const LoadAnalytics());
                                },
                              )
                            : AnalyticsContent(
                                viewModel: viewModel,
                                errorMessage: state.errorMessage,
                                onRetryAll: () {
                                  context.read<AnalyticsBloc>().add(const LoadAnalytics());
                                },
                                onRefreshContracts: () {
                                  context.read<AnalyticsBloc>().add(const RefreshContracts());
                                },
                                onRefreshRevenue: () {
                                  context.read<AnalyticsBloc>().add(const RefreshRevenueBreakdown());
                                },
                                onProjectChanged: (projectId) {
                                  context.read<AnalyticsBloc>().add(ChangeProjectFilter(projectId));
                                },
                                onPaymentsFromChanged: (date) {
                                  context.read<AnalyticsBloc>().add(
                                        ChangePaymentsDateRange(
                                          from: date,
                                          to: viewModel.paymentsTo,
                                        ),
                                      );
                                },
                                onPaymentsToChanged: (date) {
                                  context.read<AnalyticsBloc>().add(
                                        ChangePaymentsDateRange(
                                          from: viewModel.paymentsFrom,
                                          to: date,
                                        ),
                                      );
                                },
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

  void _handleExportState(BuildContext context, AnalyticsState state) {
    if (state.isExporting) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const _ExportLoadingDialog(),
      );
    } else if (state.exportSuccessPath != null) {
      Navigator.of(context, rootNavigator: true).pop();
      CustomSnacbar.show(
        context,
        text: state.savedToDownloads
            ? 'analytics_pdf_saved_downloads'.tr()
            : 'analytics_pdf_saved'.tr(),
      );
      context.read<AnalyticsBloc>().add(const ClearExportStatus());
    } else if (state.exportError != null) {
      Navigator.of(context, rootNavigator: true).pop();
      CustomSnacbar.show(
        context,
        text: state.exportError!,
        isError: true,
      );
      context.read<AnalyticsBloc>().add(const ClearExportStatus());
    }
  }
}

class _ExportLoadingDialog extends StatelessWidget {
  const _ExportLoadingDialog();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      child: Center(
        child: Container(
          padding: EdgeInsets.all(24.w),
          margin: EdgeInsets.symmetric(horizontal: 40.w),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 48.w,
                height: 48.w,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: theme.colorScheme.primary,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'analytics_pdf_preparing'.tr(),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: theme.textTheme.bodyLarge?.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'analytics_please_wait'.tr(),
                style: AppTextStyles.bodySmall.copyWith(
                  color: theme.textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
