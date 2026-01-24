import 'package:dartz/dartz.dart';
import 'package:yuksalish_mobile/core/error/failures.dart';
import '../entities/login_response.dart';

abstract class LoginRepository {
  Future<Either<Failure, LoginResponseEntity>> login({
    required String phone,
    required String password,
  });
}
