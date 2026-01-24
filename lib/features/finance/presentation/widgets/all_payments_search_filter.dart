import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../bloc/finance_bloc.dart';
import 'payment_filter_bottom_sheet.dart';

class AllPaymentsSearchFilter extends StatelessWidget {
  final TextEditingController searchController;

  const AllPaymentsSearchFilter({
    super.key,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<FinanceBloc, FinanceState>(
      builder: (context, state) {
        return Container(
          color: theme.cardColor,
          padding: EdgeInsets.fromLTRB(
            AppSizes.p16.w,
            AppSizes.p8.h,
            AppSizes.p16.w,
            AppSizes.p12.h,
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildSearchField(context, state),
              ),
              SizedBox(width: AppSizes.p12.w),
              _buildFilterButton(context, state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchField(BuildContext context, FinanceState state) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
        border: Border.all(color: borderColor),
      ),
      child: TextField(
        controller: searchController,
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
                    searchController.clear();
                    context.read<FinanceBloc>().add(const SearchPayments(''));
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
          color: hasActiveFilters ? theme.colorScheme.primary : theme.scaffoldBackgroundColor,
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
              color: hasActiveFilters ? Colors.white : theme.textTheme.bodySmall?.color,
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
}
