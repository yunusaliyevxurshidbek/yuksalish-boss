part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all dashboard data
class LoadDashboard extends DashboardEvent {
  const LoadDashboard();
}

/// Event to refresh dashboard data (pull-to-refresh)
class RefreshDashboard extends DashboardEvent {
  const RefreshDashboard();
}

/// Event to change the filter period
class ChangePeriod extends DashboardEvent {
  final DashboardPeriod period;

  const ChangePeriod(this.period);

  @override
  List<Object?> get props => [period];
}
