part of 'devices_bloc.dart';

/// Status for the device list loading.
enum DevicesStatus { initial, loading, loaded, error }

/// Status for device operations (terminate, logout all).
enum DeviceOperationStatus {
  idle,
  terminating,
  terminated,
  loggingOutAll,
  loggedOutAll,
  failed,
}

/// State for the devices management screen.
class DevicesState extends Equatable {
  /// Current loading status.
  final DevicesStatus status;

  /// Current operation status.
  final DeviceOperationStatus operationStatus;

  /// The current device (marked with is_current: true).
  final UserDevice? currentDevice;

  /// List of other active sessions.
  final List<UserDevice> otherDevices;

  /// Error message if any.
  final String? errorMessage;

  /// Success message for operations.
  final String? successMessage;

  /// Whether the list is being refreshed.
  final bool isRefreshing;

  /// The device ID currently being operated on.
  final int? operatingDeviceId;

  const DevicesState({
    required this.status,
    required this.operationStatus,
    this.currentDevice,
    required this.otherDevices,
    this.errorMessage,
    this.successMessage,
    this.isRefreshing = false,
    this.operatingDeviceId,
  });

  factory DevicesState.initial() => const DevicesState(
        status: DevicesStatus.initial,
        operationStatus: DeviceOperationStatus.idle,
        otherDevices: [],
      );

  DevicesState copyWith({
    DevicesStatus? status,
    DeviceOperationStatus? operationStatus,
    UserDevice? currentDevice,
    List<UserDevice>? otherDevices,
    String? errorMessage,
    String? successMessage,
    bool? isRefreshing,
    int? operatingDeviceId,
    bool clearErrorMessage = false,
    bool clearSuccessMessage = false,
  }) {
    return DevicesState(
      status: status ?? this.status,
      operationStatus: operationStatus ?? this.operationStatus,
      currentDevice: currentDevice ?? this.currentDevice,
      otherDevices: otherDevices ?? this.otherDevices,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccessMessage ? null : (successMessage ?? this.successMessage),
      isRefreshing: isRefreshing ?? this.isRefreshing,
      operatingDeviceId: operatingDeviceId,
    );
  }

  /// Whether the list is currently loading.
  bool get isLoading => status == DevicesStatus.loading;

  /// Whether the list has been loaded successfully.
  bool get isLoaded => status == DevicesStatus.loaded;

  /// Whether there was an error loading the list.
  bool get hasError => status == DevicesStatus.error;

  /// Whether an operation is in progress.
  bool get isOperating =>
      operationStatus == DeviceOperationStatus.terminating ||
      operationStatus == DeviceOperationStatus.loggingOutAll;

  /// Total number of devices (including current).
  int get totalDevices =>
      (currentDevice != null ? 1 : 0) + otherDevices.length;

  /// Whether there are other devices to manage.
  bool get hasOtherDevices => otherDevices.isNotEmpty;

  @override
  List<Object?> get props => [
        status,
        operationStatus,
        currentDevice,
        otherDevices,
        errorMessage,
        successMessage,
        isRefreshing,
        operatingDeviceId,
      ];
}
