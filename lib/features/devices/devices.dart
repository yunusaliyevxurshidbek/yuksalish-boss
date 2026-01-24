/// Devices feature - User Device Management
///
/// This feature provides:
/// - Automatic device registration during authentication
/// - Device management UI (view, remove sessions)
/// - Logout from all devices functionality
library devices;

// Domain - Entities
export 'domain/entities/device_info.dart';
export 'domain/entities/user_device.dart';

// Domain - Repository
export 'domain/repositories/device_repository.dart';

// Domain - Use Cases
export 'domain/usecases/get_user_devices.dart';
export 'domain/usecases/logout_all_devices.dart';
export 'domain/usecases/register_device.dart';
export 'domain/usecases/terminate_session.dart';

// Data - Services
export 'data/services/device_info_service.dart';
export 'data/services/device_registration_helper.dart';

// Presentation - BLoC
export 'presentation/bloc/devices_bloc.dart';
