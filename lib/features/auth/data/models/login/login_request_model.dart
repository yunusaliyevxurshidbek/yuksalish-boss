class LoginRequestModel {
  final String phone;
  final String password;
  final String? deviceId;
  final String? platform;
  final String? deviceModel;
  final String? osVersion;
  final String? appVersion;
  final String? pushToken;

  const LoginRequestModel({
    required this.phone,
    required this.password,
    this.deviceId,
    this.platform,
    this.deviceModel,
    this.osVersion,
    this.appVersion,
    this.pushToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'password': password,
      if (deviceId != null) 'device_id': deviceId,
      if (platform != null) 'platform': platform,
      if (deviceModel != null) 'device_model': deviceModel,
      if (osVersion != null) 'os_version': osVersion,
      if (appVersion != null) 'app_version': appVersion,
      if (pushToken != null) 'push_token': pushToken,
    };
  }
}
