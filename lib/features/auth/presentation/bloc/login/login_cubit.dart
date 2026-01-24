import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yuksalish_mobile/core/error/exceptions.dart';
import 'package:yuksalish_mobile/core/services/my_shared_preferences.dart';
import '../../../../devices/data/services/device_info_service.dart';
import '../../../../devices/domain/usecases/register_device.dart';
import '../../../data/datasources/remote/company_remote_datasource.dart';
import '../../../domain/usecases/login_user.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUser _loginUser;
  final CompanyRemoteDataSource _companyDataSource;
  final DeviceInfoService _deviceInfoService;
  final RegisterDevice _registerDevice;

  LoginCubit(
    this._loginUser,
    this._companyDataSource,
    this._deviceInfoService,
    this._registerDevice,
  ) : super(const LoginInitial());

  Future<void> login({
    required String phone,
    required String password,
  }) async {
    emit(const LoginLoading());
    try {
      // Get device info with push token for login
      final deviceInfo = await _deviceInfoService.getDeviceInfo();
      log('[LOGIN] Device info: ${deviceInfo.deviceId}, push_token: ${deviceInfo.pushToken != null ? 'present' : 'null'}');

      final result = await _loginUser(
        LoginUserParams(
          phone: phone,
          password: password,
          deviceInfo: deviceInfo,
        ),
      );
      result.fold(
        (failure) => emit(LoginError(failure.message)),
        (response) async {
          await MySharedPreferences.setId(response.user.id);
          await MySharedPreferences.setPhone(response.user.phone);
          final fullName = response.user.fullName;
          if (fullName.isNotEmpty) {
            await MySharedPreferences.setName(fullName);
          }
          final accessToken = response.accessToken.trim();
          if (accessToken.isNotEmpty) {
            await MySharedPreferences.setToken(accessToken);
          }
          final refreshToken = response.refreshToken.trim();
          if (refreshToken.isNotEmpty) {
            await MySharedPreferences.setRefreshToken(refreshToken);
          }

          // Fetch and store company ID
          await _fetchAndStoreCompanyId();

          // Register current device with backend
          await _registerCurrentDevice();

          emit(
            LoginSuccess(
              message: response.message,
              userId: response.user.id,
              phone: response.user.phone,
              role: response.user.role,
            ),
          );
        },
      );
    } on NetworkException catch (e) {
      emit(LoginError(e.message));
    } on ServerExceptions catch (e) {
      emit(LoginError(e.message));
    } catch (_) {
      emit(const LoginError('Unexpected error occurred.'));
    }
  }

  Future<void> _fetchAndStoreCompanyId() async {
    try {
      log('[LOGIN] Fetching companies...');
      final companies = await _companyDataSource.getMyCompanies();
      log('[LOGIN] Found ${companies.length} companies');
      if (companies.isNotEmpty) {
        final companyId = companies.first.id;
        await MySharedPreferences.setCompanyId(companyId);
        log('[LOGIN] Stored company ID: $companyId');
      } else {
        log('[LOGIN] WARNING: No companies found for user!');
      }
    } catch (e) {
      log('[LOGIN] ERROR fetching companies: $e');
    }
  }

  Future<void> _registerCurrentDevice() async {
    try {
      log('[LOGIN] Registering device...');
      final deviceInfo = await _deviceInfoService.getDeviceInfo();
      final result = await _registerDevice(
        RegisterDeviceParams(deviceInfo: deviceInfo),
      );
      result.fold(
        (failure) => log('[LOGIN] Device registration failed: ${failure.message}'),
        (device) => log('[LOGIN] Device registered successfully: ${device.id}'),
      );
    } catch (e) {
      log('[LOGIN] Device registration error: $e');
    }
  }
}
