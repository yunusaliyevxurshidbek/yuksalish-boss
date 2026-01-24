import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../injection_container.dart';
import '../../../../presentation/widgets/custom_snacbar.dart';
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
              previous.isExporting != current.isExporting,
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
                      context.read<AnalyticsBloc>().add(const ExportAnalyticsPdf());
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
        text: 'PDF muvaffaqiyatli saqlandi',
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
                'PDF tayyorlanmoqda...',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: theme.textTheme.bodyLarge?.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Iltimos, kuting',
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
