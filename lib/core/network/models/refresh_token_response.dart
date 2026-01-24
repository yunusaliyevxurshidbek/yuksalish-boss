/// Response model for token refresh.
class RefreshTokenResponse {
  final String refresh;
  final String access;

  const RefreshTokenResponse({
    required this.refresh,
    required this.access,
  });

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponse(
      refresh: json['refresh'] as String? ?? '',
      access: json['access'] as String? ?? '',
    );
  }
}
