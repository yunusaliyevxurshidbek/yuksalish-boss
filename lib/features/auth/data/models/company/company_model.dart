class CompanyModel {
  final int id;
  final String name;

  const CompanyModel({
    required this.id,
    required this.name,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
    );
  }
}
