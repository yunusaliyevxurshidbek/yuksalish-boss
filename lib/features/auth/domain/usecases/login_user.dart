import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:yuksalish_mobile/core/error/failures.dart';
import 'package:yuksalish_mobile/core/usecases/usecase.dart';
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
    );
  }
}

class LoginUserParams extends Equatable {
  final String phone;
  final String password;

  const LoginUserParams({
    required this.phone,
    required this.password,
  });

  @override
  List<Object?> get props => [phone, password];
}
