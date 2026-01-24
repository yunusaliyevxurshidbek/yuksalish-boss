import 'package:dartz/dartz.dart';
import 'package:yuksalish_mobile/core/error/failures.dart';
import '../entities/reset_password_response.dart';

abstract class ResetPasswordRepository {
  Future<Either<Failure, ResetPasswordResponseEntity>> resetPassword({
    required String phone,
    required String code,
    required String newPassword,
  });
}
