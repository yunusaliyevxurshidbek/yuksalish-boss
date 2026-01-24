import 'package:flutter/material.dart';

/// Data point for sales dynamics chart.
class SalesDynamicsPoint {
  final String label;
  final double sales;
  final double target;

  const SalesDynamicsPoint({
    required this.label,
    required this.sales,
    required this.target,
  });
}

/// KPI metric card data.
class KpiMetric {
  final IconData icon;
  final String label;
  final String value;
  final String change;
  final bool isPositive;
  final Color accentColor;

  const KpiMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.change,
    required this.isPositive,
    required this.accentColor,
  });
}

/// Transaction status enum.
enum TransactionStatus { sold, reserved }

/// Sales transaction data.
class SalesTransaction {
  final String unit;
  final String client;
  final String price;
  final String date;
  final TransactionStatus status;

  const SalesTransaction({
    required this.unit,
    required this.client,
    required this.price,
    required this.date,
    required this.status,
  });
}
