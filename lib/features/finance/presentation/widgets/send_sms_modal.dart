import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/debt.dart';
import '../../data/models/send_sms_request.dart';

/// Modal for sending SMS reminder to debtor
class SendSmsModal extends StatefulWidget {
  final Debt debt;
  final ValueChanged<SendSmsRequest> onSend;
  final bool isSending;

  const SendSmsModal({
    super.key,
    required this.debt,
    required this.onSend,
    this.isSending = false,
  });

  /// Show the SMS modal
  static Future<void> show(
    BuildContext context, {
    required Debt debt,
    required ValueChanged<SendSmsRequest> onSend,
    bool isSending = false,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SendSmsModal(
        debt: debt,
        onSend: onSend,
        isSending: isSending,
      ),
    );
  }

  @override
  State<SendSmsModal> createState() => _SendSmsModalState();
}

class _SendSmsModalState extends State<SendSmsModal> {
  final _messageController = TextEditingController();
  int? _selectedTemplateIndex;

  // Predefined SMS templates
  static const List<_SmsTemplateItem> _templates = [
    _SmsTemplateItem(
      name: "finance_sms_reminder",
      message: "finance_sms_debt_reminder",
    ),
    _SmsTemplateItem(
      name: 'finance_sms_overdue',
      message: "finance_sms_overdue_reminder",
    ),
    _SmsTemplateItem(
      name: 'finance_sms_critical',
      message: "finance_sms_critical_reminder",
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
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
                    _buildRecipientInfo(context),
                    SizedBox(height: AppSizes.p20.h),
                    _buildTemplateSection(context),
                    SizedBox(height: AppSizes.p20.h),
                    _buildMessageField(context),
                    SizedBox(height: AppSizes.p24.h),
                  ],
                ),
              ),
            ),
            const Divider(height: 1),
            _buildSendButton(context),
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
            'finance_sms_title'.tr(),
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

  Widget _buildRecipientInfo(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.p16.w),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                _getInitials(widget.debt.clientName),
                style: AppTextStyles.labelLarge.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(width: AppSizes.p12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.debt.clientName,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: theme.textTheme.titleMedium?.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppSizes.p4.h),
                Row(
                  children: [
                    Icon(
                      Icons.phone_rounded,
                      size: 14.w,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                    SizedBox(width: AppSizes.p4.w),
                    Text(
                      widget.debt.formattedPhone,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.p8.w,
              vertical: AppSizes.p4.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.errorLight,
              borderRadius: BorderRadius.circular(AppSizes.radiusFull.r),
            ),
            child: Text(
              widget.debt.formattedRemainingAmount,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  Widget _buildTemplateSection(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'finance_select_template'.tr(),
          style: AppTextStyles.labelLarge.copyWith(
            color: theme.textTheme.titleMedium?.color,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppSizes.p12.h),
        ...List.generate(_templates.length, (index) {
          final template = _templates[index];
          final isSelected = _selectedTemplateIndex == index;
          return Padding(
            padding: EdgeInsets.only(bottom: AppSizes.p8.h),
            child: GestureDetector(
              onTap: () => _selectTemplate(index),
              child: Container(
                padding: EdgeInsets.all(AppSizes.p12.w),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryLight : theme.cardColor,
                  borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
                  border: Border.all(
                    color: isSelected ? theme.colorScheme.primary : borderColor,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected
                          ? Icons.check_circle_rounded
                          : Icons.circle_outlined,
                      size: 20.w,
                      color:
                          isSelected ? theme.colorScheme.primary : theme.textTheme.bodySmall?.color,
                    ),
                    SizedBox(width: AppSizes.p12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            template.name.tr(),
                            style: AppTextStyles.labelMedium.copyWith(
                              color: theme.textTheme.titleMedium?.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: AppSizes.p4.h),
                          Text(
                            template.message.tr(),
                            style: AppTextStyles.caption.copyWith(
                              color: theme.textTheme.bodySmall?.color,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  void _selectTemplate(int index) {
    setState(() {
      _selectedTemplateIndex = index;
      // Fill in the template with actual values
      final template = _templates[index];
      _messageController.text = _fillTemplate(template.message);
    });
  }

  String _fillTemplate(String template) {
    // Translate the template key first
    String translatedTemplate = template.tr();
    return translatedTemplate
        .replaceAll('{name}', widget.debt.clientName)
        .replaceAll('{contract}', widget.debt.contractNumber)
        .replaceAll('{amount}', widget.debt.formattedRemainingAmount)
        .replaceAll('{days}', widget.debt.overdueDays.toString());
  }

  Widget _buildMessageField(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'finance_message_text'.tr(),
          style: AppTextStyles.labelLarge.copyWith(
            color: theme.textTheme.titleMedium?.color,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppSizes.p12.h),
        TextFormField(
          controller: _messageController,
          maxLines: 5,
          maxLength: 500,
          style: AppTextStyles.bodyMedium.copyWith(
            color: theme.textTheme.bodyMedium?.color,
          ),
          decoration: InputDecoration(
            hintText: 'finance_sms_hint'.tr(),
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
            counterStyle: AppTextStyles.caption.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSendButton(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.p16.w),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed:
                widget.isSending || _messageController.text.trim().isEmpty
                    ? null
                    : _send,
            icon: widget.isSending
                ? SizedBox(
                    width: 18.w,
                    height: 18.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Icon(Icons.send_rounded, size: 18.w),
            label: Text(widget.isSending ? 'finance_sending'.tr() : 'finance_send_sms'.tr()),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: theme.colorScheme.primary.withValues(alpha: 0.5),
              padding: EdgeInsets.symmetric(vertical: AppSizes.p16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _send() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    final request = SendSmsRequest(
      debtId: widget.debt.id,
      phoneNumber: widget.debt.phoneNumber,
      message: message,
      templateId: _selectedTemplateIndex != null
          ? _selectedTemplateIndex! + 1
          : null, // Template IDs are 1-indexed
    );

    widget.onSend(request);
  }
}

class _SmsTemplateItem {
  final String name;
  final String message;

  const _SmsTemplateItem({
    required this.name,
    required this.message,
  });
}
