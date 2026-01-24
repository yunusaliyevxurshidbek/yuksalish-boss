import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../data/models/analytics_apartment.dart';
import '../../data/models/analytics_client.dart';
import '../../data/models/analytics_contract.dart';
import '../../data/models/analytics_payment.dart';
import '../../data/models/analytics_period.dart';
import '../../data/models/analytics_project.dart';
import '../../data/models/lead_source.dart';
import '../../data/models/sales_trend.dart';
import '../bloc/analytics_bloc.dart';
import '../utils/analytics_utils.dart';
import '../widgets/analytics_kpi_list.dart';
import '../widgets/analytics_top_managers_section.dart';
import '../widgets/contracts_line_chart.dart';
import '../widgets/inventory_stacked_chart.dart';
import '../widgets/inventory_detail_section.dart';
import '../widgets/payments_bar_chart.dart';

class AnalyticsViewModel {
  final AnalyticsPeriod period;
  final List<KpiCardData> kpiCards;
  final List<SalesTrend> salesTrend;
  final List<LeadSource> leadSources;
  final List<ManagerPerformanceData> topManagers;
  final List<InventoryBarData> inventoryData;
  final InventoryDetailData? inventoryDetail;
  final List<PaymentsChartData> paymentsChart;
  final int paymentsCount;
  final double paymentsTotal;
  final List<ContractsDayData> contractsChart;
  final double paidAmount;
  final double pendingAmount;
  final double availableAmount;
  final String selectedProjectId;
  final List<AnalyticsProject> projects;
  final DateTime paymentsFrom;
  final DateTime paymentsTo;
  final String? lastUpdatedLabel;

  const AnalyticsViewModel({
    required this.period,
    required this.kpiCards,
    required this.salesTrend,
    required this.leadSources,
    required this.topManagers,
    required this.inventoryData,
    required this.inventoryDetail,
    required this.paymentsChart,
    required this.paymentsCount,
    required this.paymentsTotal,
    required this.contractsChart,
    required this.paidAmount,
    required this.pendingAmount,
    required this.availableAmount,
    required this.selectedProjectId,
    required this.projects,
    required this.paymentsFrom,
    required this.paymentsTo,
    required this.lastUpdatedLabel,
  });

  factory AnalyticsViewModel.fromState(AnalyticsState state) {
    final completedContracts =
        state.contracts.where((contract) => contract.isCompleted).toList();
    final totalCompletedAmount = completedContracts.fold<double>(
      0,
      (sum, contract) => sum + contract.totalAmount,
    );
    final averageDealValue = completedContracts.isEmpty
        ? 0
        : totalCompletedAmount / completedContracts.length;

    final kpiCards = _buildKpiCards(state, averageDealValue);
    final salesTrend = _buildSalesTrend(state);
    final leadSources = _buildLeadSources(state.clients);
    final topManagers = _buildManagerPerformance(completedContracts);
    final inventoryData = _buildInventory(state.projects, state.apartments);
    final inventoryDetail = _buildInventoryDetail(state.apartments);

    final normalizedRange = _normalizeRange(state.paymentsFrom, state.paymentsTo);
    final paymentsChart = _buildPaymentsChart(
      payments: state.payments,
      from: normalizedRange.$1,
      to: normalizedRange.$2,
    );
    final paymentsTotals =
        _calculatePaymentsTotals(state.payments, normalizedRange.$1, normalizedRange.$2);

    final contractsChart = _buildContractsChart(state.contracts);

    final revenueBreakdown = _buildRevenueBreakdown(
      contracts: state.contracts,
      apartments: state.apartments,
      selectedProjectId: state.selectedProjectId,
    );

    return AnalyticsViewModel(
      period: state.selectedPeriod,
      kpiCards: kpiCards,
      salesTrend: salesTrend,
      leadSources: leadSources,
      topManagers: topManagers,
      inventoryData: inventoryData,
      inventoryDetail: inventoryDetail,
      paymentsChart: paymentsChart,
      paymentsCount: paymentsTotals.count,
      paymentsTotal: paymentsTotals.total,
      contractsChart: contractsChart,
      paidAmount: revenueBreakdown.paid,
      pendingAmount: revenueBreakdown.pending,
      availableAmount: revenueBreakdown.available,
      selectedProjectId: state.selectedProjectId,
      projects: state.projects,
      paymentsFrom: normalizedRange.$1,
      paymentsTo: normalizedRange.$2,
      lastUpdatedLabel: _buildLastUpdatedLabel(state.lastUpdated),
    );
  }

  static List<KpiCardData> _buildKpiCards(AnalyticsState state, num averageDealValue) {
    return [
      KpiCardData(
        title: 'analytics_kpi_total_revenue'.tr(),
        subtitle: 'analytics_kpi_year_to_date'.tr(),
        value: formatCurrency(state.stats.totalRevenue),
        icon: Icons.account_balance_wallet_rounded,
        color: AnalyticsColors.success,
        trend: state.stats.revenueTrend,
      ),
      KpiCardData(
        title: 'analytics_kpi_closed_deals'.tr(),
        value: state.stats.completedContracts.toString(),
        icon: Icons.verified_rounded,
        color: const Color(0xFF14B8A6),
        trend: state.stats.apartmentsTrend,
      ),
      KpiCardData(
        title: 'analytics_kpi_average_deal'.tr(),
        value: formatCurrency(averageDealValue),
        icon: Icons.trending_up_rounded,
        color: AnalyticsColors.info,
      ),
      KpiCardData(
        title: 'analytics_kpi_overdue_payments'.tr(),
        value: formatCurrency(state.stats.overduePayments),
        icon: Icons.warning_amber_rounded,
        color: AnalyticsColors.danger,
        isNegativeBetter: true,
      ),
      KpiCardData(
        title: 'analytics_kpi_active_leads'.tr(),
        value: state.stats.activeLeads.toString(),
        icon: Icons.people_alt_rounded,
        color: const Color(0xFF8B5CF6),
        trend: state.stats.leadsTrend,
      ),
      KpiCardData(
        title: 'analytics_kpi_conversion_rate'.tr(),
        value: '${state.stats.conversionRate.toStringAsFixed(1)}%',
        icon: Icons.pie_chart_rounded,
        color: const Color(0xFFF97316),
        trend: state.stats.conversionTrend,
      ),
    ];
  }

  static List<SalesTrend> _buildSalesTrend(AnalyticsState state) {
    return state.stats.monthlySales
        .map(
          (item) => SalesTrend(
            month: item.name,
            amount: item.amount,
            count: item.contractsCount,
          ),
        )
        .toList();
  }

  static List<LeadSource> _buildLeadSources(List<AnalyticsClient> clients) {
    if (clients.isEmpty) return const [];

    final counts = <String, int>{};
    for (final client in clients) {
      final key = client.source.isNotEmpty ? client.source.toLowerCase() : 'other';
      counts[key] = (counts[key] ?? 0) + 1;
    }

    final total = clients.length;
    final sources = counts.entries.map((entry) {
      final translationKey = leadSourceTranslationKeys[entry.key] ?? 'leads_source_other';
      final label = translationKey.tr();
      final color = leadSourceColors[entry.key] ?? AnalyticsColors.primary;
      return LeadSource.fromCount(
        name: label,
        count: entry.value,
        totalCount: total,
        color: color,
      );
    }).toList();

    sources.sort((a, b) => b.count.compareTo(a.count));
    return sources;
  }

  static List<ManagerPerformanceData> _buildManagerPerformance(
    List<AnalyticsContract> contracts,
  ) {
    if (contracts.isEmpty) return const [];

    final stats = <String, ManagerPerformanceData>{};
    for (final contract in contracts) {
      final name =
          (contract.assignedToName?.trim().isNotEmpty ?? false)
              ? contract.assignedToName!.trim()
              : 'analytics_unassigned'.tr();
      final entry = stats.putIfAbsent(
        name,
        () => ManagerPerformanceData(name: name, deals: 0, revenue: 0, rank: 0),
      );
      stats[name] = entry.copyWith(
        deals: entry.deals + 1,
        revenue: entry.revenue + contract.totalAmount,
      );
    }

    final list = stats.values.toList()
      ..sort((a, b) => b.revenue.compareTo(a.revenue));

    return list.take(5).toList().asMap().entries.map((entry) {
      return entry.value.copyWith(rank: entry.key + 1);
    }).toList();
  }

  static List<InventoryBarData> _buildInventory(
    List<AnalyticsProject> projects,
    List<AnalyticsApartment> apartments,
  ) {
    if (projects.isEmpty) return const [];

    final data = projects.map((project) {
      final projectApartments =
          apartments.where((apt) => apt.projectId == project.id).toList();
      return InventoryBarData(
        name: project.name.split(' ').first,
        available:
            projectApartments.where((apt) => apt.status == 'available').length,
        reserved:
            projectApartments.where((apt) => apt.status == 'reserved').length,
        sold: projectApartments.where((apt) => apt.status == 'sold').length,
      );
    }).toList();

    return data.take(5).toList();
  }

  static InventoryDetailData? _buildInventoryDetail(
    List<AnalyticsApartment> apartments,
  ) {
    if (apartments.isEmpty) return null;

    final available = apartments.where((apt) => apt.status == 'available').length;
    final reserved = apartments.where((apt) => apt.status == 'reserved').length;
    final sold = apartments.where((apt) => apt.status == 'sold').length;

    final roomBreakdown = <int, int>{};
    for (final apt in apartments) {
      final rooms = apt.rooms;
      roomBreakdown[rooms] = (roomBreakdown[rooms] ?? 0) + 1;
    }

    return InventoryDetailData(
      total: apartments.length,
      available: available,
      reserved: reserved,
      sold: sold,
      roomBreakdown: roomBreakdown,
    );
  }

  static List<PaymentsChartData> _buildPaymentsChart({
    required List<AnalyticsPayment> payments,
    required DateTime from,
    required DateTime to,
  }) {
    if (payments.isEmpty) return const [];

    final filtered = payments.where((payment) {
      final date = payment.paymentDate;
      if (date == null) return false;
      final normalized = DateTime(date.year, date.month, date.day);
      final start = DateTime(from.year, from.month, from.day);
      final end = DateTime(to.year, to.month, to.day);
      return !normalized.isBefore(start) && !normalized.isAfter(end);
    }).toList();

    final monthly = <int, _MonthlyPayments>{};
    for (final payment in filtered) {
      final date = payment.paymentDate;
      if (date == null) continue;
      final key = date.year * 100 + date.month;
      final entry = monthly.putIfAbsent(
        key,
        () => _MonthlyPayments(month: date.month, year: date.year),
      );
      entry.total += payment.amount;
      entry.count += 1;
    }

    final keys = monthly.keys.toList()..sort();
    return keys.map((key) {
      final entry = monthly[key]!;
      final label = uzMonthNames[entry.month - 1];
      return PaymentsChartData(
        label: label,
        total: entry.total,
        count: entry.count,
      );
    }).toList();
  }

  static _PaymentsTotals _calculatePaymentsTotals(
    List<AnalyticsPayment> payments,
    DateTime from,
    DateTime to,
  ) {
    double total = 0;
    int count = 0;
    for (final payment in payments) {
      final date = payment.paymentDate;
      if (date == null) continue;
      final normalized = DateTime(date.year, date.month, date.day);
      final start = DateTime(from.year, from.month, from.day);
      final end = DateTime(to.year, to.month, to.day);
      if (!normalized.isBefore(start) && !normalized.isAfter(end)) {
        total += payment.amount;
        count += 1;
      }
    }
    return _PaymentsTotals(total: total, count: count);
  }

  static List<ContractsDayData> _buildContractsChart(
    List<AnalyticsContract> contracts,
  ) {
    if (contracts.isEmpty) return const [];

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final data = <ContractsDayData>[];

    for (int i = 9; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));
      final key = _dateKey(date);

      final dayContracts = contracts.where((contract) {
        final contractDate = contract.signedAt ?? contract.createdAt;
        if (contractDate == null) return false;
        return _dateKey(contractDate) == key;
      }).toList();

      final signed = dayContracts.where((c) =>
        c.status == 'completed' || c.status == 'active' || c.status == 'signed'
      ).length;
      final cancelled = dayContracts.where((c) =>
        c.status == 'cancelled' || c.status == 'rejected'
      ).length;

      final label = '${date.day} ${uzMonthNames[date.month - 1]}';
      data.add(ContractsDayData.grouped(
        label: label,
        signed: signed,
        cancelled: cancelled,
      ));
    }
    return data;
  }

  static _RevenueBreakdown _buildRevenueBreakdown({
    required List<AnalyticsContract> contracts,
    required List<AnalyticsApartment> apartments,
    required String selectedProjectId,
  }) {
    final projectId = selectedProjectId == 'all'
        ? null
        : int.tryParse(selectedProjectId);

    final filteredApartments = projectId == null
        ? apartments
        : apartments.where((apt) => apt.projectId == projectId).toList();

    final apartmentIds =
        filteredApartments.map((apt) => apt.id).toSet();

    final filteredContracts = projectId == null
        ? contracts
        : contracts
            .where((contract) {
              final aptId = int.tryParse(contract.apartmentId ?? '');
              return aptId != null && apartmentIds.contains(aptId);
            })
            .toList();

    final paidAmount = filteredContracts.fold<double>(
      0,
      (sum, contract) => sum + contract.paidAmount,
    );
    final pendingAmount = filteredContracts.fold<double>(
      0,
      (sum, contract) => sum + contract.remainingAmount,
    );

    final contractApartmentIds = filteredContracts
        .map((contract) => int.tryParse(contract.apartmentId ?? ''))
        .whereType<int>()
        .toSet();

    final availableAmount = filteredApartments
        .where((apt) =>
            apt.status == 'available' && !contractApartmentIds.contains(apt.id))
        .fold<double>(0, (sum, apt) => sum + apt.price);

    return _RevenueBreakdown(
      paid: paidAmount,
      pending: pendingAmount,
      available: availableAmount,
    );
  }

  static (DateTime, DateTime) _normalizeRange(
    DateTime from,
    DateTime to,
  ) {
    if (from.isBefore(to)) {
      return (from, to);
    }
    return (to, from);
  }

  static String? _buildLastUpdatedLabel(DateTime? lastUpdated) {
    if (lastUpdated == null) return null;
    final now = DateTime.now();
    final diff = now.difference(lastUpdated);
    if (diff.inMinutes < 1) {
      return 'analytics_last_updated_now'.tr();
    }
    if (diff.inHours < 1) {
      return 'analytics_last_updated_minutes'.tr(namedArgs: {'minutes': diff.inMinutes.toString()});
    }
    if (diff.inDays < 1) {
      return 'analytics_last_updated_hours'.tr(namedArgs: {'hours': diff.inHours.toString()});
    }
    return 'analytics_last_updated_days'.tr(namedArgs: {'days': diff.inDays.toString()});
  }

  static String _dateKey(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }
}

class _MonthlyPayments {
  final int month;
  final int year;
  double total = 0;
  int count = 0;

  _MonthlyPayments({
    required this.month,
    required this.year,
  });
}

class _PaymentsTotals {
  final double total;
  final int count;

  const _PaymentsTotals({
    required this.total,
    required this.count,
  });
}

class _RevenueBreakdown {
  final double paid;
  final double pending;
  final double available;

  const _RevenueBreakdown({
    required this.paid,
    required this.pending,
    required this.available,
  });
}
