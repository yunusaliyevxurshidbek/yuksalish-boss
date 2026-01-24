import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/finance_bloc.dart';
import 'debt_detail_modal.dart';
import 'debt_filter_bottom_sheet.dart';
import 'debt_kpi_cards.dart';
import 'debt_list_item.dart';

/// Debts tab content with KPI cards, filters, and debtor list
class DebtsTab extends StatefulWidget {
  const DebtsTab({super.key});

  @override
  State<DebtsTab> createState() => _DebtsTabState();
}

class _DebtsTabState extends State<DebtsTab> {
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
                DebtKpiCards(
                  stats: state.debtStats,
                  isLoading: isLoading,
                ),
                SizedBox(height: AppSizes.p20.h),
                // Search and Filter Row
                _buildSearchAndFilter(context, state),
                SizedBox(height: AppSizes.p20.h),
                // Section header
                _buildSectionHeader(
                  context,
                  'finance_debtors_list'.tr(),
                ),
                SizedBox(height: AppSizes.p12.h),
                // Debt list
                if (state.filteredDebts.isEmpty && !isLoading)
                  _buildEmptyState()
                else
                  ...state.filteredDebts.take(10).map(
                        (debt) => DebtListItem(
                          debt: debt,
                          onTap: () => _showDebtDetail(context, debt, state),
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
                context.read<FinanceBloc>().add(SearchDebts(value));
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
                suffixIcon: state.searchQuery.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          context
                              .read<FinanceBloc>()
                              .add(const SearchDebts(''));
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
    final hasActiveFilters = state.hasActiveDebtFilters;

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
    DebtFilterBottomSheet.show(
      context,
      initialFilters: state.debtFilters,
      onApply: (filters) {
        context.read<FinanceBloc>().add(FilterDebts(filters));
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
            Icons.account_balance_wallet_outlined,
            size: 48.w,
            color: theme.textTheme.bodySmall?.color,
          ),
          SizedBox(height: AppSizes.p16.h),
          Text(
            'finance_debtor_not_found'.tr(),
            style: AppTextStyles.bodyMedium.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }

  void _showDebtDetail(BuildContext context, Debt debt, FinanceState state) {
    DebtDetailModal.show(
      context,
      debt: debt,
    );
  }
}
