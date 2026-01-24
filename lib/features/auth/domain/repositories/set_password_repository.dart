import 'package:dartz/dartz.dart';
import 'package:yuksalish_mobile/core/error/failures.dart';
import '../entities/set_password_response.dart';

abstract class SetPasswordRepository {
  Future<Either<Failure, SetPasswordResponseEntity>> setPassword({
    required String phone,
    required String password,
  });
}
