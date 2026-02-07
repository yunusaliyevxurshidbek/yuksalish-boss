import 'package:dartz/dartz.dart';
import 'package:yuksalish_mobile/core/error/failures.dart';
import '../entities/register_response.dart';

abstract class RegisterRepository {
  Future<Either<Failure, RegisterResponseEntity>> sendRegisterCode({
    required String phone,
    required String source,
  });
}
