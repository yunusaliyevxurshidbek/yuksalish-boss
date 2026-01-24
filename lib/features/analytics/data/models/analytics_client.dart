import 'package:equatable/equatable.dart';

/// Client model used for lead sources analytics.
class AnalyticsClient extends Equatable {
  final int id;
  final String name;
  final String source;
  final DateTime? createdAt;

  const AnalyticsClient({
    required this.id,
    required this.name,
    required this.source,
    this.createdAt,
  });

  factory AnalyticsClient.fromJson(Map<String, dynamic> json) {
    return AnalyticsClient(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      source: json['source'] as String? ?? 'other',
      createdAt: _parseDate(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'source': source,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  static DateTime? _parseDate(dynamic value) {
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  @override
  List<Object?> get props => [id, name, source, createdAt];
}
