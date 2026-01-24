/// Request model for token refresh.
class RefreshTokenRequest {
  final String refresh;

  const RefreshTokenRequest({
    required this.refresh,
  });

  Map<String, dynamic> toJson() {
    return {
      'refresh': refresh,
    };
  }
}
