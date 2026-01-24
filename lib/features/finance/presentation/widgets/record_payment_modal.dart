import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../presentation/widgets/custom_snacbar.dart';
import '../../data/models/payment.dart';
import '../../data/models/record_payment_request.dart';

/// Modal for recording a new payment
class RecordPaymentModal extends StatefulWidget {
  final int? initialContractId;
  final String? initialContractNumber;
  final double? remainingBalance;
  final ValueChanged<RecordPaymentRequest> onSubmit;
  final bool isLoading;

  const RecordPaymentModal({
    super.key,
    this.initialContractId,
    this.initialContractNumber,
    this.remainingBalance,
    required this.onSubmit,
    this.isLoading = false,
  });

  /// Show the record payment modal
  static Future<void> show(
    BuildContext context, {
    int? initialContractId,
    String? initialContractNumber,
    double? remainingBalance,
    required ValueChanged<RecordPaymentRequest> onSubmit,
    bool isLoading = false,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RecordPaymentModal(
        initialContractId: initialContractId,
        initialContractNumber: initialContractNumber,
        remainingBalance: remainingBalance,
        onSubmit: onSubmit,
        isLoading: isLoading,
      ),
    );
  }

  @override
  State<RecordPaymentModal> createState() => _RecordPaymentModalState();
}

class _RecordPaymentModalState extends State<RecordPaymentModal> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  final _contractController = TextEditingController();

  int? _selectedContractId;
  String _currency = 'UZS';
  PaymentType _selectedMethod = PaymentType.cash;
  DateTime _paymentDate = DateTime.now();

  final _dateFormat = DateFormat('dd.MM.yyyy');

  @override
  void initState() {
    super.initState();
    _selectedContractId = widget.initialContractId;
    if (widget.initialContractNumber != null) {
      _contractController.text = widget.initialContractNumber!;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    _contractController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildContractField(context),
                      if (widget.remainingBalance != null) ...[
                        SizedBox(height: AppSizes.p8.h),
                        _buildRemainingBalance(context),
                      ],
                      SizedBox(height: AppSizes.p16.h),
                      _buildAmountField(context),
                      SizedBox(height: AppSizes.p16.h),
                      _buildCurrencyToggle(context),
                      SizedBox(height: AppSizes.p16.h),
                      _buildPaymentMethodSection(context),
                      SizedBox(height: AppSizes.p16.h),
                      _buildDateField(context),
                      SizedBox(height: AppSizes.p16.h),
                      _buildNotesField(context),
                      SizedBox(height: AppSizes.p24.h),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(height: 1),
            _buildSubmitButton(context),
          ],
        ),
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
            'finance_record_payment'.tr(),
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

  Widget _buildContractField(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'finance_contract'.tr(),
          style: AppTextStyles.labelMedium.copyWith(
            color: theme.textTheme.bodySmall?.color,
          ),
        ),
        SizedBox(height: AppSizes.p8.h),
        TextFormField(
          controller: _contractController,
          readOnly: widget.initialContractId != null,
          style: AppTextStyles.bodyMedium.copyWith(
            color: theme.textTheme.bodyMedium?.color,
          ),
          decoration: InputDecoration(
            hintText: 'finance_contract_hint'.tr(),
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
            filled: true,
            fillColor: theme.scaffoldBackgroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
              borderSide: BorderSide(color: theme.colorScheme.primary),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSizes.p16.w,
              vertical: AppSizes.p12.h,
            ),
            suffixIcon: widget.initialContractId != null
                ? Icon(
                    Icons.lock_outline_rounded,
                    color: theme.textTheme.bodySmall?.color,
                    size: 20.w,
                  )
                : null,
          ),
          validator: (value) {
            if (_selectedContractId == null &&
                (value == null || value.isEmpty)) {
              return 'finance_contract_required'.tr();
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildRemainingBalance(BuildContext context) {
    final theme = Theme.of(context);
    final formatted = _formatAmount(widget.remainingBalance!);

    return Container(
      padding: EdgeInsets.all(AppSizes.p12.w),
      decoration: BoxDecoration(
        color: AppColors.infoLight,
        borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: AppColors.info,
            size: 20.w,
          ),
          SizedBox(width: AppSizes.p8.w),
          Text(
            'finance_remaining_debt'.tr(),
            style: AppTextStyles.bodySmall.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          Text(
            '$formatted UZS',
            style: AppTextStyles.bodySmall.copyWith(
              color: theme.textTheme.titleMedium?.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountField(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'finance_amount'.tr(),
          style: AppTextStyles.labelMedium.copyWith(
            color: theme.textTheme.bodySmall?.color,
          ),
        ),
        SizedBox(height: AppSizes.p8.h),
        TextFormField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            _ThousandsSeparatorFormatter(),
          ],
          style: AppTextStyles.bodyMedium.copyWith(
            color: theme.textTheme.bodyMedium?.color,
          ),
          decoration: InputDecoration(
            hintText: 'finance_amount_hint'.tr(),
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
            filled: true,
            fillColor: theme.scaffoldBackgroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
              borderSide: BorderSide(color: theme.colorScheme.primary),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSizes.p16.w,
              vertical: AppSizes.p12.h,
            ),
            suffixText: _currency,
            suffixStyle: AppTextStyles.bodyMedium.copyWith(
              color: theme.textTheme.bodySmall?.color,
              fontWeight: FontWeight.w600,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'finance_amount_required'.tr();
            }
            final amount = _parseAmount(value);
            if (amount <= 0) {
              return 'finance_amount_invalid'.tr();
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCurrencyToggle(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Text(
          'finance_currency'.tr(),
          style: AppTextStyles.labelMedium.copyWith(
            color: theme.textTheme.bodySmall?.color,
          ),
        ),
        SizedBox(width: AppSizes.p12.w),
        _buildCurrencyChip(context, 'UZS'),
        SizedBox(width: AppSizes.p8.w),
        _buildCurrencyChip(context, 'USD'),
      ],
    );
  }

  Widget _buildCurrencyChip(BuildContext context, String currency) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final isSelected = _currency == currency;

    return GestureDetector(
      onTap: () => setState(() => _currency = currency),
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
          ),
        ),
        child: Text(
          currency,
          style: AppTextStyles.labelMedium.copyWith(
            color: isSelected ? Colors.white : theme.textTheme.bodySmall?.color,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSection(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'finance_payment_method'.tr(),
          style: AppTextStyles.labelMedium.copyWith(
            color: theme.textTheme.bodySmall?.color,
          ),
        ),
        SizedBox(height: AppSizes.p8.h),
        Wrap(
          spacing: AppSizes.p8.w,
          runSpacing: AppSizes.p8.h,
          children: PaymentType.values.map((method) {
            final isSelected = _selectedMethod == method;
            return GestureDetector(
              onTap: () => setState(() => _selectedMethod = method),
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
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getMethodIcon(method),
                      size: 16.w,
                      color:
                          isSelected ? Colors.white : theme.textTheme.bodySmall?.color,
                    ),
                    SizedBox(width: AppSizes.p8.w),
                    Text(
                      method.label,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: isSelected
                            ? Colors.white
                            : theme.textTheme.bodySmall?.color,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  IconData _getMethodIcon(PaymentType method) {
    return switch (method) {
      PaymentType.cash => Icons.money_rounded,
      PaymentType.card => Icons.credit_card_rounded,
      PaymentType.transfer => Icons.account_balance_rounded,
      PaymentType.akt => Icons.description_rounded,
    };
  }

  Widget _buildDateField(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'finance_date'.tr(),
          style: AppTextStyles.labelMedium.copyWith(
            color: theme.textTheme.bodySmall?.color,
          ),
        ),
        SizedBox(height: AppSizes.p8.h),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.p16.w,
              vertical: AppSizes.p12.h,
            ),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
              border: Border.all(color: borderColor, width: 1),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 20.w,
                  color: theme.textTheme.bodySmall?.color,
                ),
                SizedBox(width: AppSizes.p12.w),
                Text(
                  _dateFormat.format(_paymentDate),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: theme.textTheme.titleMedium?.color,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_drop_down_rounded,
                  color: theme.textTheme.bodySmall?.color,
                  size: 24.w,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _paymentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
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
      setState(() => _paymentDate = picked);
    }
  }

  Widget _buildNotesField(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'finance_notes'.tr(),
          style: AppTextStyles.labelMedium.copyWith(
            color: theme.textTheme.bodySmall?.color,
          ),
        ),
        SizedBox(height: AppSizes.p8.h),
        TextFormField(
          controller: _notesController,
          maxLines: 3,
          style: AppTextStyles.bodyMedium.copyWith(
            color: theme.textTheme.bodyMedium?.color,
          ),
          decoration: InputDecoration(
            hintText: 'finance_notes_hint'.tr(),
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
            filled: true,
            fillColor: theme.scaffoldBackgroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
              borderSide: BorderSide(color: theme.colorScheme.primary),
            ),
            contentPadding: EdgeInsets.all(AppSizes.p16.w),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.p16.w),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: widget.isLoading ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              disabledBackgroundColor: theme.colorScheme.primary.withValues(alpha: 0.5),
              padding: EdgeInsets.symmetric(vertical: AppSizes.p16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
              ),
            ),
            child: widget.isLoading
                ? SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    'finance_submit'.tr(),
                    style: AppTextStyles.labelLarge.copyWith(
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final contractId = _selectedContractId ??
        int.tryParse(_contractController.text.replaceAll(RegExp(r'\D'), ''));

    if (contractId == null) {
      CustomSnacbar.show(
        context,
        text: 'finance_contract_required'.tr(),
        isError: true,
      );
      return;
    }

    final amount = _parseAmount(_amountController.text);

    final request = RecordPaymentRequest(
      contractId: contractId,
      amount: amount,
      currency: _currency,
      method: _selectedMethod,
      paymentDate: _paymentDate,
      notes: _notesController.text.trim().isNotEmpty
          ? _notesController.text.trim()
          : null,
    );

    widget.onSubmit(request);
  }

  double _parseAmount(String text) {
    final cleanText = text.replaceAll(RegExp(r'[^\d]'), '');
    return double.tryParse(cleanText) ?? 0;
  }

  String _formatAmount(double amount) {
    final formatter = NumberFormat('#,###', 'en_US');
    return formatter.format(amount).replaceAll(',', ' ');
  }
}

/// Text input formatter for thousands separators
class _ThousandsSeparatorFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    final cleanText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanText.isEmpty) return const TextEditingValue();

    final number = int.tryParse(cleanText);
    if (number == null) return oldValue;

    final formatted = NumberFormat('#,###', 'en_US')
        .format(number)
        .replaceAll(',', ' ');

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
