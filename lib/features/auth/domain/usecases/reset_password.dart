import 'package:dartz/dartz.dart';
import 'package:yuksalish_mobile/core/error/failures.dart';
import '../entities/reset_password_response.dart';
import '../repositories/reset_password_repository.dart';

class ResetPasswordUseCase {
  final ResetPasswordRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<Either<Failure, ResetPasswordResponseEntity>> call({
    required String phone,
    required String code,
    required String newPassword,
  }) {
    return repository.resetPassword(
      phone: phone,
      code: code,
      newPassword: newPassword,
    );
  }
}
