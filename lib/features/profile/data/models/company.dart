import 'package:equatable/equatable.dart';

/// Company model representing the user's organization.
class Company extends Equatable {
  final String id;
  final String name;
  final String? logoUrl;

  const Company({
    required this.id,
    required this.name,
    this.logoUrl,
  });

  /// Creates a copy with updated fields.
  Company copyWith({
    String? id,
    String? name,
    String? logoUrl,
  }) {
    return Company(
      id: id ?? this.id,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
    );
  }

  /// Creates from JSON map.
  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'] as String,
      name: json['name'] as String,
      logoUrl: json['logo_url'] as String?,
    );
  }

  /// Converts to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo_url': logoUrl,
    };
  }

  @override
  List<Object?> get props => [id, name, logoUrl];
}
