import 'package:easy_localization/easy_localization.dart';

/// Period filter options for analytics.
enum AnalyticsPeriod {
  last30Days,
  last3Months,
  last6Months,
  lastYear,
  allTime,
}

extension AnalyticsPeriodX on AnalyticsPeriod {
  String get label {
    switch (this) {
      case AnalyticsPeriod.last30Days:
        return 'analytics_period_30_days'.tr();
      case AnalyticsPeriod.last3Months:
        return 'analytics_period_3_months'.tr();
      case AnalyticsPeriod.last6Months:
        return 'analytics_period_6_months'.tr();
      case AnalyticsPeriod.lastYear:
        return 'analytics_period_year'.tr();
      case AnalyticsPeriod.allTime:
        return 'analytics_period_all_time'.tr();
    }
  }

  /// API accepts only: this_month | last_quarter | year_to_date.
  /// We map longer ranges to the closest supported period.
  String get apiValue {
    switch (this) {
      case AnalyticsPeriod.last30Days:
        return 'this_month';
      case AnalyticsPeriod.last3Months:
        return 'last_quarter';
      case AnalyticsPeriod.last6Months:
        return 'year_to_date';
      case AnalyticsPeriod.lastYear:
        return 'year_to_date';
      case AnalyticsPeriod.allTime:
        return 'year_to_date';
    }
  }

  int? get months {
    switch (this) {
      case AnalyticsPeriod.last30Days:
        return 1;
      case AnalyticsPeriod.last3Months:
        return 3;
      case AnalyticsPeriod.last6Months:
        return 6;
      case AnalyticsPeriod.lastYear:
        return 12;
      case AnalyticsPeriod.allTime:
        return null;
    }
  }
}
