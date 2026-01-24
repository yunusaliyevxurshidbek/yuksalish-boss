import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/device_info.dart';
import '../../domain/entities/user_device.dart';
import '../../domain/repositories/device_repository.dart';
import '../datasources/device_remote_datasource.dart';
import '../models/logout_all_request_model.dart';
import '../models/register_device_request_model.dart';

/// Implementation of [DeviceRepository] using remote data source.
class DeviceRepositoryImpl implements DeviceRepository {
  final DeviceRemoteDataSource remoteDataSource;

  DeviceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserDevice>> registerDevice(
    DeviceInfo deviceInfo,
  ) async {
    try {
      final request = RegisterDeviceRequestModel.fromDeviceInfo(deviceInfo);
      final response = await remoteDataSource.registerDevice(request);
      return Right(response.toEntity());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerExceptions catch (e) {
      if (e.statusCode == 400 || e.statusCode == 422) {
        return Left(ValidationFailure(e.message));
      }
      return Left(ServerFailure(_withStatusCode(e.message, e.statusCode)));
    } catch (_) {
      return const Left(ServerFailure('Unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, List<UserDevice>>> getUserDevices(
    String currentDeviceId,
  ) async {
    try {
      final response = await remoteDataSource.getUserDevices(currentDeviceId);
      final devices = response.map((model) => model.toEntity()).toList();

      // Sort devices: current device first, then by last active (most recent first)
      devices.sort((a, b) {
        if (a.isCurrent && !b.isCurrent) return -1;
        if (!a.isCurrent && b.isCurrent) return 1;
        return b.lastActive.compareTo(a.lastActive);
      });

      return Right(devices);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerExceptions catch (e) {
      return Left(ServerFailure(_withStatusCode(e.message, e.statusCode)));
    } catch (_) {
      return const Left(ServerFailure('Unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, void>> terminateSession(int deviceId) async {
    try {
      await remoteDataSource.terminateSession(deviceId);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerExceptions catch (e) {
      if (e.statusCode == 404) {
        return const Left(ServerFailure('Device session not found.'));
      }
      return Left(ServerFailure(_withStatusCode(e.message, e.statusCode)));
    } catch (_) {
      return const Left(ServerFailure('Unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, void>> logoutAllDevices({
    required String currentDeviceId,
    required bool keepCurrent,
  }) async {
    try {
      final request = LogoutAllRequestModel(keepCurrent: keepCurrent);
      await remoteDataSource.logoutAllDevices(
        currentDeviceId: currentDeviceId,
        request: request,
      );
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerExceptions catch (e) {
      return Left(ServerFailure(_withStatusCode(e.message, e.statusCode)));
    } catch (_) {
      return const Left(ServerFailure('Unexpected error occurred.'));
    }
  }

  String _withStatusCode(String message, int? statusCode) {
    if (statusCode == null) return message;
    return '($statusCode) $message';
  }
}
