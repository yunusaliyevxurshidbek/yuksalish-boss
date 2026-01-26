part of 'analytics_bloc.dart';

/// Base class for analytics events
sealed class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load analytics data
class LoadAnalytics extends AnalyticsEvent {
  const LoadAnalytics();
}

/// Event to refresh all analytics data
class RefreshAnalytics extends AnalyticsEvent {
  const RefreshAnalytics();
}

/// Event to change the period filter (stats only)
class ChangePeriod extends AnalyticsEvent {
  final AnalyticsPeriod period;

  const ChangePeriod(this.period);

  @override
  List<Object?> get props => [period];
}

/// Event to update payments date range
class ChangePaymentsDateRange extends AnalyticsEvent {
  final DateTime from;
  final DateTime to;

  const ChangePaymentsDateRange({
    required this.from,
    required this.to,
  });

  @override
  List<Object?> get props => [from, to];
}

/// Event to change project filter for revenue breakdown
class ChangeProjectFilter extends AnalyticsEvent {
  final String projectId;

  const ChangeProjectFilter(this.projectId);

  @override
  List<Object?> get props => [projectId];
}

/// Event to refresh contracts data
class RefreshContracts extends AnalyticsEvent {
  const RefreshContracts();
}

/// Event to refresh revenue breakdown data (contracts + apartments)
class RefreshRevenueBreakdown extends AnalyticsEvent {
  const RefreshRevenueBreakdown();
}

/// Event to export analytics as PDF
class ExportAnalyticsPdf extends AnalyticsEvent {
  final PdfTranslations translations;

  const ExportAnalyticsPdf({required this.translations});

  @override
  List<Object?> get props => [translations];
}

/// Event to clear export status (after showing toast)
class ClearExportStatus extends AnalyticsEvent {
  const ClearExportStatus();
}
