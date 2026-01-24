import 'package:equatable/equatable.dart';

import 'lead_model.dart';

/// Paginated response model for leads list API
class LeadsPaginatedResponse extends Equatable {
  final int count;
  final String? next;
  final String? previous;
  final List<Lead> results;

  const LeadsPaginatedResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory LeadsPaginatedResponse.fromJson(Map<String, dynamic> json) {
    return LeadsPaginatedResponse(
      count: json['count'] as int,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>)
          .map((e) => Lead.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Check if there's a next page
  bool get hasNextPage => next != null;

  /// Check if there's a previous page
  bool get hasPreviousPage => previous != null;

  /// Empty response
  static const empty = LeadsPaginatedResponse(
    count: 0,
    results: [],
  );

  @override
  List<Object?> get props => [count, next, previous, results];
}
