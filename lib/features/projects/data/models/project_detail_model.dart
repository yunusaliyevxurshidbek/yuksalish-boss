/// Model for floor plan data.
class FloorPlanModel {
  final String id;
  final String name;
  final String area;
  final String imageUrl;
  final int rooms;

  const FloorPlanModel({
    required this.id,
    required this.name,
    required this.area,
    required this.imageUrl,
    required this.rooms,
  });
}

/// Mock model for project detail data.
class ProjectDetailModel {
  final String id;
  final String name;
  final String location;
  final String imageUrl;
  final String status;
  final String deliveryDate;
  final int totalUnits;
  final int soldUnits;
  final String startPrice;
  final String ceilingHeight;
  final int constructionProgress;
  final String description;
  final List<String> galleryImages;
  final List<FloorPlanModel> floorPlans;

  const ProjectDetailModel({
    required this.id,
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.status,
    required this.deliveryDate,
    required this.totalUnits,
    required this.soldUnits,
    required this.startPrice,
    required this.ceilingHeight,
    required this.constructionProgress,
    required this.description,
    required this.galleryImages,
    required this.floorPlans,
  });

  double get salesProgress => soldUnits / totalUnits;
  int get availableUnits => totalUnits - soldUnits;
}
