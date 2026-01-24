/// Builder history model for past projects from API.
class BuilderHistoryModel {
  final int id;
  final String title;
  final String? description;
  final String location;
  final String? image;
  final String? startDate;
  final String? expectedCompletion;
  final String? actualCompletion;
  final int totalUnits;
  final String? soldDuration;
  final int likes;
  final int reviews;

  const BuilderHistoryModel({
    required this.id,
    required this.title,
    this.description,
    required this.location,
    this.image,
    this.startDate,
    this.expectedCompletion,
    this.actualCompletion,
    this.totalUnits = 0,
    this.soldDuration,
    this.likes = 0,
    this.reviews = 0,
  });

  /// Parse from API JSON response.
  factory BuilderHistoryModel.fromJson(Map<String, dynamic> json) {
    return BuilderHistoryModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      location: json['location'] as String? ?? '',
      image: json['image'] as String?,
      startDate: json['start_date'] as String?,
      expectedCompletion: json['expected_completion'] as String?,
      actualCompletion: json['actual_completion'] as String?,
      totalUnits: json['total_units'] as int? ?? 0,
      soldDuration: json['sold_duration'] as String?,
      likes: json['likes'] as int? ?? 0,
      reviews: json['reviews'] as int? ?? 0,
    );
  }

  /// Convert to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'image': image,
      'start_date': startDate,
      'expected_completion': expectedCompletion,
      'actual_completion': actualCompletion,
      'total_units': totalUnits,
      'sold_duration': soldDuration,
      'likes': likes,
      'reviews': reviews,
    };
  }

  /// Check if the project is completed.
  bool get isCompleted => actualCompletion != null;

  BuilderHistoryModel copyWith({
    int? id,
    String? title,
    String? description,
    String? location,
    String? image,
    String? startDate,
    String? expectedCompletion,
    String? actualCompletion,
    int? totalUnits,
    String? soldDuration,
    int? likes,
    int? reviews,
  }) {
    return BuilderHistoryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      image: image ?? this.image,
      startDate: startDate ?? this.startDate,
      expectedCompletion: expectedCompletion ?? this.expectedCompletion,
      actualCompletion: actualCompletion ?? this.actualCompletion,
      totalUnits: totalUnits ?? this.totalUnits,
      soldDuration: soldDuration ?? this.soldDuration,
      likes: likes ?? this.likes,
      reviews: reviews ?? this.reviews,
    );
  }
}
