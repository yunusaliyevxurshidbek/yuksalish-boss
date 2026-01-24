import 'package:dartz/dartz.dart';
import 'package:yuksalish_mobile/core/error/failures.dart';
import '../entities/verify_otp_response.dart';

abstract class VerifyOtpRepository {
  Future<Either<Failure, VerifyOtpResponseEntity>> verifyOtp({
    required String phone,
    required String code,
    required String name,
  });
}
