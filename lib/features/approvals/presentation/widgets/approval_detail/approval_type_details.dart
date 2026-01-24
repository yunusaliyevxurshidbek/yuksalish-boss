import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/models/approval.dart';
import 'approval_detail_row.dart';

/// Details widget for purchase type approvals.
class PurchaseDetails extends StatelessWidget {
  final Approval approval;

  const PurchaseDetails({super.key, required this.approval});

  @override
  Widget build(BuildContext context) {
    final data = approval.data;
    return Column(
      children: [
        ApprovalDetailRow(label: 'Material', value: data['materialName'] ?? '-'),
        ApprovalDetailRow(
          label: 'Miqdori',
          value: '${data['quantity']} ${data['unit']}',
        ),
        ApprovalDetailRow(
          label: 'Narxi',
          value: _formatCurrency(data['unitPrice'] ?? 0),
        ),
        ApprovalDetailRow(
          label: 'Jami',
          value: _formatCurrency(approval.amount),
          isHighlighted: true,
        ),
        const Divider(),
        ApprovalDetailRow(label: 'Loyiha', value: data['project'] ?? '-'),
        ApprovalDetailRow(label: 'Yetkazuvchi', value: data['supplier'] ?? '-'),
      ],
    );
  }

  String _formatCurrency(dynamic amount) {
    final value = (amount is num) ? amount.toDouble() : 0.0;
    final formatter = NumberFormat('#,###', 'uz');
    return '${formatter.format(value)} UZS';
  }
}

/// Details widget for payment type approvals.
class PaymentDetails extends StatelessWidget {
  final Approval approval;

  const PaymentDetails({super.key, required this.approval});

  @override
  Widget build(BuildContext context) {
    final data = approval.data;
    return Column(
      children: [
        ApprovalDetailRow(
          label: 'Summa',
          value: _formatCurrency(approval.amount),
          isHighlighted: true,
        ),
        ApprovalDetailRow(label: 'Kimga', value: data['recipient'] ?? '-'),
        ApprovalDetailRow(label: 'Maqsad', value: data['purpose'] ?? '-'),
        const Divider(),
        ApprovalDetailRow(
          label: 'Hisob-faktura',
          value: data['invoiceNumber'] ?? '-',
        ),
        ApprovalDetailRow(label: 'Bank hisobi', value: data['bankAccount'] ?? '-'),
      ],
    );
  }

  String _formatCurrency(dynamic amount) {
    final value = (amount is num) ? amount.toDouble() : 0.0;
    final formatter = NumberFormat('#,###', 'uz');
    return '${formatter.format(value)} UZS';
  }
}

/// Details widget for HR type approvals.
class HRDetails extends StatelessWidget {
  final Approval approval;

  const HRDetails({super.key, required this.approval});

  @override
  Widget build(BuildContext context) {
    final data = approval.data;
    final isNewEmployee = data['type'] == 'Yangi xodim';
    return Column(
      children: [
        ApprovalDetailRow(label: 'Xodim', value: data['employeeName'] ?? '-'),
        ApprovalDetailRow(label: 'Lavozim', value: data['position'] ?? '-'),
        ApprovalDetailRow(label: "Bo'lim", value: data['department'] ?? '-'),
        ApprovalDetailRow(
          label: isNewEmployee ? 'Maosh' : 'Yangi maosh',
          value: _formatCurrency(approval.amount),
          isHighlighted: true,
        ),
        if (!isNewEmployee)
          ApprovalDetailRow(
            label: 'Hozirgi maosh',
            value: _formatCurrency(data['previousSalary'] ?? 0),
          ),
        const Divider(),
        ApprovalDetailRow(label: 'Boshlanish', value: data['startDate'] ?? '-'),
        ApprovalDetailRow(label: 'Turi', value: data['type'] ?? '-'),
      ],
    );
  }

  String _formatCurrency(dynamic amount) {
    final value = (amount is num) ? amount.toDouble() : 0.0;
    final formatter = NumberFormat('#,###', 'uz');
    return '${formatter.format(value)} UZS';
  }
}

/// Details widget for budget type approvals.
class BudgetDetails extends StatelessWidget {
  final Approval approval;

  const BudgetDetails({super.key, required this.approval});

  @override
  Widget build(BuildContext context) {
    final data = approval.data;
    return Column(
      children: [
        ApprovalDetailRow(label: 'Loyiha', value: data['project'] ?? '-'),
        ApprovalDetailRow(
          label: "Qo'shimcha",
          value: _formatCurrency(approval.amount),
          isHighlighted: true,
        ),
        ApprovalDetailRow(
          label: 'Hozirgi byudjet',
          value: _formatCurrency(data['currentBudget'] ?? 0),
        ),
        ApprovalDetailRow(
          label: 'Yangi byudjet',
          value: _formatCurrency(data['newBudget'] ?? 0),
        ),
        const Divider(),
        ApprovalDetailRow(label: 'Sabab', value: data['reason'] ?? '-'),
        ApprovalDetailRow(label: 'Kategoriya', value: data['category'] ?? '-'),
      ],
    );
  }

  String _formatCurrency(dynamic amount) {
    final value = (amount is num) ? amount.toDouble() : 0.0;
    final formatter = NumberFormat('#,###', 'uz');
    return '${formatter.format(value)} UZS';
  }
}

/// Details widget for discount type approvals.
class DiscountDetails extends StatelessWidget {
  final Approval approval;

  const DiscountDetails({super.key, required this.approval});

  @override
  Widget build(BuildContext context) {
    final data = approval.data;
    return Column(
      children: [
        ApprovalDetailRow(label: 'Mijoz', value: data['clientName'] ?? '-'),
        ApprovalDetailRow(
          label: 'Kvartira',
          value: '${data['apartment']}, ${data['project']}',
        ),
        ApprovalDetailRow(
          label: 'Asl narx',
          value: _formatCurrency(data['originalPrice'] ?? 0),
        ),
        ApprovalDetailRow(
          label: 'Chegirma',
          value: '${data['discountPercent']}% (${_formatCurrency(approval.amount)})',
          isHighlighted: true,
        ),
        ApprovalDetailRow(
          label: 'Yakuniy narx',
          value: _formatCurrency(data['finalPrice'] ?? 0),
        ),
        const Divider(),
        ApprovalDetailRow(label: 'Sabab', value: data['reason'] ?? '-'),
      ],
    );
  }

  String _formatCurrency(dynamic amount) {
    final value = (amount is num) ? amount.toDouble() : 0.0;
    final formatter = NumberFormat('#,###', 'uz');
    return '${formatter.format(value)} UZS';
  }
}
