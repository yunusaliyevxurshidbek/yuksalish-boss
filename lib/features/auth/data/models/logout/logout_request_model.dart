class LogoutRequestModel {
  final String refresh;

  const LogoutRequestModel({
    required this.refresh,
  });

  Map<String, dynamic> toJson() {
    return {
      'refresh': refresh,
    };
  }
}
