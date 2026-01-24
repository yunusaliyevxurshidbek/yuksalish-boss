import 'package:dartz/dartz.dart';
import 'package:yuksalish_mobile/core/error/failures.dart';
import 'package:yuksalish_mobile/features/devices/domain/entities/device_info.dart';
import '../entities/login_response.dart';

abstract class LoginRepository {
  Future<Either<Failure, LoginResponseEntity>> login({
    required String phone,
    required String password,
    required DeviceInfo deviceInfo,
  });
}
