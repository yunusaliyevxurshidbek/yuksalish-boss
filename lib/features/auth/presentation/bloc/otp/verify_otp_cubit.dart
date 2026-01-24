import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yuksalish_mobile/core/error/exceptions.dart';
import 'package:yuksalish_mobile/core/services/my_shared_preferences.dart';
import '../../../domain/usecases/verify_otp.dart';
import 'verify_otp_state.dart';

class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  final VerifyOtp _verifyOtp;

  VerifyOtpCubit(this._verifyOtp) : super(const VerifyOtpInitial());

  Future<void> submit({
    required String phone,
    required String code,
    required String name,
  }) async {
    emit(const VerifyOtpLoading());
    try {
      final result = await _verifyOtp(
        VerifyOtpParams(
          phone: phone,
          code: code,
          name: name,
        ),
      );
      result.fold(
        (failure) => emit(VerifyOtpError(failure.message)),
        (response) async {
          await MySharedPreferences.setId(response.user.id);
          await MySharedPreferences.setPhone(response.user.phone);
          emit(
            VerifyOtpSuccess(
              message: response.message,
              user: response.user,
              needsPassword: response.needsPassword,
            ),
          );
        },
      );
    } on NetworkException catch (e) {
      emit(VerifyOtpError(e.message));
    } on ServerExceptions catch (e) {
      emit(VerifyOtpError(e.message));
    } catch (_) {
      emit(const VerifyOtpError('Unexpected error occurred.'));
    }
  }
}
