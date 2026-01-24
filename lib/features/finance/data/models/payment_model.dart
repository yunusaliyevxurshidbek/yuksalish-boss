import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Payment model for displaying payment transactions.
class PaymentModel {
  final String transactionId;
  final String amount;
  final String clientName;
  final String contractInfo;
  final String method;
  final String date;
  final String status;

  const PaymentModel({
    required this.transactionId,
    required this.amount,
    required this.clientName,
    required this.contractInfo,
    required this.method,
    required this.date,
    required this.status,
  });
}

/// Status color configuration.
class StatusColors {
  final Color text;
  final Color background;

  const StatusColors({
    required this.text,
    required this.background,
  });
}

/// Get status colors based on status text.
StatusColors getStatusColor(String status) {
  final normalized = status.toLowerCase();
  if (normalized.contains('bajar') || normalized.contains('success')) {
    return const StatusColors(
      text: AppColors.paymentSuccessText,
      background: AppColors.paymentSuccessBg,
    );
  }
  if (normalized.contains('kutil') || normalized.contains('pending')) {
    return const StatusColors(
      text: AppColors.paymentPendingText,
      background: AppColors.paymentPendingBg,
    );
  }
  if (normalized.contains('rad') ||
      normalized.contains('rejected') ||
      normalized.contains('cancel')) {
    return const StatusColors(
      text: AppColors.paymentRejectedText,
      background: AppColors.paymentRejectedBg,
    );
  }
  return const StatusColors(
    text: AppColors.paymentPendingText,
    background: AppColors.paymentPendingBg,
  );
}
