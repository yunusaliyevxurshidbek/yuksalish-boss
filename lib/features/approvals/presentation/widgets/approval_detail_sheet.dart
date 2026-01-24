import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../presentation/widgets/custom_snacbar.dart';
import '../../data/models/approval.dart';
import 'approval_detail/approval_action_buttons.dart';
import 'approval_detail/approval_attachments_section.dart';
import 'approval_detail/approval_comment_section.dart';
import 'approval_detail/approval_meta_section.dart';
import 'approval_detail/approval_reject_confirmation.dart';
import 'approval_detail/approval_sheet_handle.dart';
import 'approval_detail/approval_sheet_header.dart';
import 'approval_detail/approval_type_details.dart';
import 'approval_detail/approval_urgent_badge.dart';

/// Bottom sheet for showing approval details with actions.
class ApprovalDetailSheet extends StatefulWidget {
  final Approval approval;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final Function(String)? onApproveWithComment;
  final Function(String)? onRejectWithComment;
  final bool isProcessing;

  const ApprovalDetailSheet({
    super.key,
    required this.approval,
    this.onApprove,
    this.onReject,
    this.onApproveWithComment,
    this.onRejectWithComment,
    this.isProcessing = false,
  });

  /// Show the detail sheet.
  static Future<void> show(
    BuildContext context, {
    required Approval approval,
    VoidCallback? onApprove,
    VoidCallback? onReject,
    Function(String)? onApproveWithComment,
    Function(String)? onRejectWithComment,
    bool isProcessing = false,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ApprovalDetailSheet(
        approval: approval,
        onApprove: onApprove,
        onReject: onReject,
        onApproveWithComment: onApproveWithComment,
        onRejectWithComment: onRejectWithComment,
        isProcessing: isProcessing,
      ),
    );
  }

  @override
  State<ApprovalDetailSheet> createState() => _ApprovalDetailSheetState();
}

class _ApprovalDetailSheetState extends State<ApprovalDetailSheet> {
  final _commentController = TextEditingController();
  bool _showRejectConfirm = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusXL.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ApprovalSheetHandle(),
          ApprovalSheetHeader(
            typeLabel: widget.approval.typeLabel,
            onClose: () => context.pop(),
          ),
          const Divider(height: 1),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSizes.p16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.approval.isUrgent) ...[
                    const ApprovalUrgentBadge(),
                    SizedBox(height: AppSizes.p16.h),
                  ],
                  _buildDetailsByType(),
                  SizedBox(height: AppSizes.p16.h),
                  ApprovalMetaSection(
                    requestedBy: widget.approval.requestedBy,
                    createdAt: widget.approval.createdAt,
                  ),
                  if (_hasAttachments()) ...[
                    SizedBox(height: AppSizes.p16.h),
                    ApprovalAttachmentsSection(
                      count: widget.approval.data['attachments'] ?? 0,
                    ),
                  ],
                  SizedBox(height: AppSizes.p16.h),
                  ApprovalCommentSection(controller: _commentController),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildDetailsByType() {
    return switch (widget.approval.type) {
      ApprovalType.purchase => PurchaseDetails(approval: widget.approval),
      ApprovalType.payment => PaymentDetails(approval: widget.approval),
      ApprovalType.hr => HRDetails(approval: widget.approval),
      ApprovalType.budget => BudgetDetails(approval: widget.approval),
      ApprovalType.discount => DiscountDetails(approval: widget.approval),
    };
  }

  bool _hasAttachments() {
    final attachments = widget.approval.data['attachments'];
    return attachments != null && attachments > 0;
  }

  Widget _buildActions() {
    if (_showRejectConfirm) {
      return ApprovalRejectConfirmation(
        onCancel: () => setState(() => _showRejectConfirm = false),
        onConfirm: _handleReject,
      );
    }

    return ApprovalActionButtons(
      isProcessing: widget.isProcessing,
      onApprove: _handleApprove,
      onReject: () => setState(() => _showRejectConfirm = true),
    );
  }

  void _handleApprove() {
    final comment = _commentController.text.trim();
    if (comment.isNotEmpty && widget.onApproveWithComment != null) {
      widget.onApproveWithComment!(comment);
    } else {
      widget.onApprove?.call();
    }
    context.pop();
  }

  void _handleReject() {
    final comment = _commentController.text.trim();
    if (comment.isEmpty) {
      CustomSnacbar.show(
        context,
        text: 'Iltimos, rad etish sababini kiriting',
        isError: true,
      );
      return;
    }
    widget.onRejectWithComment?.call(comment);
    context.pop();
  }
}
