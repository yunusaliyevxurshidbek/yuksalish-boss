/// Project status enum matching API values.
enum ProjectStatus {
  underConstruction,
  ready,
  presale,
  active,
  completed,
  suspended,
}

/// Extension to get display text and parse from API.
extension ProjectStatusExtension on ProjectStatus {
  String get displayName {
    switch (this) {
      case ProjectStatus.underConstruction:
        return 'Qurilish jarayonida';
      case ProjectStatus.ready:
        return 'Tayyor';
      case ProjectStatus.presale:
        return 'Oldindan sotuv';
      case ProjectStatus.active:
        return 'Faol';
      case ProjectStatus.completed:
        return 'Yakunlangan';
      case ProjectStatus.suspended:
        return "To'xtatilgan";
    }
  }

  String get shortName {
    switch (this) {
      case ProjectStatus.underConstruction:
        return 'Faol';
      case ProjectStatus.ready:
        return 'Tayyor';
      case ProjectStatus.presale:
        return 'Oldindan';
      case ProjectStatus.active:
        return 'Faol';
      case ProjectStatus.completed:
        return 'Tugallangan';
      case ProjectStatus.suspended:
        return "To'xtatilgan";
    }
  }

  String get badgeLabel {
    switch (this) {
      case ProjectStatus.underConstruction:
        return 'QURILISH JARAYONIDA';
      case ProjectStatus.ready:
        return 'TAYYOR';
      case ProjectStatus.presale:
        return 'OLDINDAN SOTUV';
      case ProjectStatus.active:
        return 'FAOL';
      case ProjectStatus.completed:
        return 'YAKUNLANGAN';
      case ProjectStatus.suspended:
        return "TO'XTATILGAN";
    }
  }

  String get apiValue {
    switch (this) {
      case ProjectStatus.underConstruction:
        return 'under_construction';
      case ProjectStatus.ready:
        return 'ready';
      case ProjectStatus.presale:
        return 'presale';
      case ProjectStatus.active:
        return 'active';
      case ProjectStatus.completed:
        return 'completed';
      case ProjectStatus.suspended:
        return 'suspended';
    }
  }

  static ProjectStatus fromString(String? value) {
    if (value == null) return ProjectStatus.underConstruction;

    // Normalize: lowercase and replace spaces with underscores
    final normalized = value.toLowerCase().replaceAll(' ', '_');

    switch (normalized) {
      case 'under_construction':
        return ProjectStatus.underConstruction;
      case 'ready':
        return ProjectStatus.ready;
      case 'presale':
      case 'pre_sale':
        return ProjectStatus.presale;
      case 'active':
        return ProjectStatus.active;
      case 'completed':
        return ProjectStatus.completed;
      case 'suspended':
        return ProjectStatus.suspended;
      default:
        return ProjectStatus.underConstruction;
    }
  }
}

/// Project model representing a construction project.
class Project {
  final int id;
  final String name;
  final String? builder;
  final String location;
  final double? latitude;
  final double? longitude;
  final double? minPrice;
  final String currency;
  final String? image;
  final String? completionDate;
  final int totalUnits;
  final ProjectStatus status;
  final int numberOfBlocks;
  final int numberOfFloors;
  final int soldUnits;
  final int views;
  final int likes;

  const Project({
    required this.id,
    required this.name,
    this.builder,
    required this.location,
    this.latitude,
    this.longitude,
    this.minPrice,
    this.currency = 'UZS',
    this.image,
    this.completionDate,
    required this.totalUnits,
    required this.status,
    this.numberOfBlocks = 1,
    this.numberOfFloors = 1,
    this.soldUnits = 0,
    this.views = 0,
    this.likes = 0,
  });

  /// Parse from API JSON response.
  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      builder: json['builder'] as String?,
      location: json['location'] as String? ?? '',
      latitude: _parseDouble(json['latitude']),
      longitude: _parseDouble(json['longitude']),
      minPrice: _parseDouble(json['min_price']),
      currency: json['currency'] as String? ?? 'UZS',
      image: json['image'] as String?,
      completionDate: json['completion_date'] as String?,
      totalUnits: json['total_units'] as int? ?? 0,
      status: ProjectStatusExtension.fromString(json['status'] as String?),
      numberOfBlocks: json['number_of_blocks'] as int? ?? 1,
      numberOfFloors: json['number_of_floors'] as int? ?? 1,
      soldUnits: json['sold_units'] as int? ?? 0,
      views: json['views'] as int? ?? 0,
      likes: json['likes'] as int? ?? 0,
    );
  }

  /// Convert to JSON for API requests.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'builder': builder,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'min_price': minPrice,
      'currency': currency,
      'image': image,
      'completion_date': completionDate,
      'total_units': totalUnits,
      'status': status.apiValue,
      'number_of_blocks': numberOfBlocks,
      'number_of_floors': numberOfFloors,
      'sold_units': soldUnits,
      'views': views,
      'likes': likes,
    };
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  /// Calculate available units.
  int get availableUnits => totalUnits - soldUnits;

  /// Calculate sold percentage.
  double get soldPercentage {
    if (totalUnits == 0) return 0;
    return (soldUnits / totalUnits) * 100;
  }

  /// Check if project has coordinates for map.
  bool get hasCoordinates => latitude != null && longitude != null;

  /// Extract completion year from date string.
  String get completionYear {
    if (completionDate == null) return '-';
    final match = RegExp(r'\d{4}').firstMatch(completionDate!);
    return match?.group(0) ?? completionDate!;
  }

  Project copyWith({
    int? id,
    String? name,
    String? builder,
    String? location,
    double? latitude,
    double? longitude,
    double? minPrice,
    String? currency,
    String? image,
    String? completionDate,
    int? totalUnits,
    ProjectStatus? status,
    int? numberOfBlocks,
    int? numberOfFloors,
    int? soldUnits,
    int? views,
    int? likes,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      builder: builder ?? this.builder,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      minPrice: minPrice ?? this.minPrice,
      currency: currency ?? this.currency,
      image: image ?? this.image,
      completionDate: completionDate ?? this.completionDate,
      totalUnits: totalUnits ?? this.totalUnits,
      status: status ?? this.status,
      numberOfBlocks: numberOfBlocks ?? this.numberOfBlocks,
      numberOfFloors: numberOfFloors ?? this.numberOfFloors,
      soldUnits: soldUnits ?? this.soldUnits,
      views: views ?? this.views,
      likes: likes ?? this.likes,
    );
  }
}
