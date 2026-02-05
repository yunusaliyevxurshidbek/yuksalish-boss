class AppConfigModel {
  final String appStoreUrl;
  final String playMarketUrl;
  final String minVersion;
  final String? updatedAt;

  const AppConfigModel({
    required this.appStoreUrl,
    required this.playMarketUrl,
    required this.minVersion,
    this.updatedAt,
  });

  factory AppConfigModel.fromJson(Map<String, dynamic> json) {
    return AppConfigModel(
      appStoreUrl: json['app_store_url'] as String? ?? '',
      playMarketUrl: json['play_market_url'] as String? ?? '',
      minVersion: json['min_version'] as String? ?? '0.0.0',
      updatedAt: json['updated_at'] as String?,
    );
  }
}
