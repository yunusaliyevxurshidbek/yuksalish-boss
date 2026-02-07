import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yuksalish_mobile/core/error/exceptions.dart';
import '../../../domain/usecases/send_register_code.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final SendRegisterCode _sendRegisterCode;

  RegisterCubit(this._sendRegisterCode) : super(const RegisterInitial());

  Future<void> submit({
    required String phone,
    String source = 'website',
  }) async {
    emit(const RegisterLoading());
    try {
      final result = await _sendRegisterCode(
        SendRegisterCodeParams(
          phone: phone,
          source: source,
        ),
      );
      result.fold(
        (failure) {
          final msg = failure.message.toLowerCase();
          if (_isPhoneExistsMessage(msg)) {
            emit(RegisterPhoneExists(
              message: failure.message,
              phone: phone,
            ));
          } else {
            emit(RegisterError(failure.message));
          }
        },
        (response) => emit(
          RegisterSuccess(
            message: response.message,
            phone: response.phone.isNotEmpty ? response.phone : phone,
            expiresIn: response.expiresIn,
          ),
        ),
      );
    } on NetworkException catch (e) {
      emit(RegisterError(e.message));
    } on ServerExceptions catch (e) {
      if (e.isPhoneExists) {
        emit(RegisterPhoneExists(message: e.message, phone: phone));
      } else {
        emit(RegisterError(e.message));
      }
    } catch (_) {
      emit(const RegisterError('Unexpected error occurred.'));
    }
  }

  bool _isPhoneExistsMessage(String message) {
    return message.contains('already registered') ||
        message.contains('already exists') ||
        message.contains('phone exists') ||
        message.contains('phone_exists') ||
        message.contains('user_exists') ||
        message.contains('already_registered');
  }
}
