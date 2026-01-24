/// Monthly income data for a project.
class MonthlyProjectIncome {
  final String month;
  final double amount;

  const MonthlyProjectIncome({
    required this.month,
    required this.amount,
  });
}

/// Financial statistics for a project.
class ProjectStats {
  final String projectId;
  final double totalRevenue;
  final double expectedRevenue;
  final double debt;
  final double paidAmount;
  final List<MonthlyProjectIncome> monthlyIncome;

  const ProjectStats({
    required this.projectId,
    required this.totalRevenue,
    required this.expectedRevenue,
    required this.debt,
    required this.paidAmount,
    required this.monthlyIncome,
  });

  /// Calculate collection rate.
  double get collectionRate {
    if (totalRevenue == 0) return 0;
    return (paidAmount / totalRevenue) * 100;
  }

  ProjectStats copyWith({
    String? projectId,
    double? totalRevenue,
    double? expectedRevenue,
    double? debt,
    double? paidAmount,
    List<MonthlyProjectIncome>? monthlyIncome,
  }) {
    return ProjectStats(
      projectId: projectId ?? this.projectId,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      expectedRevenue: expectedRevenue ?? this.expectedRevenue,
      debt: debt ?? this.debt,
      paidAmount: paidAmount ?? this.paidAmount,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
    );
  }
}
