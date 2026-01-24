import 'package:dartz/dartz.dart';
import 'package:yuksalish_mobile/core/error/failures.dart';
import '../entities/forgot_password_response.dart';

abstract class ForgotPasswordRepository {
  Future<Either<Failure, ForgotPasswordResponseEntity>> sendForgotPasswordCode({
    required String phone,
    required String source,
  });
}
