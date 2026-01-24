import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_sizes.dart';
import '../models/analytics_view_model.dart';
import '../theme/analytics_theme.dart';
import 'analytics_chart_card.dart';
import 'analytics_inline_error_banner.dart';
import 'analytics_kpi_list.dart';
import 'analytics_payments_section.dart';
import 'analytics_revenue_section.dart';
import 'analytics_section_header.dart';
import 'analytics_top_managers_section.dart';
import 'contracts_line_chart.dart';
import 'inventory_detail_section.dart';
import 'inventory_segment_bar.dart';
import 'inventory_stacked_chart.dart';
import 'lead_sources_chart.dart';
import 'sales_trend_chart.dart';

class AnalyticsContent extends StatelessWidget {
  final AnalyticsViewModel viewModel;
  final String? errorMessage;
  final VoidCallback onRetryAll;
  final VoidCallback onRefreshContracts;
  final VoidCallback onRefreshRevenue;
  final ValueChanged<String> onProjectChanged;
  final ValueChanged<DateTime> onPaymentsFromChanged;
  final ValueChanged<DateTime> onPaymentsToChanged;

  const AnalyticsContent({
    super.key,
    required this.viewModel,
    required this.errorMessage,
    required this.onRetryAll,
    required this.onRefreshContracts,
    required this.onRefreshRevenue,
    required this.onProjectChanged,
    required this.onPaymentsFromChanged,
    required this.onPaymentsToChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AnalyticsPremiumColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (errorMessage != null) ...[
          AnalyticsInlineErrorBanner(
            message: errorMessage!,
            onRetry: onRetryAll,
          ),
          SizedBox(height: AppSizes.p12.h),
        ],
        AnalyticsSectionHeader(title: 'analytics_section_kpi'.tr()),
        SizedBox(height: AppSizes.p12.h),
        AnalyticsKpiList(cards: viewModel.kpiCards),
        SizedBox(height: AppSizes.p24.h),
        AnalyticsSectionHeader(
          title: 'analytics_section_sales_dynamics'.tr(),
          subtitle: 'analytics_section_revenue'.tr(),
        ),
        SizedBox(height: AppSizes.p12.h),
        AnalyticsChartCard(
          child: SalesTrendChart(
            data: viewModel.salesTrend,
            lineColor: colors.chartLine,
          ),
        ),
        SizedBox(height: AppSizes.p24.h),
        AnalyticsSectionHeader(
          title: 'analytics_section_lead_sources'.tr(),
          subtitle: 'analytics_section_lead_sources_subtitle'.tr(),
        ),
        SizedBox(height: AppSizes.p12.h),
        AnalyticsChartCard(
          child: LeadSourcesChart(
            data: viewModel.leadSources,
            centerLabel: 'analytics_total_leads'.tr(),
          ),
        ),
        SizedBox(height: AppSizes.p24.h),
        AnalyticsSectionHeader(title: 'analytics_section_top_agents'.tr()),
        SizedBox(height: AppSizes.p12.h),
        AnalyticsTopManagersSection(managers: viewModel.topManagers),
        SizedBox(height: AppSizes.p24.h),
        AnalyticsSectionHeader(
          title: 'analytics_section_inventory_status'.tr(),
          subtitle: 'analytics_section_all_complexes'.tr(),
        ),
        SizedBox(height: AppSizes.p12.h),
        if (viewModel.inventoryDetail != null)
          AnalyticsChartCard(
            child: InventorySegmentBar(
              data: InventorySegmentData(
                available: viewModel.inventoryDetail!.available,
                sold: viewModel.inventoryDetail!.sold,
                reserved: viewModel.inventoryDetail!.reserved,
              ),
            ),
          ),
        SizedBox(height: AppSizes.p24.h),
        AnalyticsSectionHeader(title: 'analytics_section_inventory_by_complex'.tr()),
        SizedBox(height: AppSizes.p12.h),
        AnalyticsChartCard(
          child: InventoryStackedChart(data: viewModel.inventoryData),
        ),
        if (viewModel.inventoryDetail != null) ...[
          SizedBox(height: AppSizes.p12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.p16.w),
            child: InventoryDetailSection(data: viewModel.inventoryDetail!),
          ),
        ],
        SizedBox(height: AppSizes.p24.h),
        AnalyticsSectionHeader(title: 'analytics_section_payments_chart'.tr()),
        SizedBox(height: AppSizes.p12.h),
        AnalyticsPaymentsSection(
          data: viewModel.paymentsChart,
          totalAmount: viewModel.paymentsTotal,
          totalCount: viewModel.paymentsCount,
          from: viewModel.paymentsFrom,
          to: viewModel.paymentsTo,
          onFromChanged: onPaymentsFromChanged,
          onToChanged: onPaymentsToChanged,
        ),
        SizedBox(height: AppSizes.p24.h),
        AnalyticsSectionHeader(
          title: 'analytics_section_contracts_chart'.tr(),
          trailing: IconButton(
            onPressed: onRefreshContracts,
            icon: Icon(
              Icons.refresh_rounded,
              color: colors.primary,
              size: 20.w,
            ),
          ),
        ),
        SizedBox(height: AppSizes.p12.h),
        AnalyticsChartCard(
          child: ContractsLineChart(data: viewModel.contractsChart),
        ),
        SizedBox(height: AppSizes.p24.h),
        AnalyticsSectionHeader(
          title: 'analytics_section_total_revenue'.tr(),
          trailing: IconButton(
            onPressed: onRefreshRevenue,
            icon: Icon(
              Icons.refresh_rounded,
              color: colors.primary,
              size: 20.w,
            ),
          ),
        ),
        SizedBox(height: AppSizes.p12.h),
        AnalyticsRevenueBreakdownSection(
          projects: viewModel.projects,
          selectedProjectId: viewModel.selectedProjectId,
          onProjectChanged: onProjectChanged,
          paidAmount: viewModel.paidAmount,
          pendingAmount: viewModel.pendingAmount,
          availableAmount: viewModel.availableAmount,
        ),
        SizedBox(height: AppSizes.p24.h),
      ],
    );
  }
}
