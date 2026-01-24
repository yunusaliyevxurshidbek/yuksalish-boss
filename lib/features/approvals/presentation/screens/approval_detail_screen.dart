import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/number_extensions.dart';
import '../widgets/approval_detail/approval_detail.dart';

/// Approval detail screen.
///
/// Shows detailed information about a specific approval request.
class ApprovalDetailScreen extends StatelessWidget {
  final String approvalId;

  const ApprovalDetailScreen({
    super.key,
    required this.approvalId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('approvals_detail_title'.tr(), style: AppTextStyles.h4),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: AppSizes.p32.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSizes.p16.h),
            ApprovalDetailHeader(
              approvalId: approvalId,
              title: 'approvals_request_type_payment'.tr(),
              amount: 125000000,
            ),
            SizedBox(height: AppSizes.p24.h),
            ApprovalDetailInfoSection(
              title: 'approvals_request_info'.tr(),
              rows: [
                ApprovalDetailRow('approvals_request_type'.tr(), 'approvals_request_type_payment'.tr()),
                ApprovalDetailRow('approvals_requester'.tr(), 'Aliyev Jasur (Sotuvchi)'),
                ApprovalDetailRow('approvals_created'.tr(), '15.01.2024, 14:30'),
                ApprovalDetailRow('approvals_deadline'.tr(), '17.01.2024 gacha'),
              ],
            ),
            SizedBox(height: AppSizes.p24.h),
            ApprovalDetailClientCard(
              name: 'Jasur Aliyev',
              phone: '+998 90 123 45 67',
              initials: 'JA',
              onCall: () {},
            ),
            SizedBox(height: AppSizes.p24.h),
            ApprovalDetailInfoSection(
              title: 'approvals_object_info'.tr(),
              rows: [
                ApprovalDetailRow('approvals_project'.tr(), 'Yuksalish Tower'),
                ApprovalDetailRow('approvals_block'.tr(), 'A'),
                ApprovalDetailRow('approvals_apartment'.tr(), '#412'),
                ApprovalDetailRow('approvals_area'.tr(), '72.5 m²'),
                ApprovalDetailRow('approvals_contract_amount'.tr(), 450000000.currencyShort),
                ApprovalDetailRow('approvals_paid'.tr(), 325000000.currencyShort),
                ApprovalDetailRow('approvals_remaining'.tr(), 125000000.currencyShort),
              ],
            ),
            SizedBox(height: AppSizes.p24.h),
            ApprovalDetailHistory(
              items: [
                ApprovalHistoryItem(
                  title: 'approvals_history_created'.tr(),
                  subtitle: 'Aliyev Jasur tomonidan',
                  time: '15.01.2024, 14:30',
                ),
                ApprovalHistoryItem(
                  title: 'approvals_history_accountant_checked'.tr(),
                  subtitle: 'approvals_history_documents_complete'.tr(),
                  time: '15.01.2024, 15:45',
                ),
                ApprovalHistoryItem(
                  title: 'approvals_history_sent_to_ceo'.tr(),
                  subtitle: 'approvals_status_pending'.tr(),
                  time: '15.01.2024, 16:00',
                  isPending: true,
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: ApprovalDetailActions(
        onApprove: () => ApprovalDetailActions.showConfirmDialog(context, isApprove: true),
        onReject: () => ApprovalDetailActions.showConfirmDialog(context, isApprove: false),
      ),
    );
  }
}
