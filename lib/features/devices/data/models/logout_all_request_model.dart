/// Request model for logging out from all devices.
class LogoutAllRequestModel {
  final bool keepCurrent;

  const LogoutAllRequestModel({
    required this.keepCurrent,
  });

  Map<String, dynamic> toJson() {
    return {
      'keep_current': keepCurrent,
    };
  }
}
