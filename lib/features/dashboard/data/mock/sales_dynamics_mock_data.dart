import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../models/sales_dynamics_models.dart';

/// Mock data for sales dynamics page.
class SalesDynamicsMockData {
  static const List<String> periods = ['Haftalik', 'Oylik', 'Yillik'];

  static const List<SalesDynamicsPoint> chartData = [
    SalesDynamicsPoint(label: 'Yan', sales: 120, target: 140),
    SalesDynamicsPoint(label: 'Fev', sales: 160, target: 150),
    SalesDynamicsPoint(label: 'Mar', sales: 180, target: 170),
    SalesDynamicsPoint(label: 'Apr', sales: 140, target: 160),
    SalesDynamicsPoint(label: 'May', sales: 200, target: 190),
    SalesDynamicsPoint(label: 'Iyn', sales: 220, target: 210),
    SalesDynamicsPoint(label: 'Iyl', sales: 210, target: 220),
    SalesDynamicsPoint(label: 'Avg', sales: 240, target: 230),
    SalesDynamicsPoint(label: 'Sen', sales: 190, target: 200),
    SalesDynamicsPoint(label: 'Okt', sales: 230, target: 240),
    SalesDynamicsPoint(label: 'Noy', sales: 260, target: 250),
    SalesDynamicsPoint(label: 'Dek', sales: 280, target: 260),
  ];

  static const List<KpiMetric> kpiMetrics = [
    KpiMetric(
      icon: Icons.payments_outlined,
      label: "O'rtacha chek",
      value: '48.2 mln',
      change: '+12.4%',
      isPositive: true,
      accentColor: AppColors.salesPrimary,
    ),
    KpiMetric(
      icon: Icons.star_outline,
      label: "Eng ko'p sotilgan",
      value: 'A-42',
      change: '+6.2%',
      isPositive: true,
      accentColor: AppColors.salesSuccess,
    ),
    KpiMetric(
      icon: Icons.warning_amber_rounded,
      label: 'Bekor qilinganlar',
      value: '18 ta',
      change: '-3.8%',
      isPositive: false,
      accentColor: AppColors.salesWarning,
    ),
    KpiMetric(
      icon: Icons.timeline_rounded,
      label: 'Konversiya',
      value: '32%',
      change: '+2.1%',
      isPositive: true,
      accentColor: AppColors.salesPrimary,
    ),
  ];

  static const List<SalesTransaction> transactions = [
    SalesTransaction(
      unit: 'A-42',
      client: 'Dilshod Ergashev',
      price: '450 mln UZS',
      date: '12 Okt, 2025',
      status: TransactionStatus.sold,
    ),
    SalesTransaction(
      unit: 'B-18',
      client: 'Nargiza Karimova',
      price: '380 mln UZS',
      date: '10 Okt, 2025',
      status: TransactionStatus.reserved,
    ),
    SalesTransaction(
      unit: 'C-07',
      client: 'Abbos Tursunov',
      price: '510 mln UZS',
      date: '08 Okt, 2025',
      status: TransactionStatus.sold,
    ),
    SalesTransaction(
      unit: 'D-23',
      client: 'Sevara Usmonova',
      price: '420 mln UZS',
      date: '05 Okt, 2025',
      status: TransactionStatus.reserved,
    ),
  ];
}
