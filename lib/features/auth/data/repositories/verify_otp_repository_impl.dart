import 'package:dartz/dartz.dart';
import 'package:yuksalish_mobile/core/error/exceptions.dart';
import 'package:yuksalish_mobile/core/error/failures.dart';
import '../../domain/entities/verify_otp_response.dart';
import '../../domain/repositories/verify_otp_repository.dart';
import '../datasources/remote/verify_otp_remote_datasource.dart';

class VerifyOtpRepositoryImpl implements VerifyOtpRepository {
  final VerifyOtpRemoteDataSource remoteDataSource;

  VerifyOtpRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, VerifyOtpResponseEntity>> verifyOtp({
    required String phone,
    required String code,
    required String name,
  }) async {
    try {
      final response = await remoteDataSource.verifyOtp(
        phone: phone,
        code: code,
        name: name,
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
