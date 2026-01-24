import '../../../../core/widgets/widgets.dart';

/// Data model for a project in the list.
class ProjectData {
  final String id;
  final String name;
  final String location;
  final int totalUnits;
  final int soldUnits;
  final String status;
  final BadgeType statusType;
  final num totalValue;
  final int completionPercent;

  const ProjectData({
    required this.id,
    required this.name,
    required this.location,
    required this.totalUnits,
    required this.soldUnits,
    required this.status,
    required this.statusType,
    required this.totalValue,
    required this.completionPercent,
  });

  double get salesProgress => soldUnits / totalUnits;
}
