import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:yuksalish_mobile/core/error/failures.dart';
import 'package:yuksalish_mobile/core/usecases/usecase.dart';
import 'package:yuksalish_mobile/features/devices/domain/entities/device_info.dart';
import '../entities/login_response.dart';
import '../repositories/login_repository.dart';

class LoginUser extends UseCase<LoginResponseEntity, LoginUserParams> {
  final LoginRepository repository;

  LoginUser(this.repository);

  @override
  Future<Either<Failure, LoginResponseEntity>> call(LoginUserParams params) {
    return repository.login(
      phone: params.phone,
      password: params.password,
      deviceInfo: params.deviceInfo,
    );
  }
}

class LoginUserParams extends Equatable {
  final String phone;
  final String password;
  final DeviceInfo deviceInfo;

  const LoginUserParams({
    required this.phone,
    required this.password,
    required this.deviceInfo,
  });

  @override
  List<Object?> get props => [phone, password, deviceInfo];
}
