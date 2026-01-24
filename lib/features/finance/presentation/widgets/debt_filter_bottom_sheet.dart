import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/debt.dart';
import '../../data/models/debt_filter_params.dart';

/// Bottom sheet for filtering debts
class DebtFilterBottomSheet extends StatefulWidget {
  final DebtFilterParams initialFilters;
  final ValueChanged<DebtFilterParams> onApply;

  const DebtFilterBottomSheet({
    super.key,
    required this.initialFilters,
    required this.onApply,
  });

  /// Show the filter bottom sheet
  static Future<void> show(
    BuildContext context, {
    required DebtFilterParams initialFilters,
    required ValueChanged<DebtFilterParams> onApply,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DebtFilterBottomSheet(
        initialFilters: initialFilters,
        onApply: onApply,
      ),
    );
  }

  @override
  State<DebtFilterBottomSheet> createState() => _DebtFilterBottomSheetState();
}

class _DebtFilterBottomSheetState extends State<DebtFilterBottomSheet> {
  late DebtStatus? _selectedStatus;
  late LatenessRange? _selectedLatenessRange;
  late DebtSortBy? _sortBy;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.initialFilters.status;
    _selectedLatenessRange = widget.initialFilters.latenessRange;
    _sortBy = widget.initialFilters.sortBy;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusXL.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(context),
          _buildHeader(context),
          const Divider(height: 1),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSizes.p16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(context, 'finance_filter_status'.tr(), _buildStatusChips(context)),
                  SizedBox(height: AppSizes.p20.h),
                  _buildSection(context, 'finance_debt_lateness'.tr(), _buildLatenessChips(context)),
                  SizedBox(height: AppSizes.p20.h),
                  _buildSection(context, 'finance_debt_sort'.tr(), _buildSortOptions(context)),
                  SizedBox(height: AppSizes.p24.h),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          _buildActions(context),
        ],
      ),
    );
  }

  Widget _buildHandle(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Container(
      margin: EdgeInsets.only(top: AppSizes.p12.h),
      width: 40.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: borderColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull.r),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.all(AppSizes.p16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'finance_filters_title'.tr(),
            style: AppTextStyles.h3.copyWith(
              color: theme.textTheme.titleLarge?.color,
            ),
          ),
          IconButton(
            onPressed: () => context.pop(),
            icon: Icon(
              Icons.close_rounded,
              color: theme.textTheme.bodySmall?.color,
              size: 24.w,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, Widget content) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.labelLarge.copyWith(
            color: theme.textTheme.titleMedium?.color,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppSizes.p12.h),
        content,
      ],
    );
  }

  Widget _buildStatusChips(BuildContext context) {
    return Wrap(
      spacing: AppSizes.p8.w,
      runSpacing: AppSizes.p8.h,
      children: [
        _buildFilterChip(
          context: context,
          label: 'finance_filter_all'.tr(),
          isSelected: _selectedStatus == null,
          onTap: () => setState(() => _selectedStatus = null),
        ),
        ...DebtStatus.values.map(
          (status) => _buildFilterChip(
            context: context,
            label: status.label,
            isSelected: _selectedStatus == status,
            onTap: () => setState(() => _selectedStatus = status),
          ),
        ),
      ],
    );
  }

  Widget _buildLatenessChips(BuildContext context) {
    return Wrap(
      spacing: AppSizes.p8.w,
      runSpacing: AppSizes.p8.h,
      children: [
        _buildFilterChip(
          context: context,
          label: 'finance_filter_all'.tr(),
          isSelected: _selectedLatenessRange == null,
          onTap: () => setState(() => _selectedLatenessRange = null),
        ),
        ...LatenessRange.values.map(
          (range) => _buildFilterChip(
            context: context,
            label: range.label,
            isSelected: _selectedLatenessRange == range,
            onTap: () => setState(() => _selectedLatenessRange = range),
            color: _getLatenessColor(range),
          ),
        ),
      ],
    );
  }

  Color _getLatenessColor(LatenessRange range) {
    return switch (range) {
      LatenessRange.none => AppColors.success,
      LatenessRange.oneToSeven => AppColors.info,
      LatenessRange.eightToFourteen => AppColors.warning,
      LatenessRange.fifteenToThirty => AppColors.error,
      LatenessRange.overThirty => AppColors.error,
    };
  }

  Widget _buildFilterChip({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    Color? color,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final chipColor = isSelected ? (color ?? theme.colorScheme.primary) : null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.p16.w,
          vertical: AppSizes.p8.h,
        ),
        decoration: BoxDecoration(
          color: isSelected ? chipColor : theme.cardColor,
          borderRadius: BorderRadius.circular(AppSizes.radiusFull.r),
          border: Border.all(
            color: isSelected ? chipColor! : borderColor,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: isSelected ? Colors.white : theme.textTheme.bodySmall?.color,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSortOptions(BuildContext context) {
    return Wrap(
      spacing: AppSizes.p8.w,
      runSpacing: AppSizes.p8.h,
      children: DebtSortBy.values.map(
        (sort) => _buildFilterChip(
          context: context,
          label: sort.label,
          isSelected: _sortBy == sort,
          onTap: () => setState(() {
            _sortBy = _sortBy == sort ? null : sort;
          }),
        ),
      ).toList(),
    );
  }

  Widget _buildActions(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.p16.w),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _clearFilters,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: AppSizes.p12.h),
                  side: BorderSide(color: borderColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
                  ),
                ),
                child: Text(
                  'finance_clear_button'.tr(),
                  style: AppTextStyles.labelLarge.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
              ),
            ),
            SizedBox(width: AppSizes.p12.w),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  padding: EdgeInsets.symmetric(vertical: AppSizes.p12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
                  ),
                ),
                child: Text(
                  'finance_apply_button'.tr(),
                  style: AppTextStyles.labelLarge.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _selectedStatus = null;
      _selectedLatenessRange = null;
      _sortBy = null;
    });
  }

  void _applyFilters() {
    final filters = DebtFilterParams(
      status: _selectedStatus,
      latenessRange: _selectedLatenessRange,
      sortBy: _sortBy,
    );
    widget.onApply(filters);
    context.pop();
  }
}
