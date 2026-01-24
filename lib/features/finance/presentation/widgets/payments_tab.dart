import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/route_names.dart';
import '../bloc/finance_bloc.dart';
import 'expected_payments_chart.dart';
import 'payment_filter_bottom_sheet.dart';
import 'payment_kpi_cards.dart';
import 'payment_list_item.dart';
import 'payments_chart.dart';

/// Payments tab content with stats, charts, and payment list
class PaymentsTab extends StatefulWidget {
  const PaymentsTab({super.key});

  @override
  State<PaymentsTab> createState() => _PaymentsTabState();
}

class _PaymentsTabState extends State<PaymentsTab> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinanceBloc, FinanceState>(
      builder: (context, state) {
        final isLoading = state.status == FinanceStatus.loading;

        return RefreshIndicator(
          onRefresh: () async {
            context.read<FinanceBloc>().add(const LoadFinanceData());
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppSizes.p16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Horizontal KPI Cards
                PaymentKpiCards(
                  stats: state.paymentStats,
                  isLoading: isLoading,
                ),
                SizedBox(height: AppSizes.p20.h),
                // Search and Filter Row
                _buildSearchAndFilter(context, state),
                SizedBox(height: AppSizes.p20.h),
                // Payments donut chart
                PaymentsChart(stats: state.paymentStats),
                SizedBox(height: AppSizes.p24.h),
                // Expected payments bar chart
                ExpectedPaymentsChart(stats: state.paymentStats),
                SizedBox(height: AppSizes.p24.h),
                // Recent payments section
                _buildSectionHeader(
                  context,
                  'finance_recent_payments'.tr(),
                  onSeeAll: () {
                    context.push(RouteNames.allPayments);
                  },
                ),
                SizedBox(height: AppSizes.p12.h),
                // Payment list
                if (state.filteredPayments.isEmpty && !isLoading)
                  _buildEmptyState()
                else
                  ...state.filteredPayments.take(5).map(
                        (payment) => PaymentListItem(
                          payment: payment,
                          onTap: () {
                            _showPaymentDetails(context, payment);
                          },
                        ),
                      ),
                // Bottom padding: navbar (70) + margin (12) + safe area (~34) + FAB (56) + buffer
                SizedBox(height: 180.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchAndFilter(BuildContext context, FinanceState state) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48.h,
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
              border: Border.all(color: borderColor),
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              textAlignVertical: TextAlignVertical.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: theme.textTheme.bodyMedium?.color,
              ),
              onChanged: (value) {
                context.read<FinanceBloc>().add(SearchPayments(value));
              },
              decoration: InputDecoration(
                hintText: 'finance_search_placeholder'.tr(),
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: theme.textTheme.bodySmall?.color,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: theme.textTheme.bodySmall?.color,
                  size: 20.w,
                ),
                prefixIconConstraints: BoxConstraints(
                  minWidth: 48.w,
                  minHeight: 48.h,
                ),
                suffixIcon: state.paymentSearchQuery.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          context
                              .read<FinanceBloc>()
                              .add(const SearchPayments(''));
                        },
                        icon: Icon(
                          Icons.close_rounded,
                          color: theme.textTheme.bodySmall?.color,
                          size: 20.w,
                        ),
                      )
                    : null,
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 14.h,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: AppSizes.p12.w),
        _buildFilterButton(context, state),
      ],
    );
  }

  Widget _buildFilterButton(BuildContext context, FinanceState state) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final hasActiveFilters = state.hasActivePaymentFilters;

    return GestureDetector(
      onTap: () => _showFilterSheet(context, state),
      child: Container(
        width: 48.w,
        height: 48.h,
        decoration: BoxDecoration(
          color: hasActiveFilters ? theme.colorScheme.primary : theme.cardColor,
          borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
          border: Border.all(
            color: hasActiveFilters ? theme.colorScheme.primary : borderColor,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.tune_rounded,
              color: hasActiveFilters
                  ? Colors.white
                  : theme.textTheme.bodySmall?.color,
              size: 20.w,
            ),
            if (hasActiveFilters)
              Positioned(
                top: 8.h,
                right: 8.w,
                child: Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: const BoxDecoration(
                    color: AppColors.warning,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context, FinanceState state) {
    PaymentFilterBottomSheet.show(
      context,
      initialFilters: state.paymentFilters,
      onApply: (filters) {
        context.read<FinanceBloc>().add(FilterPayments(filters));
      },
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title, {
    VoidCallback? onSeeAll,
  }) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.h4.copyWith(
            color: theme.textTheme.titleMedium?.color,
          ),
        ),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: Row(
              children: [
                Text(
                  'finance_filter_all'.tr(),
                  style: AppTextStyles.labelMedium.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                SizedBox(width: AppSizes.p4.w),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14.w,
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.p32.w),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_rounded,
            size: 48.w,
            color: theme.textTheme.bodySmall?.color,
          ),
          SizedBox(height: AppSizes.p16.h),
          Text(
            'finance_no_payments'.tr(),
            style: AppTextStyles.bodyMedium.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentDetails(BuildContext context, Payment payment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _PaymentDetailsSheet(payment: payment),
    );
  }
}

class _PaymentDetailsSheet extends StatelessWidget {
  const _PaymentDetailsSheet({required this.payment});

  final Payment payment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusXL.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: AppSizes.p12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: borderColor,
              borderRadius: BorderRadius.circular(AppSizes.radiusFull.r),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(AppSizes.p24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'finance_payment_details'.tr(),
                      style: AppTextStyles.h3.copyWith(
                        color: theme.textTheme.titleLarge?.color,
                      ),
                    ),
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.close_rounded),
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.p20.h),
                // Status badge
                _buildStatusBadge(context),
                SizedBox(height: AppSizes.p16.h),
                // Receipt number
                _buildDetailRow(context, 'finance_receipt'.tr(), '#${payment.receiptNumber}'),
                _buildDetailRow(context, 'finance_client'.tr(), payment.clientName),
                _buildDetailRow(context, 'finance_contract'.tr(), payment.contractNumber),
                _buildDetailRow(context, 'finance_project'.tr(), payment.projectName ?? '-'),
                _buildDetailRow(context, 'finance_amount'.tr(), payment.formattedAmount),
                _buildDetailRow(context, 'finance_payment_type'.tr(), payment.typeLabel),
                _buildDetailRow(context, 'finance_date_label'.tr(), _formatDate(payment.date)),
                if (payment.processedBy != null)
                  _buildDetailRow(context, 'finance_processed_by_label'.tr(), payment.processedBy!),
                SizedBox(height: AppSizes.p24.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final theme = Theme.of(context);
    final color = switch (payment.status) {
      PaymentStatus.completed => AppColors.success,
      PaymentStatus.pending => AppColors.warning,
      PaymentStatus.overdue => AppColors.error,
      PaymentStatus.cancelled => theme.textTheme.bodySmall?.color ?? AppColors.textTertiary,
    };
    final bgColor = switch (payment.status) {
      PaymentStatus.completed => AppColors.successLight,
      PaymentStatus.pending => AppColors.warningLight,
      PaymentStatus.overdue => AppColors.errorLight,
      PaymentStatus.cancelled => theme.scaffoldBackgroundColor,
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.p12.w,
        vertical: AppSizes.p8.h,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull.r),
      ),
      child: Text(
        payment.statusLabel,
        style: AppTextStyles.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.p12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: theme.textTheme.titleMedium?.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
