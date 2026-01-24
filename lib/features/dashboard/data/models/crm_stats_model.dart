import 'dashboard_metrics.dart';

/// Model for CRM stats API response
class CrmStatsModel {
  final double totalRevenue;
  final int activeLeads;
  final int apartmentsSold;
  final double conversionRate;
  final double revenueTrend;
  final double leadsTrend;
  final double apartmentsTrend;
  final double conversionTrend;
  final double currentMonthRevenue;
  final int totalClients;
  final int totalLeads;
  final int totalContracts;
  final int activeContracts;
  final int completedContracts;
  final double totalPaid;
  final double pendingPayments;
  final double overduePayments;
  final Map<String, int> leadsByStage;
  final Map<String, int> contractsByStatus;
  final List<MonthlySalesModel> monthlySales;

  const CrmStatsModel({
    required this.totalRevenue,
    required this.activeLeads,
    required this.apartmentsSold,
    required this.conversionRate,
    required this.revenueTrend,
    required this.leadsTrend,
    required this.apartmentsTrend,
    required this.conversionTrend,
    required this.currentMonthRevenue,
    required this.totalClients,
    required this.totalLeads,
    required this.totalContracts,
    required this.activeContracts,
    required this.completedContracts,
    required this.totalPaid,
    required this.pendingPayments,
    required this.overduePayments,
    required this.leadsByStage,
    required this.contractsByStatus,
    required this.monthlySales,
  });

  factory CrmStatsModel.fromJson(Map<String, dynamic> json) {
    return CrmStatsModel(
      totalRevenue: (json['total_revenue'] as num?)?.toDouble() ?? 0,
      activeLeads: json['active_leads'] as int? ?? 0,
      apartmentsSold: json['apartments_sold'] as int? ?? 0,
      conversionRate: (json['conversion_rate'] as num?)?.toDouble() ?? 0,
      revenueTrend: (json['revenue_trend'] as num?)?.toDouble() ?? 0,
      leadsTrend: (json['leads_trend'] as num?)?.toDouble() ?? 0,
      apartmentsTrend: (json['apartments_trend'] as num?)?.toDouble() ?? 0,
      conversionTrend: (json['conversion_trend'] as num?)?.toDouble() ?? 0,
      currentMonthRevenue:
          (json['current_month_revenue'] as num?)?.toDouble() ?? 0,
      totalClients: json['total_clients'] as int? ?? 0,
      totalLeads: json['total_leads'] as int? ?? 0,
      totalContracts: json['total_contracts'] as int? ?? 0,
      activeContracts: json['active_contracts'] as int? ?? 0,
      completedContracts: json['completed_contracts'] as int? ?? 0,
      totalPaid: (json['total_paid'] as num?)?.toDouble() ?? 0,
      pendingPayments: (json['pending_payments'] as num?)?.toDouble() ?? 0,
      overduePayments: (json['overdue_payments'] as num?)?.toDouble() ?? 0,
      leadsByStage: _parseIntMap(json['leads_by_stage']),
      contractsByStatus: _parseIntMap(json['contracts_by_status']),
      monthlySales: _parseMonthlySales(json['monthly_sales']),
    );
  }

  factory CrmStatsModel.empty() => const CrmStatsModel(
        totalRevenue: 0,
        activeLeads: 0,
        apartmentsSold: 0,
        conversionRate: 0,
        revenueTrend: 0,
        leadsTrend: 0,
        apartmentsTrend: 0,
        conversionTrend: 0,
        currentMonthRevenue: 0,
        totalClients: 0,
        totalLeads: 0,
        totalContracts: 0,
        activeContracts: 0,
        completedContracts: 0,
        totalPaid: 0,
        pendingPayments: 0,
        overduePayments: 0,
        leadsByStage: {},
        contractsByStatus: {},
        monthlySales: [],
      );

  static Map<String, int> _parseIntMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data.map((key, value) => MapEntry(key, (value as num).toInt()));
    }
    return {};
  }

  static List<MonthlySalesModel> _parseMonthlySales(dynamic data) {
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map((json) => MonthlySalesModel.fromJson(json))
          .toList();
    }
    return [];
  }

  DashboardMetrics toDashboardMetrics() {
    return DashboardMetrics(
      totalRevenue: totalRevenue,
      revenueChange: revenueTrend / 100,
      activeLeads: activeLeads,
      leadsChange: leadsTrend / 100,
      soldApartments: apartmentsSold,
      soldChange: apartmentsTrend / 100,
      conversionRate: conversionRate / 100,
      conversionChange: conversionTrend / 100,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_revenue': totalRevenue,
      'active_leads': activeLeads,
      'apartments_sold': apartmentsSold,
      'conversion_rate': conversionRate,
      'revenue_trend': revenueTrend,
      'leads_trend': leadsTrend,
      'apartments_trend': apartmentsTrend,
      'conversion_trend': conversionTrend,
      'current_month_revenue': currentMonthRevenue,
      'total_clients': totalClients,
      'total_leads': totalLeads,
      'total_contracts': totalContracts,
      'active_contracts': activeContracts,
      'completed_contracts': completedContracts,
      'total_paid': totalPaid,
      'pending_payments': pendingPayments,
      'overdue_payments': overduePayments,
      'leads_by_stage': leadsByStage,
      'contracts_by_status': contractsByStatus,
      'monthly_sales': monthlySales.map((e) => e.toJson()).toList(),
    };
  }
}

class MonthlySalesModel {
  final String name;
  final int month;
  final int year;
  final double amount;
  final int contractsCount;

  const MonthlySalesModel({
    required this.name,
    required this.month,
    required this.year,
    required this.amount,
    required this.contractsCount,
  });

  factory MonthlySalesModel.fromJson(Map<String, dynamic> json) {
    return MonthlySalesModel(
      name: json['name'] as String? ?? '',
      month: json['month'] as int? ?? 0,
      year: json['year'] as int? ?? 0,
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      contractsCount: json['contracts_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'month': month,
      'year': year,
      'amount': amount,
      'contracts_count': contractsCount,
    };
  }
}
