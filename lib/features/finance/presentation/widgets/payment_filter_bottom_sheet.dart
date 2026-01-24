import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/payment.dart';
import '../../data/models/payment_filter_params.dart';

/// Bottom sheet for filtering payments
class PaymentFilterBottomSheet extends StatefulWidget {
  final PaymentFilterParams initialFilters;
  final ValueChanged<PaymentFilterParams> onApply;

  const PaymentFilterBottomSheet({
    super.key,
    required this.initialFilters,
    required this.onApply,
  });

  /// Show the filter bottom sheet
  static Future<void> show(
    BuildContext context, {
    required PaymentFilterParams initialFilters,
    required ValueChanged<PaymentFilterParams> onApply,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PaymentFilterBottomSheet(
        initialFilters: initialFilters,
        onApply: onApply,
      ),
    );
  }

  @override
  State<PaymentFilterBottomSheet> createState() =>
      _PaymentFilterBottomSheetState();
}

class _PaymentFilterBottomSheetState extends State<PaymentFilterBottomSheet> {
  late PaymentStatus? _selectedStatus;
  late PaymentType? _selectedMethod;
  late DateTime? _dateFrom;
  late DateTime? _dateTo;
  late PaymentSortBy? _sortBy;

  final _dateFormat = DateFormat('dd.MM.yyyy');

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.initialFilters.status;
    _selectedMethod = widget.initialFilters.method;
    _dateFrom = widget.initialFilters.dateFrom;
    _dateTo = widget.initialFilters.dateTo;
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
                  _buildSection(context, 'finance_payment_type'.tr(), _buildMethodChips(context)),
                  SizedBox(height: AppSizes.p20.h),
                  _buildSection(context, 'finance_date_range'.tr(), _buildDateRange(context)),
                  SizedBox(height: AppSizes.p20.h),
                  _buildSection(context, 'finance_filter_sort'.tr(), _buildSortOptions(context)),
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
        ...PaymentStatus.values.map(
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

  Widget _buildMethodChips(BuildContext context) {
    return Wrap(
      spacing: AppSizes.p8.w,
      runSpacing: AppSizes.p8.h,
      children: [
        _buildFilterChip(
          context: context,
          label: 'finance_filter_all'.tr(),
          isSelected: _selectedMethod == null,
          onTap: () => setState(() => _selectedMethod = null),
        ),
        ...PaymentType.values.map(
          (method) => _buildFilterChip(
            context: context,
            label: method.label,
            isSelected: _selectedMethod == method,
            onTap: () => setState(() => _selectedMethod = method),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.p16.w,
          vertical: AppSizes.p8.h,
        ),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : theme.cardColor,
          borderRadius: BorderRadius.circular(AppSizes.radiusFull.r),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : borderColor,
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

  Widget _buildDateRange(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildDateButton(
            context: context,
            label: _dateFrom != null ? _dateFormat.format(_dateFrom!) : 'finance_date_from'.tr(),
            hasValue: _dateFrom != null,
            onTap: () => _selectDate(isFrom: true),
            onClear: _dateFrom != null
                ? () => setState(() => _dateFrom = null)
                : null,
          ),
        ),
        SizedBox(width: AppSizes.p12.w),
        Expanded(
          child: _buildDateButton(
            context: context,
            label: _dateTo != null ? _dateFormat.format(_dateTo!) : 'finance_date_to'.tr(),
            hasValue: _dateTo != null,
            onTap: () => _selectDate(isFrom: false),
            onClear:
                _dateTo != null ? () => setState(() => _dateTo = null) : null,
          ),
        ),
      ],
    );
  }

  Widget _buildDateButton({
    required BuildContext context,
    required String label,
    required bool hasValue,
    required VoidCallback onTap,
    VoidCallback? onClear,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.p12.w,
          vertical: AppSizes.p12.h,
        ),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
          border: Border.all(
            color: hasValue ? theme.colorScheme.primary : borderColor,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 18.w,
              color: hasValue ? theme.colorScheme.primary : theme.textTheme.bodySmall?.color,
            ),
            SizedBox(width: AppSizes.p8.w),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: hasValue ? theme.textTheme.titleMedium?.color : theme.textTheme.bodySmall?.color,
                ),
              ),
            ),
            if (onClear != null)
              GestureDetector(
                onTap: onClear,
                child: Icon(
                  Icons.close_rounded,
                  size: 18.w,
                  color: theme.textTheme.bodySmall?.color,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate({required bool isFrom}) async {
    final initialDate = isFrom
        ? (_dateFrom ?? DateTime.now())
        : (_dateTo ?? DateTime.now());
    final firstDate = DateTime(2020);
    final lastDate = DateTime.now().add(const Duration(days: 365));

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isFrom) {
          _dateFrom = picked;
          // Ensure dateTo is not before dateFrom
          if (_dateTo != null && _dateTo!.isBefore(picked)) {
            _dateTo = picked;
          }
        } else {
          _dateTo = picked;
          // Ensure dateFrom is not after dateTo
          if (_dateFrom != null && _dateFrom!.isAfter(picked)) {
            _dateFrom = picked;
          }
        }
      });
    }
  }

  Widget _buildSortOptions(BuildContext context) {
    return Wrap(
      spacing: AppSizes.p8.w,
      runSpacing: AppSizes.p8.h,
      children: PaymentSortBy.values.map(
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
      _selectedMethod = null;
      _dateFrom = null;
      _dateTo = null;
      _sortBy = null;
    });
  }

  void _applyFilters() {
    final filters = PaymentFilterParams(
      status: _selectedStatus,
      method: _selectedMethod,
      dateFrom: _dateFrom,
      dateTo: _dateTo,
      sortBy: _sortBy,
    );
    widget.onApply(filters);
    context.pop();
  }
}
