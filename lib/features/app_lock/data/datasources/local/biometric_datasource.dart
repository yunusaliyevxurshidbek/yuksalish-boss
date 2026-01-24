import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

/// Custom exception for biometric errors
class BiometricException implements Exception {
  final String message;
  BiometricException(this.message);

  @override
  String toString() => message;
}

/// Data source for biometric authentication using local_auth
abstract class BiometricDataSource {
  /// Check if device supports biometric authentication
  Future<bool> isDeviceSupported();

  /// Check if biometrics are enrolled
  Future<bool> areBiometricsEnrolled();

  /// Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics();

  /// Perform biometric authentication
  Future<bool> authenticate({required String localizedReason});
}

class BiometricDataSourceImpl implements BiometricDataSource {
  final LocalAuthentication _localAuth;

  BiometricDataSourceImpl({LocalAuthentication? localAuth})
      : _localAuth = localAuth ?? LocalAuthentication();

  @override
  Future<bool> isDeviceSupported() async {
    try {
      return await _localAuth.isDeviceSupported();
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> areBiometricsEnrolled() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> authenticate({required String localizedReason}) async {
    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
          useErrorDialogs: true,
        ),
      );
      return authenticated;
    } on Exception catch (e) {
      // Handle specific biometric errors
      final errorString = e.toString();
      if (errorString.contains(auth_error.notAvailable)) {
        throw BiometricException('Biometrik bu qurilmada mavjud emas');
      } else if (errorString.contains(auth_error.notEnrolled)) {
        throw BiometricException("Biometrik ro'yxatdan o'tmagan");
      } else if (errorString.contains(auth_error.lockedOut)) {
        throw BiometricException('Biometrik autentifikatsiya bloklangan');
      } else if (errorString.contains(auth_error.permanentlyLockedOut)) {
        throw BiometricException('Biometrik autentifikatsiya doimiy bloklangan');
      }
      return false;
    }
  }
}
