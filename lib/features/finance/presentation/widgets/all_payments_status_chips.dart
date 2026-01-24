import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../bloc/finance_bloc.dart';

typedef StatusFilter = ({String label, PaymentStatus? status});

class AllPaymentsStatusChips extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onIndexChanged;
  final List<StatusFilter> statusFilters;

  const AllPaymentsStatusChips({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
    required this.statusFilters,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Container(
      color: theme.cardColor,
      padding: EdgeInsets.only(bottom: AppSizes.p12.h),
      child: SizedBox(
        height: 36.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: AppSizes.p16.w),
          itemCount: statusFilters.length,
          separatorBuilder: (_, __) => SizedBox(width: AppSizes.p8.w),
          itemBuilder: (context, index) {
            final isActive = index == selectedIndex;
            final filter = statusFilters[index];
            return GestureDetector(
              onTap: () {
                onIndexChanged(index);
                // Apply status filter through bloc
                final currentFilters =
                    context.read<FinanceBloc>().state.paymentFilters;
                context.read<FinanceBloc>().add(
                      FilterPayments(
                        currentFilters.copyWith(
                          status: filter.status,
                          clearStatus: filter.status == null,
                        ),
                      ),
                    );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.p16.w),
                decoration: BoxDecoration(
                  color: isActive ? theme.colorScheme.primary : theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(AppSizes.radiusFull.r),
                  border: Border.all(
                    color: isActive ? theme.colorScheme.primary : borderColor,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    filter.label.tr(),
                    style: AppTextStyles.labelMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isActive ? Colors.white : theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
