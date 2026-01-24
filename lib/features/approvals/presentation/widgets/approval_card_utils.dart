import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/approval.dart';

/// Returns color based on approval type.
Color getApprovalTypeColor(ApprovalType type) {
  return switch (type) {
    ApprovalType.purchase => AppColors.info,
    ApprovalType.payment => AppColors.success,
    ApprovalType.hr => AppColors.primary,
    ApprovalType.budget => AppColors.warning,
    ApprovalType.discount => AppColors.chartPurple,
  };
}

/// Formats amount as currency string.
String formatApprovalCurrency(double amount) {
  final formatter = NumberFormat('#,###', 'uz');
  return '${formatter.format(amount)} UZS';
}
