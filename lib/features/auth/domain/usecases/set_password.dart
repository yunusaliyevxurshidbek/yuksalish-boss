import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:yuksalish_mobile/core/error/failures.dart';
import '../entities/set_password_response.dart';
import '../repositories/set_password_repository.dart';

class SetPassword {
  final SetPasswordRepository repository;

  SetPassword(this.repository);

  Future<Either<Failure, SetPasswordResponseEntity>> call(
    SetPasswordParams params,
  ) async {
    return await repository.setPassword(
      phone: params.phone,
      password: params.password,
    );
  }
}

class SetPasswordParams extends Equatable {
  final String phone;
  final String password;

  const SetPasswordParams({
    required this.phone,
    required this.password,
  });

  @override
  List<Object?> get props => [phone, password];
}
