import 'apartment.dart';

/// Paginated response model for apartments list API.
class ApartmentsPaginatedResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<Apartment> results;

  const ApartmentsPaginatedResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  /// Parse from API JSON response.
  factory ApartmentsPaginatedResponse.fromJson(Map<String, dynamic> json) {
    return ApartmentsPaginatedResponse(
      count: json['count'] as int? ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => Apartment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Check if there's a next page.
  bool get hasNextPage => next != null;

  /// Check if there's a previous page.
  bool get hasPreviousPage => previous != null;

  /// Check if the results are empty.
  bool get isEmpty => results.isEmpty;

  /// Get current page number from next/previous URL.
  int get currentPage {
    if (previous == null) return 1;
    final uri = Uri.tryParse(previous!);
    if (uri == null) return 1;
    final pageParam = uri.queryParameters['page'];
    if (pageParam == null) return 2;
    return (int.tryParse(pageParam) ?? 1) + 1;
  }

  ApartmentsPaginatedResponse copyWith({
    int? count,
    String? next,
    String? previous,
    List<Apartment>? results,
  }) {
    return ApartmentsPaginatedResponse(
      count: count ?? this.count,
      next: next ?? this.next,
      previous: previous ?? this.previous,
      results: results ?? this.results,
    );
  }
}
