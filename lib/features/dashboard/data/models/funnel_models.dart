import 'package:flutter/material.dart';

/// Model for a funnel stage.
class FunnelStage {
  final String name;
  final int count;
  final Color color;
  final List<FunnelClient> clients;

  const FunnelStage({
    required this.name,
    required this.count,
    required this.color,
    required this.clients,
  });
}

/// Model for a client in a funnel stage.
class FunnelClient {
  final String name;
  final String price;

  const FunnelClient({
    required this.name,
    required this.price,
  });
}

/// Model for a KPI metric.
class FunnelKpi {
  final String label;
  final String value;
  final Color valueColor;

  const FunnelKpi({
    required this.label,
    required this.value,
    required this.valueColor,
  });
}
