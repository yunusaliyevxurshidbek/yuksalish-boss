import 'package:dartz/dartz.dart';
import 'package:yuksalish_mobile/core/error/exceptions.dart';
import 'package:yuksalish_mobile/core/error/failures.dart';
import '../../domain/entities/reset_password_response.dart';
import '../../domain/repositories/reset_password_repository.dart';
import '../datasources/remote/reset_password_remote_datasource.dart';

class ResetPasswordRepositoryImpl implements ResetPasswordRepository {
  final ResetPasswordRemoteDataSource remoteDataSource;

  ResetPasswordRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, ResetPasswordResponseEntity>> resetPassword({
    required String phone,
    required String code,
    required String newPassword,
  }) async {
    try {
      final response = await remoteDataSource.resetPassword(
        phone: phone,
        code: code,
        newPassword: newPassword,
      );
      return Right(response.toEntity());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerExceptions catch (e) {
      if (e.statusCode == 400 || e.statusCode == 422) {
        return Left(ValidationFailure(e.message));
      }
      return Left(ServerFailure(_withStatusCode(e.message, e.statusCode)));
    } catch (_) {
      return const Left(ServerFailure('Unexpected error occurred.'));
    }
  }

  String _withStatusCode(String message, int? statusCode) {
    if (statusCode == null) return message;
    return '($statusCode) $message';
  }
}
