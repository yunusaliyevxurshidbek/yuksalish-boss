import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:yuksalish_mobile/core/error/failures.dart';
import '../entities/register_response.dart';
import '../repositories/register_repository.dart';

class SendRegisterCode {
  final RegisterRepository repository;

  SendRegisterCode(this.repository);

  Future<Either<Failure, RegisterResponseEntity>> call(
    SendRegisterCodeParams params,
  ) async {
    return await repository.sendRegisterCode(
      phone: params.phone,
      source: params.source,
    );
  }
}

class SendRegisterCodeParams extends Equatable {
  final String phone;
  final String source;

  const SendRegisterCodeParams({
    required this.phone,
    this.source = 'website',
  });

  @override
  List<Object?> get props => [phone, source];
}
